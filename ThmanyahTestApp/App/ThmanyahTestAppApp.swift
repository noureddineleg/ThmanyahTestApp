//
//  ThmanyahTestAppApp.swift
//  ThmanyahTestApp
//
//  Created by Nour-Eddine Legragui  on 9/3/2026.
//

import SwiftUI

@main
struct ThmanyahApp: App {

    var body: some Scene {
        WindowGroup {
            MainTabView(
                homeView: HomeViewFactory.make(),
                searchView: SearchViewFactory.make()
            )
            .environment(\.layoutDirection, .rightToLeft)
        }
    }
}
