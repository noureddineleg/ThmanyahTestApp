//
//  Section.swift
//  ThmanyahTestApp
//
//  Created by Nour-Eddine Legragui  on 9/3/2026.
//

import Foundation

struct Section: Identifiable, Equatable {
    let id: String
    let name: String
    let sectionType: SectionType
    let contentType: ContentType
    let order: Int
    let items: [ContentItem]
    let hasMore: Bool
}

struct SectionItemRow: Identifiable {
    let id: String
    let item: ContentItem
}

extension Section {
    var identifiedItems: [SectionItemRow] {
        items.enumerated().map { SectionItemRow(id: "\(id)-\($0.offset)", item: $0.element) }
    }
}
