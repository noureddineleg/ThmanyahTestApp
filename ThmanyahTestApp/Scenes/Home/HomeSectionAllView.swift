//
//  HomeSectionAllView.swift
//  ThmanyahTestApp
//
//  Created by Cursor on 10/3/2026.
//

import SwiftUI

struct HomeSectionAllView: View {
    let section: Section
    @EnvironmentObject private var navigation: NavigationManager
    @EnvironmentObject private var audioPlayback: AudioPlaybackManager

    var body: some View {
        ZStack {
            AppColors.background.ignoresSafeArea()

            ScrollView {
                LazyVStack(spacing: AppSpacing.sm) {
                    ForEach(section.identifiedItems) { row in
                        HorizontalContentRow(
                            item: row.item,
                            onTap: { openDetails(row.item) },
                            onPlay: { playAndOpenReader(row.item) }
                        )
                    }
                }
                .padding(.vertical, AppSpacing.md)
            }
        }
        .navigationTitle(section.name)
        .navigationBarTitleDisplayMode(.inline)
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
#Preview("HomeSectionAllView") {
    NavigationStack {
        HomeSectionAllView(section: PreviewData.gridSection)
    }
    .environmentObject(NavigationManager())
    .environmentObject(AudioPlaybackManager())
}
#endif

