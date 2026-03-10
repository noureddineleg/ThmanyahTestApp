//
//  MiniPlayerBanner.swift
//  ThmanyahTestApp
//
//  Created by Nour-Eddine Legragui  on 10/3/2026.
//

import SwiftUI

struct MiniPlayerBanner: View {
    @EnvironmentObject private var playback: AudioPlaybackManager
    @EnvironmentObject private var navigation: NavigationManager

    private let thumbnailSize: CGFloat = 44
    private let progressHeight: CGFloat = 3

    var body: some View {
        Group {
            if let item = playback.currentItem {
                bannerContent(item: item)
            }
        }
    }

    private func bannerContent(item: ContentItem) -> some View {
        VStack(spacing: 0) {
            HStack(spacing: AppSpacing.sm) {
                AsyncImageView(url: item.imageURL)
                    .frame(width: thumbnailSize, height: thumbnailSize)
                    .clipShape(RoundedRectangle(cornerRadius: 6))

                VStack(alignment: .leading, spacing: 2) {
                    Text(item.title)
                        .font(AppTypography.caption)
                        .foregroundStyle(AppColors.textPrimary)
                        .lineLimit(1)
                    Text(playback.currentTimeLabel + " / " + playback.durationLabel)
                        .font(AppTypography.small)
                        .foregroundStyle(AppColors.textSecondary)
                }
                .frame(maxWidth: .infinity, alignment: .leading)

                HStack(spacing: AppSpacing.xs) {
                    skipButton(seconds: -15)
                    playPauseButton
                    skipButton(seconds: 15)
                }
            }
            .padding(.horizontal, AppSpacing.sm)
            .padding(.vertical, AppSpacing.xs)
            .background(AppColors.cardBackground)
            .clipShape(RoundedRectangle(cornerRadius: 10))
            .contentShape(Rectangle())
            .onTapGesture {
                navigation.push(.audioReader(item))
            }

            progressBar
        }
        .padding(.horizontal, AppSpacing.md)
        .padding(.bottom, AppSpacing.xs)
        .background(AppColors.background)
    }

    private var progressBar: some View {
        GeometryReader { geo in
            ZStack(alignment: .leading) {
                Rectangle()
                    .fill(AppColors.textSecondary.opacity(0.3))
                Rectangle()
                    .fill(AppColors.accent)
                    .frame(width: progressWidth(in: geo.size.width))
            }
        }
        .frame(height: progressHeight)
        .clipShape(RoundedRectangle(cornerRadius: progressHeight / 2))
    }

    private func progressWidth(in total: CGFloat) -> CGFloat {
        guard playback.durationSeconds > 0 else { return 0 }
        return total * CGFloat(playback.progress / playback.durationSeconds)
    }

    private func skipButton(seconds: Int) -> some View {
        Button(action: { playback.skip(seconds: seconds) }) {
            ZStack {
                Circle()
                    .stroke(AppColors.textPrimary, lineWidth: 1.5)
                Text(seconds == 15 ? "15" : "−15")
                    .font(.system(size: 11, weight: .semibold))
                    .foregroundStyle(AppColors.textPrimary)
            }
            .frame(width: 32, height: 32)
        }
        .buttonStyle(.plain)
    }

    private var playPauseButton: some View {
        Button(action: { playback.togglePlayPause() }) {
            Image(systemName: playback.isPlaying ? "pause.fill" : "play.fill")
                .font(.system(size: 20))
                .foregroundStyle(AppColors.textPrimary)
                .frame(width: 32, height: 32)
        }
        .buttonStyle(.plain)
    }
}

#if DEBUG
#Preview("MiniPlayerBanner - With item") {
    let playback = AudioPlaybackManager()
    let nav = NavigationManager()
    return ZStack {
        AppColors.background.ignoresSafeArea()
        VStack {
            Spacer()
            MiniPlayerBanner()
                .environmentObject(playback)
                .environmentObject(nav)
        }
    }
    .environment(\.layoutDirection, .rightToLeft)
    .onAppear {
        playback.play(PreviewData.episodeItem)
    }
}

#Preview("MiniPlayerBanner - Empty") {
    MiniPlayerBanner()
        .environmentObject(AudioPlaybackManager())
        .environmentObject(NavigationManager())
        .background(AppColors.background)
}
#endif
