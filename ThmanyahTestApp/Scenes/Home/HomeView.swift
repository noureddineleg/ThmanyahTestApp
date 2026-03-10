//
//  HomeView.swift
//  ThmanyahTestApp
//
//  Created by Nour-Eddine Legragui  on 9/3/2026.
//

import SwiftUI

struct HomeView: View {
    @EnvironmentObject private var navigation: NavigationManager
    @StateObject private var viewModel: HomeViewModel

    init(viewModel: HomeViewModel) {
        _viewModel = StateObject(wrappedValue: viewModel)
    }

    var body: some View {
        ZStack {
            AppColors.background.ignoresSafeArea()
            
            switch viewModel.state {
            case .idle:
                Color.clear.onAppear {
                    Task { await viewModel.loadSections() }
                }
            case .loading:
                LoadingView()
            case .loaded:
                contentView
            case .loadingMore:
                contentView.overlay(alignment: .bottom) {
                    ProgressView()
                        .padding()
                }
            case .error(let message):
                ErrorView(message: message) {
                    Task { await viewModel.loadSections() }
                }
            }
        }
        .toolbar(.hidden, for: .navigationBar)
    }
    
    private var headerView: some View {
        Image(systemName: "person.circle.fill")
            .font(AppTypography.icon)
            .foregroundColor(AppColors.primary)
    }

    private var notificationButton: some View {
        Button {
            // notifications action
        } label: {
            Image(systemName: "bell.fill")
                .font(AppTypography.icon)
                .foregroundColor(AppColors.textPrimary)
        }
        .overlay(alignment: .topTrailing) {
            Text("4")
                .font(.caption2.bold())
                .foregroundColor(.white)
                .padding(4)
                .background(Color.red)
                .clipShape(Circle())
                .offset(x: 6, y: -6)
        }
    }
    
    private var contentView: some View {
        ScrollView {
            LazyVStack(spacing: AppSpacing.lg) {
                topHeaderView
                contentFilterView

                ForEach(viewModel.filteredSections) { section in
                    SectionView(section: section)
                        .onAppear {
                            Task {
                                await viewModel.loadMoreSectionsIfNeeded(currentSection: section)
                            }
                        }
                }
            }
            .padding(.vertical, AppSpacing.md)
        }
        .scrollIndicators(.hidden)
        .refreshable {
            await viewModel.refresh()
        }
    }
    
    private var topHeaderView: some View {
        HStack {
            HStack(spacing: 8) {
                Image(systemName: "person.circle.fill")
                    .font(AppTypography.icon)
                    .foregroundColor(AppColors.primary)
                
                Text(L10n.Home.eveningGreeting)
                    .font(AppTypography.headline)
                    .foregroundColor(AppColors.textSecondary)
                
                HStack(spacing: 4) {
                    Text(L10n.Home.username)
                        .font(AppTypography.headline)
                        .foregroundColor(AppColors.textPrimary)
                    
                    Image(systemName: "star.fill")
                        .font(.system(size: 14, weight: .semibold))
                        .foregroundColor(AppColors.primary)
                }
            }
            
            Spacer()
            
            notificationButton
        }
        .padding(.horizontal, AppSpacing.md)
    }

    private var contentFilterView: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: AppSpacing.sm) {
                FilterChip(
                    title: L10n.Home.filterAll,
                    isSelected: viewModel.selectedContentFilter == nil
                ) {
                    viewModel.selectFilter(nil)
                }

                ForEach(ContentType.allCases, id: \.self) { type in
                    FilterChip(
                        title: type.displayName,
                        isSelected: viewModel.selectedContentFilter == type
                    ) {
                        viewModel.selectFilter(type)
                    }
                }
            }
            .padding(.horizontal, AppSpacing.md)
        }
    }
    
    private var greetingView: some View {
        HStack(spacing: 6) {
            Text(L10n.Home.eveningGreeting)
                .font(AppTypography.headline)
                .foregroundColor(AppColors.textSecondary)
            
            Text(L10n.Home.username)
                .font(AppTypography.headline)
                .foregroundColor(AppColors.textSecondary)
            
            Image(systemName: "star.fill")
                .font(AppTypography.icon)
                .foregroundColor(AppColors.primary)
        }
    }
}

struct FilterChip: View {
    let title: String
    let isSelected: Bool
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            Text(title)
                .font(AppTypography.body)
                .foregroundColor(isSelected ? .white : AppColors.textSecondary)
                .padding(.horizontal, AppSpacing.md)
                .padding(.vertical, AppSpacing.xs)
                .background(isSelected ? AppColors.primary : AppColors.cardBackground)
                .cornerRadius(20)
        }
    }
}

#if DEBUG
#Preview("Home - Loaded") {
    NavigationStack {
        HomeView(viewModel: .previewLoaded)
    }
    .environmentObject(NavigationManager())
    .environmentObject(AudioPlaybackManager())
}

#Preview("Home - Empty") {
    NavigationStack {
        HomeView(viewModel: .previewEmpty)
    }
    .environmentObject(NavigationManager())
    .environmentObject(AudioPlaybackManager())
}

#Preview("Home - Loading") {
    NavigationStack {
        HomeView(viewModel: .previewLoading)
    }
    .environmentObject(NavigationManager())
    .environmentObject(AudioPlaybackManager())
}

#Preview("Home - Error") {
    NavigationStack {
        HomeView(viewModel: .previewError)
    }
    .environmentObject(NavigationManager())
    .environmentObject(AudioPlaybackManager())
}

#Preview("FilterChip - Selected") {
    FilterChip(
        title: "بودكاست",
        isSelected: true,
        action: {}
    )
    .padding()
    .previewLayout(.sizeThatFits)
    .background(AppColors.background)
}

#Preview("FilterChip - Unselected") {
    FilterChip(
        title: "كتب صوتية",
        isSelected: false,
        action: {}
    )
    .padding()
    .previewLayout(.sizeThatFits)
    .background(AppColors.background)
}
#endif


