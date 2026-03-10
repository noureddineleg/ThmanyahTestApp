//
//  HorizontalListView.swift
//  ThmanyahTestApp
//
//  Created by Nour-Eddine Legragui  on 10/3/2026.
//

import SwiftUI

struct HorizontalListView: View {
    let section: Section
    @EnvironmentObject private var navigation: NavigationManager
    @EnvironmentObject private var audioPlayback: AudioPlaybackManager

    var body: some View {
        VStack(alignment: .leading, spacing: AppSpacing.sm) {
            SectionHeaderView(
                title: section.name,
                showSeeAll: section.hasMore,
                onSeeAllTapped: {
                    navigation.push(.sectionAll(section))
                }
            )

            VStack(spacing: AppSpacing.xs) {
                ForEach(section.identifiedItems.prefix(5)) { row in
                    HorizontalContentRow(
                        item: row.item,
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

struct HorizontalContentRow: View {
    let item: ContentItem
    var onTap: (() -> Void)?
    var onPlay: (() -> Void)?

    var body: some View {
        HStack(spacing: AppSpacing.sm) {
            AsyncImageView(url: item.imageURL)
                .frame(width: 60, height: 60)
                .clipShape(RoundedRectangle(cornerRadius: 8))

            VStack(alignment: .leading, spacing: AppSpacing.xxs) {
                Text(item.title)
                    .font(AppTypography.headline)
                    .foregroundColor(AppColors.textPrimary)
                    .lineLimit(2)

                if let subtitle = item.subtitle {
                    Text(subtitle)
                        .font(AppTypography.caption)
                        .foregroundColor(AppColors.textSecondary)
                        .lineLimit(1)
                }
            }

            Spacer()

            if let onPlay {
                Button(action: onPlay) {
                    Image(systemName: "play.circle.fill")
                        .font(.system(size: 32))
                        .foregroundStyle(AppColors.primary)
                }
                .buttonStyle(.plain)
            }

            Button(action: {}) {
                Image(systemName: "ellipsis")
                    .foregroundColor(AppColors.textSecondary)
            }
        }
        .padding(AppSpacing.sm)
        .background(AppColors.cardBackground)
        .cornerRadius(12)
        .contentShape(Rectangle())
        .onTapGesture {
            onTap?()
        }
    }
}

#if DEBUG
#Preview("HorizontalListView") {
    HorizontalListView(section: PreviewData.horizontalSection)
        .background(AppColors.background)
        .environmentObject(NavigationManager())
        .environmentObject(AudioPlaybackManager())
}

#Preview("HorizontalContentRow - Premium") {
    HorizontalContentRow(item: PreviewData.episodeItem)
        .padding()
        .previewLayout(.sizeThatFits)
        .background(AppColors.background)
}

#Preview("HorizontalContentRow - Non Premium") {
    HorizontalContentRow(item: PreviewData.podcastItem)
        .padding()
        .previewLayout(.sizeThatFits)
        .background(AppColors.background)
}
#endif


