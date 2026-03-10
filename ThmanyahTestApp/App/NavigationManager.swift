//
//  NavigationManager.swift
//  ThmanyahTestApp
//
//  Created by Nour-Eddine Legragui  on 10/3/2026.
//

import Combine

@MainActor
final class NavigationManager: ObservableObject {
    @Published var path: [HomeRoute] = []

    func push(_ route: HomeRoute) {
        path.append(route)
    }

    func pop() {
        guard !path.isEmpty else { return }
        path.removeLast()
    }

    func popToRoot() {
        path.removeAll()
    }
}
