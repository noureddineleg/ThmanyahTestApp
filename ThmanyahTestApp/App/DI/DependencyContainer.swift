//
//  DependencyContainer.swift
//  ThmanyahTestApp
//
//  Created by Nour-Eddine Legragui  on 9/3/2026.
//

import Foundation

final class DependencyContainer {
    static let shared = DependencyContainer()

    #if DEBUG
    private let useMocks = true
    #else
    private let useMocks = false
    #endif

    // Core
    lazy var networkingManager: NetworkingManaging = NetworkingManager()

    // Home
    lazy var homeService: HomeServiceProtocol = {
        if useMocks {
            return MockHomeService()
        } else {
            return HomeService(networking: networkingManager)
        }
    }()

    lazy var homeRepository: HomeStoreProtocol = {
        HomeStore(service: homeService)
    }()

    lazy var fetchHomeSectionsUseCase: FetchHomeSectionsUseCaseProtocol = {
        FetchHomeSectionsUseCase(repository: homeRepository)
    }()

    // Search
    lazy var searchService: SearchServiceProtocol = {
        if useMocks {
            return MockSearchService()
        } else {
            return SearchService(networking: networkingManager)
        }
    }()

    lazy var searchRepository: SearchStoreProtocol = {
        SearchStore(service: searchService)
    }()

    lazy var searchContentUseCase: SearchContentUseCaseProtocol = {
        SearchContentUseCase(repository: searchRepository)
    }()

    private init() {}
}

// MARK: - Mocks

private final class MockHomeService: HomeServiceProtocol {
    func fetchHomeSections(page: Int) async throws -> HomeSectionsResponse {
        try await loadJSON(named: "home_sections", type: HomeSectionsResponse.self)
    }
}

private final class MockSearchService: SearchServiceProtocol {
    func search(query: String) async throws -> SearchResponse {
        try await loadJSON(named: "search_results", type: SearchResponse.self)
    }
}

private func loadJSON<T: Decodable>(named name: String, type: T.Type) async throws -> T {
    guard let url = Bundle.main.url(forResource: name, withExtension: "json") else {
        throw NetworkError.noData
    }

    let data = try Data(contentsOf: url)
    let decoder = JSONDecoder()
    decoder.keyDecodingStrategy = .convertFromSnakeCase
    return try decoder.decode(T.self, from: data)
}
