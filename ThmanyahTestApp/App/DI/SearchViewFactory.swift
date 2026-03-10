//
//  SearchViewFactory.swift
//  ThmanyahTestApp
//
//  Created by Nour-Eddine Legragui  on 10/3/2026.
//

enum SearchRoute: Hashable, Equatable {
    // Reserved for future deep links
}

enum SearchViewFactory {
    static func make() -> SearchView {
        let viewModel = SearchViewModel(
            searchContentUseCase: DependencyContainer.shared.searchContentUseCase
        )
        return SearchView(viewModel: viewModel)
    }
}
