//
//  GridSectionView.swift
//  ThmanyahTestApp
//
//  Created by Nour-Eddine Legragui  on 10/3/2026.
//

import SwiftUI

struct GridSectionView: View {
    let section: Section
    @EnvironmentObject private var navigation: NavigationManager
    @EnvironmentObject private var audioPlayback: AudioPlaybackManager

    private let columns = [
        GridItem(.flexible(), spacing: AppSpacing.sm),
        GridItem(.flexible(), spacing: AppSpacing.sm)
    ]

    var body: some View {
        VStack(alignment: .leading, spacing: AppSpacing.sm) {
            SectionHeaderView(
                title: section.name,
                showSeeAll: section.hasMore,
                onSeeAllTapped: {
                    navigation.push(.sectionAll(section))
                }
            )

            LazyVGrid(columns: columns, spacing: AppSpacing.sm) {
                ForEach(section.identifiedItems) { row in
                    ContentItemCard(
                        item: row.item,
                        style: .grid,
                        onTap: { openDetails(row.item) },
                        onPlay: { playAndOpenReader(row.item) }
                    )
                }
            }
            .padding(.horizontal, AppSpacing.md)
        }
    }

    private func openDetails(_ item: ContentItem) {
        if item.videoURL != nil {
            navigation.push(.videoReader(item))
        } else {
            navigation.push(.podcastDetails(item))
        }
    }

    private func playAndOpenReader(_ item: ContentItem) {
        if item.videoURL != nil {
            navigation.push(.videoReader(item))
        } else {
            audioPlayback.play(item)
            navigation.push(.audioReader(item))
        }
    }
}

#if DEBUG
#Preview("GridSectionView") {
    GridSectionView(section: PreviewData.gridSection)
        .background(AppColors.background)
        .environmentObject(NavigationManager())
        .environmentObject(AudioPlaybackManager())
}
#endif
