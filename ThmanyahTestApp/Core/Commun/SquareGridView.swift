//
//  SquareGridView.swift
//  ThmanyahTestApp
//
//  Created by Nour-Eddine Legragui  on 10/3/2026.
//

import SwiftUI

struct SquareGridView: View {
    let section: Section
    @EnvironmentObject private var navigation: NavigationManager
    @EnvironmentObject private var audioPlayback: AudioPlaybackManager

    var body: some View {
        VStack(alignment: .leading, spacing: AppSpacing.sm) {
            SectionHeaderView(
                title: section.name,
                showSeeAll: section.hasMore
            )

            ScrollView(.horizontal, showsIndicators: false) {
                LazyHStack(spacing: AppSpacing.sm) {
                    ForEach(section.identifiedItems) { row in
                        ContentItemCard(
                            item: row.item,
                            style: .square,
                            onTap: { openDetails(row.item) },
                            onPlay: { playAndOpenReader(row.item) }
                        )
                        .frame(width: 150)
                    }
                }
                .padding(.horizontal, AppSpacing.md)
            }
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
#Preview("SquareGridView") {
    SquareGridView(section: PreviewData.squareGridSection)
        .background(AppColors.background)
        .environmentObject(NavigationManager())
        .environmentObject(AudioPlaybackManager())
}
#endif
