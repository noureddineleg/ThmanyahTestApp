//
//  HomeRootView.swift
//  ThmanyahTestApp
//
//  Created by Nour-Eddine Legragui  on 10/3/2026.
//

import SwiftUI

struct HomeRootView: View {
    @EnvironmentObject private var navigation: NavigationManager
    @EnvironmentObject private var audioPlayback: AudioPlaybackManager
    let homeView: HomeView

    var body: some View {
        NavigationStack(path: $navigation.path) {
            homeView
                .navigationTitle("")
                .navigationBarTitleDisplayMode(.inline)
                .navigationDestination(for: HomeRoute.self) { route in
                    route.view
                        .environmentObject(audioPlayback)
                        .environmentObject(navigation)
                }
        }
    }
}

#if DEBUG
#Preview("HomeRootView - Loaded") {
    HomeRootView(homeView: HomeView(viewModel: .previewLoaded))
        .environmentObject(NavigationManager())
}

#Preview("HomeRootView - Empty") {
    HomeRootView(homeView: HomeView(viewModel: .previewEmpty))
        .environmentObject(NavigationManager())
}
#endif
