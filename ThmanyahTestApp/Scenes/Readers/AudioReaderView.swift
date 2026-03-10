//
//  AudioReaderView.swift
//  ThmanyahTestApp
//
//  Created by Nour-Eddine Legragui  on 10/3/2026.
//

import AVFoundation
import SwiftUI

/// Full-screen audio reader: playback controls, progress, artwork (avatar), and metadata.
/// Uses shared AudioPlaybackManager from environment so state stays in sync with MiniPlayerBanner.
struct AudioReaderView: View {
    let item: ContentItem
    @Environment(\.dismiss) private var dismiss
    @EnvironmentObject private var playback: AudioPlaybackManager

    var body: some View {
        Group {
            if item.audioURL == nil {
                noAudioContent
            } else {
                playerContent
            }
        }
        .onAppear {
            playback.play(item)
        }
    }

    private var noAudioContent: some View {
        VStack(spacing: AppSpacing.lg) {
            Spacer()
            Image(systemName: "speaker.slash.fill")
                .font(.system(size: 56))
                .foregroundStyle(AppColors.textSecondary)
            Text("لا يتوفر محتوى صوتي لهذا العنصر")
                .font(AppTypography.body)
                .foregroundColor(AppColors.textSecondary)
                .multilineTextAlignment(.center)
            Spacer()
            Button("إغلاق") { dismiss() }
                .font(AppTypography.headline)
                .foregroundColor(AppColors.accent)
                .padding(.bottom, AppSpacing.xl)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(AppColors.background)
    }

    private var playerContent: some View {
        ZStack {
            AppColors.background.ignoresSafeArea()

            VStack(spacing: AppSpacing.lg) {
                HStack {
                    Spacer()
                    Button(action: { dismiss() }) {
                        Image(systemName: "xmark.circle.fill")
                            .font(.system(size: 28))
                            .foregroundStyle(AppColors.textSecondary)
                    }
                    .padding(.horizontal, AppSpacing.md)
                }
                .padding(.top, AppSpacing.xs)

                Spacer()

                AsyncImageView(url: item.imageURL)
                    .frame(width: 240, height: 240)
                    .clipShape(RoundedRectangle(cornerRadius: 16))
                    .shadow(color: .black.opacity(0.4), radius: 12, x: 0, y: 4)

                VStack(spacing: AppSpacing.xs) {
                    Text(item.title)
                        .font(AppTypography.title)
                        .foregroundColor(AppColors.textPrimary)
                        .multilineTextAlignment(.center)
                        .lineLimit(2)

                    if let subtitle = item.subtitle {
                        Text(subtitle)
                            .font(AppTypography.caption)
                            .foregroundColor(AppColors.textSecondary)
                            .lineLimit(1)
                    }
                }
                .padding(.horizontal, AppSpacing.lg)

                VStack(spacing: AppSpacing.xs) {
                    Slider(
                        value: Binding(
                            get: { playback.progress },
                            set: { playback.seek(to: $0) }
                        ),
                        in: 0...max(1, playback.durationSeconds)
                    )
                    .tint(AppColors.accent)

                    HStack {
                        Text(playback.currentTimeLabel)
                            .font(AppTypography.small)
                            .foregroundColor(AppColors.textSecondary)
                        Spacer()
                        Text(playback.durationLabel)
                            .font(AppTypography.small)
                            .foregroundColor(AppColors.textSecondary)
                    }
                }
                .padding(.horizontal, AppSpacing.lg)

                HStack(spacing: AppSpacing.xl) {
                    skipButton(seconds: -15, icon: "gobackward.15")
                    playPauseButton
                    skipButton(seconds: 15, icon: "goforward.15")
                }
                .padding(.vertical, AppSpacing.md)

                Spacer()
            }
        }
    }

    private var playPauseButton: some View {
        Button(action: { playback.togglePlayPause() }) {
            Image(systemName: playback.isPlaying ? "pause.circle.fill" : "play.circle.fill")
                .font(.system(size: 64))
                .foregroundStyle(AppColors.accent)
        }
        .buttonStyle(.plain)
    }

    private func skipButton(seconds: Int, icon: String) -> some View {
        Button(action: { playback.skip(seconds: seconds) }) {
            Image(systemName: icon)
                .font(.system(size: 32))
                .foregroundStyle(AppColors.textPrimary)
        }
        .frame(width: 56, height: 56)
    }
}

#if DEBUG
#Preview("AudioReaderView") {
    AudioReaderView(item: PreviewData.episodeItem)
        .environmentObject(AudioPlaybackManager())
}
#endif
