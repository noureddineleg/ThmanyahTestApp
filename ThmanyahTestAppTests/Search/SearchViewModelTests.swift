//
//  SearchViewModelTests.swift
//  ThmanyahTestApp
//
//  Created by Nour-Eddine Legragui  on 10/3/2026.
//

import XCTest
@testable import ThmanyahTestApp

@MainActor
final class SearchViewModelTests: XCTestCase {
    private var sut: SearchViewModel!
    private var mockUseCase: MockSearchContentUseCase!

    override func setUp() {
        super.setUp()
        mockUseCase = MockSearchContentUseCase()
        sut = SearchViewModel(searchContentUseCase: mockUseCase)
    }

    func test_emptySearch_staysIdle() async throws {
        sut.searchText = "   "
        try await Task.sleep(for: .milliseconds(300))
        XCTAssertEqual(sut.state, .idle)
    }

    func test_searchWithResults_updatesToResults() async throws {
        let result = SearchResult(query: "test", sections: [], totalCount: 0)
        mockUseCase.result = .success(result)

        sut.searchText = "test"
        try await Task.sleep(for: .milliseconds(300))

        if case .results(let returned) = sut.state {
            XCTAssertEqual(returned.query, "test")
        } else {
            XCTFail("Expected results state")
        }
    }

    func test_clearSearch_resetsState() {
        sut.searchText = "query"
        sut.clearSearch()
        XCTAssertTrue(sut.searchText.isEmpty)
        XCTAssertEqual(sut.state, .idle)
    }
}

final class MockSearchContentUseCase: SearchContentUseCaseProtocol {
    var result: Result<SearchResult, Error> = .success(
        SearchResult(query: "", sections: [], totalCount: 0)
    )

    func execute(query: String) async throws -> SearchResult {
        switch result {
        case .success(let value):
            return value
        case .failure(let error):
            throw error
        }
    }
}

