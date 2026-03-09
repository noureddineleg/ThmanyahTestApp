//
//  DependencyContainer.swift
//  ThmanyahTestApp
//
//  Created by Nour-Eddine Legragui  on 9/3/2026.
//

import Foundation

final class DependencyContainer {
    static let shared = DependencyContainer()

    /// Debug configuration (ThmanyahApp / ThmanyahApp-Debug schemes): mocks / local JSON.
    /// Release configuration (ThmanyahApp-Release / ThmanyahApp-Prod schemes): real APIs.
    /// Xcode only sets DEBUG in Debug builds; Release builds do not define DEBUG.
    #if DEBUG
    private let useMocks = true
    #else
    private let useMocks = false  // Release → real HomeService, SearchService, live API calls
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
//    lazy var searchService: SearchServiceProtocol = {
//        if useMocks {
//            return MockSearchService()
//        } else {
//            return SearchService(networking: networkingManager)
//        }
//    }()
//
//    lazy var searchRepository: SearchRepositoryProtocol = {
//        SearchRepository(service: searchService)
//    }()
//
//    lazy var searchContentUseCase: SearchContentUseCaseProtocol = {
//        SearchContentUseCase(repository: searchRepository)
//    }()

    private init() {}
}

// MARK: - Mocks

private final class MockHomeService: HomeServiceProtocol {
    func fetchHomeSections(page: Int) async throws -> HomeSectionsResponse {
        try await loadJSON(named: "home_sections", type: HomeSectionsResponse.self)
    }
}

//private final class MockSearchService: SearchServiceProtocol {
//    func search(query: String) async throws -> SearchResponseDTO {
//        try await loadJSON(named: "search_results", type: SearchResponseDTO.self)
//    }
//}

private func loadJSON<T: Decodable>(named name: String, type: T.Type) async throws -> T {
    guard let url = Bundle.main.url(forResource: name, withExtension: "json") else {
        throw NetworkError.noData
    }

    let data = try Data(contentsOf: url)
    let decoder = JSONDecoder()
    decoder.keyDecodingStrategy = .convertFromSnakeCase
    return try decoder.decode(T.self, from: data)
}

