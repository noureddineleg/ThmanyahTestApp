//
//  ContentType.swift
//  ThmanyahTestApp
//
//  Created by Nour-Eddine Legragui  on 9/3/2026.
//

enum ContentType: String, Codable, CaseIterable {
    case podcast = "podcast"
    case episode = "episode"
    case audiobook = "audiobook"
    case audioArticle = "audio_article"

    var displayName: String {
        switch self {
        case .podcast: return "بودكاست"
        case .episode: return "حلقات"
        case .audiobook: return "كتب صوتية"
        case .audioArticle: return "مقالات صوتية"
        }
    }
}
