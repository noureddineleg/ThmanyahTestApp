//
//  ContentItemCard.swift
//  ThmanyahTestApp
//
//  Created by Nour-Eddine Legragui  on 10/3/2026.
//

import SwiftUI

struct ContentItemCard: View {
    let item: ContentItem
    let style: CardStyle
    var onTap: (() -> Void)?
    var onPlay: (() -> Void)?

    enum CardStyle {
        case grid
        case square
        case horizontal
    }

    var body: some View {
        VStack(alignment: .leading, spacing: AppSpacing.xs) {
            ZStack(alignment: .topTrailing) {
                AsyncImageView(url: item.imageURL)
                    .frame(height: imageHeight)
                    .clipShape(RoundedRectangle(cornerRadius: 12))

                if item.isPremium {
                    Image(systemName: "crown.fill")
                        .foregroundColor(.yellow)
                        .padding(AppSpacing.xs)
                        .background(Color.black.opacity(0.6))
                        .clipShape(Circle())
                        .padding(AppSpacing.xs)
                }

                if onPlay != nil {
                    playButtonOverlay
                }
            }

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

            if let duration = item.duration {
                HStack(spacing: AppSpacing.xxs) {
                    Image(systemName: "play.fill")
                        .font(AppTypography.iconTiny)
                    Text(duration)
                        .font(AppTypography.small)
                }
                .foregroundColor(AppColors.textSecondary)
            }
        }
        .contentShape(Rectangle())
        .onTapGesture {
            onTap?()
        }
    }

    private var playButtonOverlay: some View {
        Button(action: { onPlay?() }) {
            Image(systemName: "play.circle.fill")
                .font(.system(size: 44))
                .foregroundStyle(.white)
                .shadow(color: .black.opacity(0.5), radius: 2, x: 0, y: 1)
        }
        .buttonStyle(.plain)
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }

    private var imageHeight: CGFloat {
        switch style {
        case .grid: return 120
        case .square: return 160
        case .horizontal: return 80
        }
    }
}

#if DEBUG
#Preview("ContentItemCard - Grid Podcast") {
    ContentItemCard(item: PreviewData.podcastItem, style: .grid)
        .frame(width: 180)
        .padding()
        .background(AppColors.background)
}

#Preview("ContentItemCard - Square Audiobook Premium") {
    ContentItemCard(item: PreviewData.audiobookItem, style: .square)
        .frame(width: 180)
        .padding()
        .background(AppColors.background)
}

#Preview("ContentItemCard - Horizontal Episode") {
    ContentItemCard(item: PreviewData.episodeItem, style: .horizontal)
        .frame(width: 320)
        .padding()
        .background(AppColors.background)
}
#endif


