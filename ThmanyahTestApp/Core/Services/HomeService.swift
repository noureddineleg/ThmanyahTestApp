//
//  HomeService.swift
//  ThmanyahTestApp
//
//  Created by Nour-Eddine Legragui  on 9/3/2026.
//

import Foundation

protocol HomeServiceProtocol {
    func fetchHomeSections(page: Int) async throws -> HomeSectionsResponse
}

final class HomeService: HomeServiceProtocol {
    private let networking: NetworkingManaging

    init(networking: NetworkingManaging) {
        self.networking = networking
    }

    func fetchHomeSections(page: Int) async throws -> HomeSectionsResponse {
        let endpoint = APIEndpoint.homeSections(page: page)
        return try await networking.request(endpoint)
    }
}
