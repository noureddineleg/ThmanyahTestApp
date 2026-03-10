//
//  HomeRoute.swift
//  ThmanyahTestApp
//
//  Created by Nour-Eddine Legragui  on 10/3/2026.
//

import SwiftUI

enum HomeRoute: Hashable, Equatable {
    case details(id: String)
    case player(itemID: String)
    case podcastDetails(ContentItem)
    case audioReader(ContentItem)
    case videoReader(ContentItem)
    case search
    case sectionAll(Section)
}

extension HomeRoute {
    @ViewBuilder
    var view: some View {
        switch self {
        case .details(let id):
            Text("Details for item \(id)")
        case .player(let itemID):
            Text("Player for item \(itemID)")
        case .podcastDetails(let item):
            PodcastDetailsView(item: item)
        case .audioReader(let item):
            AudioReaderView(item: item)
        case .videoReader(let item):
            VideoReaderView(item: item)
        case .search:
            SearchViewFactory.make()
        case .sectionAll(let section):
            HomeSectionAllView(section: section)
        }
    }
}
