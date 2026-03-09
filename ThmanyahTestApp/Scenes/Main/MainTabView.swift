//
//  MainTabView.swift
//  ThmanyahTestApp
//
//  Created by Nour-Eddine Legragui  on 9/3/2026.
//

import SwiftUI

struct MainTabView: View {
    let homeView: HomeView
    let searchView: SearchView
    @StateObject private var navigation = NavigationManager()
    @StateObject private var audioPlayback = AudioPlaybackManager()

    var body: some View {
        TabView {
            HomeRootView(homeView: homeView)
                .tabItem {
                    Image(systemName: "house")
                    Text("الرئيسية")
                }

            searchView
                .tabItem {
                    Image(systemName: "magnifyingglass")
                    Text("البحث")
                }

            communityPlaceholder
                .tabItem {
                    Image(systemName: "person.3")
                    Text("المجتمع")
                }
                .badge(3)

            libraryPlaceholder
                .tabItem {
                    Image(systemName: "books.vertical")
                    Text("المكتبة")
                }

            sortPlaceholder
                .tabItem {
                    Image(systemName: "gearshape")
                    Text("الإعدادات")
                }
        }
        .environmentObject(navigation)
        .environmentObject(audioPlayback)
    }

    private var communityPlaceholder: some View {
        Text("الإعدادات")
            .font(AppTypography.title)
            .foregroundStyle(AppColors.textSecondary)
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background(AppColors.background)
    }

    private var libraryPlaceholder: some View {
        Text("الإعدادات")
            .font(AppTypography.title)
            .foregroundStyle(AppColors.textSecondary)
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background(AppColors.background)
    }

    private var sortPlaceholder: some View {
        Text("الإعدادات")
            .font(AppTypography.title)
            .foregroundStyle(AppColors.textSecondary)
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background(AppColors.background)
    }
}


#Preview("MainTabView - Home Loaded") {
    MainTabView(
        homeView: HomeView(viewModel: .previewLoaded),
        searchView: SearchViewFactory.make()
    )
    .environment(\.layoutDirection, .rightToLeft)
}

#Preview("MainTabView - Home Empty") {
    MainTabView(
        homeView: HomeView(viewModel: .previewEmpty),
        searchView: SearchViewFactory.make()
    )
    .environment(\.layoutDirection, .rightToLeft)
}
