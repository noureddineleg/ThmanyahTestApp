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
}

private struct HomeItemCardView: View {
    let item: ContentItem

    var body: some View {
        VStack(alignment: .trailing, spacing: 8) {
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
                .frame(width: 140, height: 140)
                .clipShape(RoundedRectangle(cornerRadius: 12))
            } else {
                Color.gray.opacity(0.2)
                    .frame(width: 140, height: 140)
                    .clipShape(RoundedRectangle(cornerRadius: 12))
            }

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
}

#Preview {
    MainTabView()
        .environment(\.layoutDirection, .rightToLeft)
}

