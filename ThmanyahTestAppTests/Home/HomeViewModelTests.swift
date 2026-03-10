//
//  ThmanyahTestAppTests.swift
//  ThmanyahTestAppTests
//
//  Created by Nour-Eddine Legragui  on 9/3/2026.
//

import XCTest
@testable import ThmanyahTestApp

@MainActor
final class HomeViewModelTests: XCTestCase {
    private var sut: HomeViewModel!
    private var mockUseCase: MockFetchHomeSectionsUseCase!

    override func setUp() {
        super.setUp()
        mockUseCase = MockFetchHomeSectionsUseCase()
        sut = HomeViewModel(fetchHomeSectionsUseCase: mockUseCase)
    }

    override func tearDown() {
        sut = nil
        mockUseCase = nil
        super.tearDown()
    }

    func test_loadSections_success_updatesToLoaded() async {
        let sections = [
            Section(
                id: "1",
                name: "Test Section",
                sectionType: .grid,
                contentType: .podcast,
                order: 1,
                items: [],
                hasMore: false
            )
        ]
        mockUseCase.result = .success(sections)

        await sut.loadSections()

        if case .loaded(let loaded) = sut.state {
            XCTAssertEqual(loaded.count, 1)
            XCTAssertEqual(loaded.first?.name, "Test Section")
        } else {
            XCTFail("Expected loaded state")
        }
    }

    func test_loadSections_failure_updatesToError() async {
        mockUseCase.result = .failure(NetworkError.serverError(500))

        await sut.loadSections()

        if case .error(let message) = sut.state {
            XCTAssertFalse(message.isEmpty)
        } else {
            XCTFail("Expected error state")
        }
    }

    func test_selectFilter_filtersSections() async {
        let podcastSection = Section(
            id: "1",
            name: "Podcasts",
            sectionType: .grid,
            contentType: .podcast,
            order: 1,
            items: [],
            hasMore: false
        )
        let episodeSection = Section(
            id: "2",
            name: "Episodes",
            sectionType: .grid,
            contentType: .episode,
            order: 2,
            items: [],
            hasMore: false
        )
        mockUseCase.result = .success([podcastSection, episodeSection])

        await sut.loadSections()
        sut.selectFilter(.podcast)

        XCTAssertEqual(sut.filteredSections.count, 1)
        XCTAssertEqual(sut.filteredSections.first?.contentType, .podcast)
    }
}

final class MockFetchHomeSectionsUseCase: FetchHomeSectionsUseCaseProtocol {
    var result: Result<[Section], Error> = .success([])

    func execute(page: Int) async throws -> [Section] {
        switch result {
        case .success(let sections):
            return sections
        case .failure(let error):
            throw error
        }
    }
}
