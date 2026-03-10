//
//  HomeSection.swift
//  ThmanyahTestApp
//
//  Created by Nour-Eddine Legragui  on 9/3/2026.
//

import Foundation

// MARK: - Home response (Welcome)

struct HomeSectionsResponse: Decodable {
    let sections: [HomeSection]
    let pagination: Pagination?

    init(sections: [HomeSection] = [], pagination: Pagination? = nil) {
        self.sections = sections
        self.pagination = pagination
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        sections = try container.decodeIfPresent([HomeSection].self, forKey: .sections) ?? []
        pagination = try container.decodeIfPresent(Pagination.self, forKey: .pagination)
    }

    private enum CodingKeys: String, CodingKey {
        case sections
        case pagination
    }
}

// MARK: - Pagination

struct Pagination: Decodable {
    let nextPage: String?
    let totalPages: Int?

    enum CodingKeys: String, CodingKey {
        case nextPage
        case totalPages
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        nextPage = try container.decodeIfPresent(String.self, forKey: .nextPage)
        totalPages = try container.decodeIfPresent(Int.self, forKey: .totalPages)
    }
}

// MARK: - Section

struct HomeSection: Decodable {
    let name: String
    let type: String
    let contentType: String
    let order: Int
    let content: [ContentItems]

    enum CodingKeys: String, CodingKey {
        case name
        case type
        case contentType
        case order
        case content
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        name = try container.decodeIfPresent(String.self, forKey: .name) ?? ""
        type = try container.decodeIfPresent(String.self, forKey: .type) ?? "grid"
        contentType = try container.decodeIfPresent(String.self, forKey: .contentType) ?? "podcast"
        order = Self.decodeOrder(container)
        content = Self.decodeContentTolerantly(container)
    }

    /// Decode order as Int or String (search API can send string).
    private static func decodeOrder(_ container: KeyedDecodingContainer<HomeSection.CodingKeys>) -> Int {
        if let i = try? container.decode(Int.self, forKey: .order) { return i }
        if let s = try? container.decode(String.self, forKey: .order), let i = Int(s) { return i }
        return 0
    }

    /// Decode content array; skip any element that fails so one bad item doesn't fail the section.
    private static func decodeContentTolerantly(_ container: KeyedDecodingContainer<HomeSection.CodingKeys>) -> [ContentItems] {
        guard var unkeyed = try? container.nestedUnkeyedContainer(forKey: .content) else { return [] }
        var result: [ContentItems] = []
        while !unkeyed.isAtEnd {
            if let item = try? unkeyed.decode(ContentItems.self) {
                result.append(item)
            } else {
                _ = try? unkeyed.decode(JSONSkip.self)
            }
        }
        return result
    }
}

extension HomeSection {
    var baseSectionIdentifier: String {
        "\(name)-\(type)-\(order)"
    }
}

/// Consumes and discards one JSON value to advance the decoder.
private struct JSONSkip: Decodable {
    init(from decoder: Decoder) throws {
        if var unkeyed = try? decoder.unkeyedContainer() {
            while !unkeyed.isAtEnd { _ = try? unkeyed.decode(JSONSkip.self) }
        } else if let keyed = try? decoder.container(keyedBy: AnyCodingKey.self) {
            for key in keyed.allKeys { _ = try? keyed.decode(JSONSkip.self, forKey: key) }
        } else {
            _ = try decoder.singleValueContainer()
        }
    }
}

private struct AnyCodingKey: CodingKey {
    var stringValue: String
    var intValue: Int?
    init(stringValue: String) { self.stringValue = stringValue; self.intValue = nil }
    init?(intValue: Int) { self.intValue = intValue; self.stringValue = "\(intValue)" }
}
