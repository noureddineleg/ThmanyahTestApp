//
//  PreviewData.swift
//  ThmanyahTestApp
//
//  Created by Nour-Eddine Legragui  on 10/3/2026.
//

import Foundation

#if DEBUG
enum PreviewData {
    static let sampleDate: Date = {
        let components = DateComponents(calendar: Calendar(identifier: .gregorian), year: 2024, month: 5, day: 1)
        return components.date ?? Date()
    }()

    static let sampleAudioURL = URL(string: "https://www.soundhelix.com/examples/mp3/SoundHelix-Song-1.mp3")
    static let sampleVideoURL = URL(string: "https://commondatastorage.googleapis.com/gtv-videos-bucket/sample/BigBuckBunny.mp4")

    static let podcastItem = ContentItem(
        id: "podcast-1",
        title: "بودكاست ثمانية - حلقة مميزة جدًا عن المستقبل",
        subtitle: "مع ضيف مميز يتحدث عن التحولات في العالم العربي",
        description: "حلقة خاصة تناقش مستقبل التقنية والمجتمع في العالم العربي مع ضيوف من قطاعات مختلفة.",
        imageURL: URL(string: "https://example.com/podcast.jpg"),
        duration: "32:15",
        contentType: .podcast,
        episodeType: "",
        isPremium: false,
        publishedAt: sampleDate,
        episodeCount: 142,
        language: "ar",
        audioURL: sampleAudioURL,
        videoURL: nil
    )

    static let episodeItem = ContentItem(
        id: "episode-1",
        title: "الحلقة الأولى من السلسلة الجديدة",
        subtitle: "لماذا نحتاج إلى إعادة التفكير في التعليم؟",
        description: "في هذه الحلقة نستكشف تحديات التعليم الحديث وفرص التحول الرقمي.",
        imageURL: URL(string: "https://example.com/episode.jpg"),
        duration: "45:02",
        contentType: .episode,
        episodeType: "",
        isPremium: true,
        publishedAt: sampleDate,
        episodeCount: nil,
        language: "ar",
        audioURL: sampleAudioURL,
        videoURL: nil
    )

    static let audiobookItem = ContentItem(
        id: "audiobook-1",
        title: "كتاب صوتي: حكايات من الجزيرة العربية",
        subtitle: "فصل ٣: التجارة القديمة",
        description: "رحلة عبر تاريخ التجارة في شبه الجزيرة العربية والطرق القديمة.",
        imageURL: URL(string: "https://example.com/audiobook.jpg"),
        duration: "1:15:43",
        contentType: .audiobook,
        episodeType: "",
        isPremium: false,
        publishedAt: sampleDate,
        episodeCount: 12,
        language: "ar",
        audioURL: sampleAudioURL,
        videoURL: nil
    )

    static let audioArticleItem = ContentItem(
        id: "audio-article-1",
        title: "مقال صوتي: كيف نبني عادات يومية صغيرة تصنع فرقًا كبيرًا؟",
        subtitle: "قراءة بصوت راوي ثمانية",
        description: "نصائح عملية لبناء عادات إيجابية والاستمرارية في الحياة اليومية.",
        imageURL: URL(string: "https://example.com/audio-article.jpg"),
        duration: "12:05",
        contentType: .audioArticle,
        episodeType: "",
        isPremium: false,
        publishedAt: sampleDate,
        episodeCount: nil,
        language: "ar",
        audioURL: sampleAudioURL,
        videoURL: nil
    )

    static let videoItem = ContentItem(
        id: "video-1",
        title: "فيديو تجريبي",
        subtitle: "عرض فيديو تجريبي",
        description: nil,
        imageURL: URL(string: "https://example.com/video.jpg"),
        duration: "5:00",
        contentType: .podcast,
        episodeType: "",
        isPremium: false,
        publishedAt: sampleDate,
        episodeCount: nil,
        language: nil,
        audioURL: nil,
        videoURL: sampleVideoURL
    )

    static let allItems: [ContentItem] = [
        podcastItem,
        episodeItem,
        audiobookItem,
        audioArticleItem
    ]

    static let featuredSection = Section(
        id: "section-featured",
        name: "محتوى مميز لك",
        sectionType: .featuredBanner,
        contentType: .podcast,
        order: 0,
        items: [podcastItem],
        hasMore: false
    )

    static let gridSection = Section(
        id: "section-grid",
        name: "برامج بودكاست",
        sectionType: .grid,
        contentType: .podcast,
        order: 1,
        items: [podcastItem, episodeItem, audiobookItem, audioArticleItem],
        hasMore: true
    )

    static let squareGridSection = Section(
        id: "section-square-grid",
        name: "كتب صوتية مختارة",
        sectionType: .squareGrid,
        contentType: .audiobook,
        order: 2,
        items: [audiobookItem, audiobookItem, audiobookItem],
        hasMore: true
    )

    static let horizontalSection = Section(
        id: "section-horizontal",
        name: "استكشاف الحلقات",
        sectionType: .horizontalList,
        contentType: .episode,
        order: 3,
        items: [episodeItem, episodeItem, podcastItem],
        hasMore: true
    )

    static let homeSections: [Section] = [
        featuredSection,
        gridSection,
        squareGridSection,
        horizontalSection
    ]

    static let searchResultNonEmpty = SearchResult(
        query: "ثمانية",
        sections: homeSections,
        totalCount: homeSections.reduce(0) { $0 + $1.items.count }
    )

    static let searchResultEmpty = SearchResult(
        query: "لا يوجد",
        sections: [],
        totalCount: 0
    )
}
#endif
