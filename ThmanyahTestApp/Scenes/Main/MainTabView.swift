//
//  MainTabView.swift
//  ThmanyahTestApp
//
//  Created by Nour-Eddine Legragui  on 9/3/2026.
//

import SwiftUI

struct MainTabView: View {
    var body: some View {
        TabView {
            SettingsPlaceholderView()
                .tabItem {
                    Image(systemName: "gearshape")
                    Text("الإعدادات")
                }

            LibraryPlaceholderView()
                .tabItem {
                    Image(systemName: "books.vertical")
                    Text("المكتبة")
                }

            CommunityPlaceholderView()
                .tabItem {
                    Image(systemName: "person.3")
                    Text("المجتمع")
                }
                .badge(3)

            SearchPlaceholderView()
                .tabItem {
                    Image(systemName: "magnifyingglass")
                    Text("البحث")
                }

            HomeRootView()
                .tabItem {
                    Image(systemName: "house.fill")
                    Text("الرئيسية")
                }
        }
    }
}

private struct SettingsPlaceholderView: View {
    var body: some View {
        Text("شاشة الإعدادات")
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background(Color(.systemBackground))
    }
}

private struct LibraryPlaceholderView: View {
    var body: some View {
        Text("شاشة المكتبة")
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background(Color(.systemBackground))
    }
}

private struct CommunityPlaceholderView: View {
    var body: some View {
        Text("شاشة المجتمع")
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background(Color(.systemBackground))
    }
}

private struct SearchPlaceholderView: View {
    var body: some View {
        Text("شاشة البحث")
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background(Color(.systemBackground))
    }
}

struct HomeRootView: View {
    private let store: HomeStoreProtocol

    @State private var sections: [Section] = []
    @State private var isLoading = false
    @State private var errorMessage: String?

    init(store: HomeStoreProtocol = HomeStore(service: HomeService(networking: NetworkingManager()))) {
        self.store = store
    }

    var body: some View {
        NavigationStack {
            Group {
                if isLoading {
                    ProgressView()
                        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .center)
                } else if let errorMessage {
                    VStack(spacing: 12) {
                        Text("حدث خطأ")
                            .font(.headline)
                        Text(errorMessage)
                            .font(.subheadline)
                            .multilineTextAlignment(.center)
                        Button("إعادة المحاولة") {
                            Task { await load() }
                        }
                        .buttonStyle(.borderedProminent)
                    }
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                } else {
                    ScrollView {
                        LazyVStack(alignment: .trailing, spacing: 24) {
                            ForEach(sections) { section in
                                if isTrendingEpisodes(section) {
                                    TrendingEpisodesGridSectionView(section: section)
                                } else {
                                    VStack(alignment: .trailing, spacing: 12) {
                                        Text(section.name)
                                            .font(.headline)
                                            .frame(maxWidth: .infinity, alignment: .trailing)

                                        ScrollView(.horizontal, showsIndicators: false) {
                                            LazyHStack(spacing: 16) {
                                                ForEach(section.identifiedItems) { row in
                                                    HomeItemCardView(item: row.item)
                                                }
                                            }
                                            .padding(.horizontal)
                                        }
                                    }
                                    .padding(.horizontal)
                                }
                            }
                        }
                        .padding(.vertical)
                    }
                }
            }
            .navigationTitle("الرئيسية")
        }
        .task {
            await load()
        }
    }

    private func load() async {
        guard !isLoading else { return }
        isLoading = true
        errorMessage = nil
        do {
            sections = try await store.fetchHomeSections(page: 1)
        } catch {
            errorMessage = error.localizedDescription
        }
        isLoading = false
    }

    private func isTrendingEpisodes(_ section: Section) -> Bool {
        section.contentType == .episode &&
        section.name.localizedCaseInsensitiveContains("trending")
    }
}

private struct HomeItemCardView: View {
    let item: ContentItem

    var body: some View {
        VStack(alignment: .trailing, spacing: 8) {
            ZStack {
                if let url = item.imageURL {
                    AsyncImage(url: url) { phase in
                        switch phase {
                        case .empty:
                            Color.gray.opacity(0.2)
                        case .success(let image):
                            image
                                .resizable()
                                .scaledToFill()
                        case .failure:
                            Color.gray.opacity(0.2)
                        @unknown default:
                            Color.gray.opacity(0.2)
                        }
                    }
                } else {
                    Color.gray.opacity(0.2)
                }

                VStack {
                    HStack {
                        if let episodeBadge = episodeBadgeText {
                            Text(episodeBadge)
                                .font(.caption2.bold())
                                .padding(.horizontal, 6)
                                .padding(.vertical, 4)
                                .background(Color.black.opacity(0.7))
                                .foregroundColor(.white)
                                .clipShape(Capsule())
                        }
                        Spacer()
                    }
                    Spacer()
                    HStack {
                        Spacer()
                        if let duration = item.duration {
                            Text(duration)
                                .font(.caption2.bold())
                                .padding(.horizontal, 6)
                                .padding(.vertical, 4)
                                .background(Color.black.opacity(0.7))
                                .foregroundColor(.white)
                                .clipShape(RoundedRectangle(cornerRadius: 6))
                        }
                    }
                }
                .padding(6)
            }
            .frame(width: 160, height: 160)
            .clipShape(RoundedRectangle(cornerRadius: 12))

            Text(item.title)
                .font(.subheadline.weight(.semibold))
                .multilineTextAlignment(.trailing)
                .frame(maxWidth: 140, alignment: .trailing)

            if let subtitle = item.subtitle, !subtitle.isEmpty {
                Text(subtitle)
                    .font(.caption)
                    .foregroundColor(.secondary)
                    .multilineTextAlignment(.trailing)
                    .frame(maxWidth: 140, alignment: .trailing)
            }
        }
    }

    private var episodeBadgeText: String? {
        guard item.contentType == .episode else { return nil }
        let type = item.episodeType?.lowercased() ?? ""
        if type.contains("trailer") {
            return "Trailer"
        } else if !type.isEmpty {
            return "Full"
        } else {
            return nil
        }
    }
}

private struct TrendingEpisodesGridSectionView: View {
    let section: Section

    private let columns: [GridItem] = [
        GridItem(.flexible(), spacing: 16),
        GridItem(.flexible(), spacing: 16)
    ]

    var body: some View {
        VStack(alignment: .trailing, spacing: 12) {
            Text(section.name)
                .font(.headline)
                .frame(maxWidth: .infinity, alignment: .trailing)

            LazyVGrid(columns: columns, alignment: .trailing, spacing: 16) {
                ForEach(section.identifiedItems) { row in
                    HomeItemCardView(item: row.item)
                }
            }
            .padding(.horizontal)
        }
        .padding(.horizontal)
    }
}

#Preview {
    MainTabView()
        .environment(\.layoutDirection, .rightToLeft)
}

