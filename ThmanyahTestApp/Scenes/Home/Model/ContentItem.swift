//
//  ContentItem.swift
//  ThmanyahTestApp
//
//  Created by Nour-Eddine Legragui  on 9/3/2026.
//

import Foundation

struct ContentItem: Identifiable, Equatable, Hashable {
    let id: String
    let title: String
    let subtitle: String?
    /// Full description from API (podcast/show notes, etc.).
    let description: String?
    let imageURL: URL?
    let duration: String?
    let contentType: ContentType
    let isPremium: Bool
    let publishedAt: Date?
    /// Number of episodes (podcast) or chapters when provided by API.
    let episodeCount: Int?
    /// Language code from API (e.g. "en", "ar").
    let language: String?
    /// URL for audio playback (episode, audiobook, audio article).
    let audioURL: URL?
    /// URL for video playback when content has video.
    let videoURL: URL?

    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
}
