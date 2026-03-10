//
//  VideoReaderView.swift
//  ThmanyahTestApp
//
//  Created by Nour-Eddine Legragui  on 10/3/2026.
//

import AVKit
import SwiftUI

/// Full-screen video reader using the system video player with overlay controls.
struct VideoReaderView: View {
    let item: ContentItem
    @Environment(\.dismiss) private var dismiss
    @State private var player: AVPlayer?

    var body: some View {
        Group {
            if let url = item.videoURL {
                videoContent(url: url)
            } else {
                noVideoContent
            }
        }
        .onDisappear {
            player?.pause()
        }
    }

    private func videoContent(url: URL) -> some View {
        ZStack(alignment: .topTrailing) {
            if let p = player {
                VideoPlayer(player: p)
                    .ignoresSafeArea()
            } else {
                Color.black.ignoresSafeArea()
                ProgressView()
                    .tint(.white)
            }

            Button(action: { dismiss() }) {
                Image(systemName: "xmark.circle.fill")
                    .font(.system(size: 32))
                    .foregroundStyle(.white)
                    .shadow(color: .black.opacity(0.6), radius: 2, x: 0, y: 1)
            }
            .padding(AppSpacing.lg)
        }
        .onAppear {
            if player == nil {
                let p = AVPlayer(url: url)
                player = p
                p.play()
            }
        }
    }

    private var noVideoContent: some View {
        VStack(spacing: AppSpacing.lg) {
            Spacer()
            Image(systemName: "video.slash.fill")
                .font(.system(size: 56))
                .foregroundStyle(AppColors.textSecondary)
            Text("لا يتوفر محتوى فيديو لهذا العنصر")
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
}

#if DEBUG
#Preview("VideoReaderView - With URL") {
    VideoReaderView(item: PreviewData.videoItem)
}

#Preview("VideoReaderView - No URL") {
    VideoReaderView(item: PreviewData.podcastItem)
}
#endif
