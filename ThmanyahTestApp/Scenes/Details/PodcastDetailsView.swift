//
//  PodcastDetailsView.swift
//  ThmanyahTestApp
//
//  Created by Nour-Eddine Legragui  on 10/3/2026.
//

import SwiftUI

/// Presents podcast (or episode/audiobook/article) details and description from API data.
/// Shows artwork, title, subtitle, description, metadata, and a play button for audio.
struct PodcastDetailsView: View {
    let item: ContentItem
    @Environment(\.dismiss) private var dismiss
    @EnvironmentObject private var audioPlayback: AudioPlaybackManager

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: AppSpacing.lg) {
                headerSection
                metadataSection
                if let description = item.description, !description.isEmpty {
                    descriptionSection(description)
                }
                playSectionIfNeeded
            }
            .frame(maxWidth: .infinity)
            .padding(AppSpacing.md)
            .padding(.bottom, AppSpacing.xxl)
        }
        .scrollIndicators(.hidden)
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(AppColors.background)
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .topBarLeading) {
                Button(action: { dismiss() }) {
                    Image(systemName: "chevron.right")
                        .font(AppTypography.headline)
                        .foregroundColor(AppColors.textPrimary)
                }
            }
        }
    }

    private var headerSection: some View {
        VStack(spacing: AppSpacing.md) {
            ZStack(alignment: .topTrailing) {
                AsyncImageView(url: item.imageURL)
                    .frame(width: 200, height: 200)
                    .clipShape(RoundedRectangle(cornerRadius: 16))
                    .shadow(color: .black.opacity(0.3), radius: 8, x: 0, y: 4)

                if item.isPremium {
                    Image(systemName: "crown.fill")
                        .foregroundColor(.yellow)
                        .font(.system(size: 20))
                        .padding(AppSpacing.xs)
                        .background(Color.black.opacity(0.6))
                        .clipShape(Circle())
                        .padding(AppSpacing.xs)
                }
            }

            VStack(spacing: AppSpacing.xs) {
                Text(item.title.isEmpty ? "بدون عنوان" : item.title)
                    .font(AppTypography.title)
                    .foregroundColor(AppColors.textPrimary)
                    .multilineTextAlignment(.center)
                    .lineLimit(3)

                if let subtitle = item.subtitle, !subtitle.isEmpty {
                    Text(subtitle)
                        .font(AppTypography.caption)
                        .foregroundColor(AppColors.textSecondary)
                        .lineLimit(2)
                }

                Text(item.contentType.displayName)
                    .font(AppTypography.small)
                    .foregroundColor(AppColors.accent)
            }
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, AppSpacing.sm)
    }

    private var metadataSection: some View {
        HStack(spacing: AppSpacing.lg) {
            if let duration = item.duration, !duration.isEmpty {
                metadataChip(icon: "play.fill", text: duration)
            }
            if let count = item.episodeCount, count > 0 {
                metadataChip(icon: "list.bullet", text: "\(count) \(item.contentType == .podcast ? "حلقة" : "فصل")")
            }
            if let lang = item.language, !lang.isEmpty {
                metadataChip(icon: "globe", text: lang.uppercased())
            }
            if let date = item.publishedAt {
                metadataChip(icon: "calendar", text: formatDate(date))
            }
        }
        .padding(.vertical, AppSpacing.xs)
    }

    private func metadataChip(icon: String, text: String) -> some View {
        HStack(spacing: AppSpacing.xxs) {
            Image(systemName: icon)
                .font(.system(size: 12))
            Text(text)
                .font(AppTypography.small)
        }
        .foregroundColor(AppColors.textSecondary)
    }

    private func descriptionSection(_ description: String) -> some View {
        VStack(alignment: .leading, spacing: AppSpacing.xs) {
            Text("الوصف")
                .font(AppTypography.headline)
                .foregroundColor(AppColors.textPrimary)

            Text(description)
                .font(AppTypography.body)
                .foregroundColor(AppColors.textSecondary)
                .lineSpacing(4)
        }
        .padding(.top, AppSpacing.sm)
    }

    /// Play button: starts playback and shows mini player. Shown whenever item has audio (keeps mini player ready).
    private var playSectionIfNeeded: some View {
        Group {
            if item.audioURL != nil {
                Button(action: {
                    audioPlayback.play(item)
                }) {
                    HStack(spacing: AppSpacing.sm) {
                        Image(systemName: "play.circle.fill")
                            .font(.system(size: 28))
                        Text("استمع الآن")
                            .font(AppTypography.headline)
                    }
                    .foregroundColor(AppColors.textPrimary)
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, AppSpacing.md)
                    .background(AppColors.accent)
                    .clipShape(RoundedRectangle(cornerRadius: 12))
                }
                .buttonStyle(.plain)
                .padding(.top, AppSpacing.md)
            } else {
                Text("لا يتوفر محتوى صوتي")
                    .font(AppTypography.caption)
                    .foregroundColor(AppColors.textSecondary)
                    .frame(maxWidth: .infinity)
                    .padding(.top, AppSpacing.md)
            }
        }
    }

    private func formatDate(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.locale = Locale(identifier: "ar")
        return formatter.string(from: date)
    }
}

#if DEBUG
#Preview("PodcastDetailsView") {
    NavigationStack {
        PodcastDetailsView(item: PreviewData.podcastItem)
            .environmentObject(AudioPlaybackManager())
    }
}

#Preview("PodcastDetailsView - Episode") {
    NavigationStack {
        PodcastDetailsView(item: PreviewData.episodeItem)
            .environmentObject(AudioPlaybackManager())
    }
}
#endif
