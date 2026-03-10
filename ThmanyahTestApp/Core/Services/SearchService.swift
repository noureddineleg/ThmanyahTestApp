//
//  SearchService.swift
//  ThmanyahTestApp
//
//  Created by Nour-Eddine Legragui  on 10/3/2026.
//

import Foundation

protocol SearchServiceProtocol {
    func search(query: String) async throws -> SearchResponse
}

final class SearchService: SearchServiceProtocol {
    private let networking: NetworkingManaging

    init(networking: NetworkingManaging) {
        self.networking = networking
    }

    func search(query: String) async throws -> SearchResponse {
        let endpoint = APIEndpoint.search(query: query)
        return try await networking.request(endpoint)
    }
}
