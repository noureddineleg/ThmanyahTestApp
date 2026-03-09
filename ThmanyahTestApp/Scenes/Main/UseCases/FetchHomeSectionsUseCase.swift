//
//  FetchHomeSectionsUseCase.swift
//  ThmanyahTestApp
//
//  Created by Nour-Eddine Legragui  on 9/3/2026.
//

import Foundation

protocol FetchHomeSectionsUseCaseProtocol {
    func execute(page: Int) async throws -> [Section]
}

final class FetchHomeSectionsUseCase: FetchHomeSectionsUseCaseProtocol {
    private let repository: HomeStoreProtocol

    init(repository: HomeStoreProtocol) {
        self.repository = repository
    }

    func execute(page: Int) async throws -> [Section] {
        try await repository.fetchHomeSections(page: page)
    }
}
