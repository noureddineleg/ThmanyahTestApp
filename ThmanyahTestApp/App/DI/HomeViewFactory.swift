//
//  HomeViewFactory.swift
//  ThmanyahTestApp
//
//  Created by Nour-Eddine Legragui  on 9/3/2026.
//

enum HomeViewFactory {
    static func make() -> HomeView {
        let viewModel = HomeViewModel(
            fetchHomeSectionsUseCase: DependencyContainer.shared.fetchHomeSectionsUseCase
        )
        return HomeView(viewModel: viewModel)
    }
}
