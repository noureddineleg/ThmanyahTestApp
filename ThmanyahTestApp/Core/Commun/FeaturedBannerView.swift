//
//  FeaturedBannerView.swift
//  ThmanyahTestApp
//
//  Created by Nour-Eddine Legragui  on 10/3/2026.
//
import SwiftUI

struct FeaturedBannerView: View {
    let section: Section
    @EnvironmentObject private var navigation: NavigationManager
    @EnvironmentObject private var audioPlayback: AudioPlaybackManager

    var body: some View {
        VStack(alignment: .leading, spacing: AppSpacing.sm) {
            SectionHeaderView(title: section.name, showSeeAll: false)

            if let firstItem = section.items.first {
                ZStack(alignment: .bottomLeading) {
                    AsyncImageView(url: firstItem.imageURL)
                        .frame(height: 200)
                        .clipShape(RoundedRectangle(cornerRadius: 16))

                    LinearGradient(
                        gradient: Gradient(colors: [.clear, .black.opacity(0.8)]),
                        startPoint: .top,
                        endPoint: .bottom
                    )
                    .clipShape(RoundedRectangle(cornerRadius: 16))

                    VStack(alignment: .leading, spacing: AppSpacing.xxs) {
                        Text(firstItem.title)
                            .font(AppTypography.title)
                            .foregroundColor(.white)

                        if let subtitle = firstItem.subtitle {
                            Text(subtitle)
                                .font(AppTypography.body)
                                .foregroundColor(.white.opacity(0.8))
                        }
                    }
                    .padding(AppSpacing.md)

                    Button(action: { playAndOpenReader(firstItem) }) {
                        Image(systemName: "play.circle.fill")
                            .font(.system(size: 56))
                            .foregroundStyle(.white)
                            .shadow(color: .black.opacity(0.5), radius: 2, x: 0, y: 1)
                    }
                    .buttonStyle(.plain)
                    .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .center)
                }
                .contentShape(Rectangle())
                .onTapGesture {
                    openDetails(firstItem)
                }
            }
        }
        .padding(.horizontal, AppSpacing.md)
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
#Preview("FeaturedBannerView") {
    FeaturedBannerView(section: PreviewData.featuredSection)
        .background(AppColors.background)
        .environmentObject(NavigationManager())
        .environmentObject(AudioPlaybackManager())
}
#endif
