//
//  SearchViewModel.swift
//  ThmanyahTestApp
//
//  Created by Nour-Eddine Legragui  on 10/3/2026.
//

import Foundation
import Combine

@MainActor
final class SearchViewModel: ObservableObject {
    enum ViewState: Equatable {
        case idle
        case searching
        case results(SearchResult)
        case empty(String)
        case error(String)
    }

    @Published var searchText: String = ""
    @Published private(set) var state: ViewState = .idle
    @Published var recentSearches: [String] = []

    private let searchContentUseCase: SearchContentUseCaseProtocol
    private let debouncer = Debouncer(duration: .milliseconds(200))
    private var cancellables = Set<AnyCancellable>()

    init(searchContentUseCase: SearchContentUseCaseProtocol) {
        self.searchContentUseCase = searchContentUseCase
        loadRecentSearches()
        setupSearchObserver()
    }

    private func setupSearchObserver() {
        $searchText
            .removeDuplicates()
            .sink { [weak self] query in
                guard let self else { return }
                Task {
                    await self.handleSearchTextChange(query)
                }
            }
            .store(in: &cancellables)
    }

    private func handleSearchTextChange(_ query: String) async {
        let trimmedQuery = query.trimmingCharacters(in: .whitespacesAndNewlines)

        if trimmedQuery.isEmpty {
            state = .idle
            return
        }

        await debouncer.debounce { [weak self] in
            await self?.performSearch(query: trimmedQuery)
        }
    }

    private func performSearch(query: String) async {
        state = .searching

        do {
            let result = try await searchContentUseCase.execute(query: query)

            if result.sections.isEmpty {
                state = .empty(query)
            } else {
                state = .results(result)
                addToRecentSearches(query)
            }
        } catch {
            state = .error("حدث خطأ أثناء البحث")
        }
    }

    func clearSearch() {
        searchText = ""
        state = .idle
    }

    func selectRecentSearch(_ query: String) {
        searchText = query
    }

    func clearRecentSearches() {
        recentSearches = []
        saveRecentSearches()
    }

    private func addToRecentSearches(_ query: String) {
        recentSearches.removeAll { $0 == query }
        recentSearches.insert(query, at: 0)
        if recentSearches.count > 10 {
            recentSearches = Array(recentSearches.prefix(10))
        }
        saveRecentSearches()
    }

    private func loadRecentSearches() {
        recentSearches = UserDefaults.standard.stringArray(forKey: "recentSearches") ?? []
    }

    private func saveRecentSearches() {
        UserDefaults.standard.set(recentSearches, forKey: "recentSearches")
    }
}

#if DEBUG
extension SearchViewModel {
    private struct SearchContentUseCaseStub: SearchContentUseCaseProtocol {
        let result: SearchResult

        func execute(query: String) async throws -> SearchResult {
            result
        }
    }

    static var previewIdle: SearchViewModel {
        SearchViewModel(
            searchContentUseCase: SearchContentUseCaseStub(result: PreviewData.searchResultNonEmpty)
        )
    }

    static var previewSearching: SearchViewModel {
        SearchViewModel(
            searchContentUseCase: SearchContentUseCaseStub(result: PreviewData.searchResultNonEmpty)
        ).with { viewModel in
            viewModel.searchText = "ثمانية"
            viewModel.state = .searching
        }
    }

    static var previewResults: SearchViewModel {
        SearchViewModel(
            searchContentUseCase: SearchContentUseCaseStub(result: PreviewData.searchResultNonEmpty)
        ).with { viewModel in
            viewModel.searchText = "ثمانية"
            viewModel.state = .results(PreviewData.searchResultNonEmpty)
            viewModel.recentSearches = ["ثمانية", "اقتصاد", "تعليم"]
        }
    }

    static var previewEmpty: SearchViewModel {
        SearchViewModel(
            searchContentUseCase: SearchContentUseCaseStub(result: PreviewData.searchResultEmpty)
        ).with { viewModel in
            viewModel.searchText = "لن نجد شيئًا"
            viewModel.state = .empty("لن نجد شيئًا")
        }
    }

    static var previewError: SearchViewModel {
        SearchViewModel(
            searchContentUseCase: SearchContentUseCaseStub(result: PreviewData.searchResultEmpty)
        ).with { viewModel in
            viewModel.searchText = "ثمانية"
            viewModel.state = .error("حدث خطأ أثناء البحث. حاول مرة أخرى.")
        }
    }
}

private extension SearchViewModel {
    func with(_ configure: (SearchViewModel) -> Void) -> SearchViewModel {
        configure(self)
        return self
    }
}
#endif


