//
//  SearchView.swift
//  ThmanyahTestApp
//
//  Created by Nour-Eddine Legragui  on 10/3/2026.
//

import SwiftUI

struct SearchView: View {
    @StateObject private var viewModel: SearchViewModel
    @Environment(\.dismiss) private var dismiss
    @FocusState private var isSearchFieldFocused: Bool

    init(viewModel: SearchViewModel) {
        _viewModel = StateObject(wrappedValue: viewModel)
    }

    var body: some View {
        ZStack {
            AppColors.background.ignoresSafeArea()

            VStack(spacing: 0) {
                searchHeader

                switch viewModel.state {
                case .idle:
                    recentSearchesView
                case .searching:
                    LoadingView()
                case .results(let result):
                    searchResultsView(result)
                case .empty(let query):
                    emptyResultsView(query: query)
                case .error(let message):
                    ErrorView(message: message) {
                        viewModel.searchText = viewModel.searchText
                    }
                }
            }
        }
//        .toolbar(.hidden, for: .navigationBar)
        .onAppear {
            isSearchFieldFocused = true
        }
    }

    private var searchHeader: some View {
        HStack(spacing: AppSpacing.sm) {
            Button(action: { dismiss() }) {
                Image(systemName: "arrow.right")
                    .font(AppTypography.icon)
                    .foregroundColor(AppColors.textPrimary)
            }

            HStack {
                Image(systemName: "magnifyingglass")
                    .foregroundColor(AppColors.textSecondary)

                TextField("ابحث عن بودكاست، حلقة، كتاب...", text: $viewModel.searchText)
                    .font(AppTypography.body)
                    .foregroundColor(AppColors.textPrimary)
                    .focused($isSearchFieldFocused)

                if !viewModel.searchText.isEmpty {
                    Button(action: { viewModel.clearSearch() }) {
                        Image(systemName: "xmark.circle.fill")
                            .foregroundColor(AppColors.textSecondary)
                    }
                }
            }
            .padding(AppSpacing.sm)
            .background(AppColors.cardBackground)
            .cornerRadius(12)
        }
        .padding(AppSpacing.md)
    }

    private var recentSearchesView: some View {
        VStack(alignment: .leading, spacing: AppSpacing.md) {
            if !viewModel.recentSearches.isEmpty {
                HStack {
                    Text("عمليات البحث الأخيرة")
                        .font(AppTypography.headline)
                        .foregroundColor(AppColors.textPrimary)

                    Spacer()

                    Button("مسح") {
                        viewModel.clearRecentSearches()
                    }
                    .font(AppTypography.caption)
                    .foregroundColor(AppColors.textSecondary)
                }

                ForEach(viewModel.recentSearches, id: \.self) { search in
                    Button(action: { viewModel.selectRecentSearch(search) }) {
                        HStack {
                            Image(systemName: "clock.arrow.circlepath")
                                .foregroundColor(AppColors.textSecondary)
                            Text(search)
                                .font(AppTypography.body)
                                .foregroundColor(AppColors.textPrimary)
                            Spacer()
                        }
                        .padding(.vertical, AppSpacing.xs)
                    }
                }
            } else {
                Text("ابدأ البحث عن المحتوى المفضل لديك")
                    .font(AppTypography.body)
                    .foregroundColor(AppColors.textSecondary)
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
            }

            Spacer()
        }
        .padding(AppSpacing.md)
    }

    private func searchResultsView(_ result: SearchResult) -> some View {
        ScrollView {
            LazyVStack(spacing: AppSpacing.lg) {
                Text("نتائج البحث عن \"\(result.query)\" (\(result.totalCount))")
                    .font(AppTypography.caption)
                    .foregroundColor(AppColors.textSecondary)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(.horizontal, AppSpacing.md)

                ForEach(result.sections) { section in
                    SectionView(section: section)
                }
            }
            .padding(.vertical, AppSpacing.md)
        }
    }

    private func emptyResultsView(query: String) -> some View {
        VStack(spacing: AppSpacing.md) {
            Image(systemName: "magnifyingglass")
                .font(AppTypography.iconLarge)
                .foregroundColor(AppColors.textSecondary)

            Text("لا توجد نتائج لـ \"\(query)\"")
                .font(AppTypography.headline)
                .foregroundColor(AppColors.textPrimary)

            Text("جرب كلمات بحث مختلفة")
                .font(AppTypography.body)
                .foregroundColor(AppColors.textSecondary)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
}

#if DEBUG
#Preview("Search - Idle") {
    NavigationStack {
        SearchView(viewModel: .previewIdle)
    }
}

#Preview("Search - Searching") {
    NavigationStack {
        SearchView(viewModel: .previewSearching)
    }
}

#Preview("Search - Results") {
    NavigationStack {
        SearchView(viewModel: .previewResults)
            .environmentObject(NavigationManager())
            .environmentObject(AudioPlaybackManager())
    }
}

#Preview("Search - Empty") {
    NavigationStack {
        SearchView(viewModel: .previewEmpty)
    }
}

#Preview("Search - Error") {
    NavigationStack {
        SearchView(viewModel: .previewError)
    }
}
#endif


