//
//  SearchContentUseCase.swift
//  ThmanyahTestApp
//
//  Created by Nour-Eddine Legragui  on 10/3/2026.
//

import Foundation

protocol SearchContentUseCaseProtocol {
    func execute(query: String) async throws -> SearchResult
}

final class SearchContentUseCase: SearchContentUseCaseProtocol {
    private let repository: SearchStoreProtocol

    init(repository: SearchStoreProtocol) {
        self.repository = repository
    }

    func execute(query: String) async throws -> SearchResult {
        let trimmed = query.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !trimmed.isEmpty else {
            return SearchResult(query: query, sections: [], totalCount: 0)
        }
        return try await repository.search(query: trimmed)
    }
}
