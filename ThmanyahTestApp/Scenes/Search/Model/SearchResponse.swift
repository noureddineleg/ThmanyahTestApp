//
//  SearchResponse.swift
//  ThmanyahTestApp
//
//  Created by Nour-Eddine Legragui  on 10/3/2026.
//

import Foundation

struct SearchResponse: Decodable {
    let query: String
    let sections: [HomeSection]
    let totalCount: Int?

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        query = try container.decodeIfPresent(String.self, forKey: .query) ?? ""
        sections = try container.decodeIfPresent([HomeSection].self, forKey: .sections) ?? []
        totalCount = Self.decodeTotalCount(container)
    }

    private static func decodeTotalCount(_ container: KeyedDecodingContainer<SearchResponse.CodingKeys>) -> Int? {
        if let i = try? container.decode(Int.self, forKey: .totalCount) { return i }
        if let s = try? container.decode(String.self, forKey: .totalCount), let i = Int(s) { return i }
        return nil
    }

    enum CodingKeys: String, CodingKey {
        case query
        case sections
        case totalCount
    }
}
