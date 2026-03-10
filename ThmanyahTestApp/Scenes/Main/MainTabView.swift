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
                    Text(L10n.Tab.home)
                }

            searchView
                .tabItem {
                    Image(systemName: "magnifyingglass")
                    Text(L10n.Tab.search)
                }

            communityPlaceholder
                .tabItem {
                    Image(systemName: "person.3")
                    Text(L10n.Tab.community)
                }
                .badge(3)

            libraryPlaceholder
                .tabItem {
                    Image(systemName: "books.vertical")
                    Text(L10n.Tab.library)
                }

            sortPlaceholder
                .tabItem {
                    Image(systemName: "gearshape")
                    Text(L10n.Tab.settings)
                }
        }
        .overlay(alignment: .bottom) {
            MiniPlayerBanner()
                .padding(.bottom, 50)
        }
        .environmentObject(navigation)
        .environmentObject(audioPlayback)
    }

    private var communityPlaceholder: some View {
        Text(L10n.Tab.community)
            .font(AppTypography.title)
            .foregroundStyle(AppColors.textSecondary)
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background(AppColors.background)
    }

    private var libraryPlaceholder: some View {
        Text(L10n.Tab.library)
            .font(AppTypography.title)
            .foregroundStyle(AppColors.textSecondary)
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background(AppColors.background)
    }

    private var sortPlaceholder: some View {
        Text(L10n.Tab.settings)
            .font(AppTypography.title)
            .foregroundStyle(AppColors.textSecondary)
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background(AppColors.background)
    }
}

#if DEBUG
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
#endif
