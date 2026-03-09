//
//  ContentItems.swift
//  ThmanyahTestApp
//
//  Created by Nour-Eddine Legragui  on 9/3/2026.
//

import Foundation

// MARK: - Content (API content item: podcast, episode, audiobook, article)

/// Single DTO for API content items; decoding is tolerant of missing or wrong-type values.
struct ContentItems: Decodable {
    let podcastID: String?
    let name: String
    let description: String
    let avatarURL: String
    let episodeCount: Int?
    let duration: Int
    let language: String?
    let priority: Int?
    let popularityScore: Int?
    let score: Double
    let podcastPopularityScore: Int?
    let podcastPriority: Int?
    let episodeID: String?
    let seasonNumber: JSONNull?
    let episodeType: String?
    let podcastName: String?
    let authorName: String?
    let number: JSONNull?
    let separatedAudioURL: String?
    let audioURL: String?
    let releaseDate: String?
    let chapters: [JSONAny]?
    let paidIsEarlyAccess: Bool?
    let paidIsNowEarlyAccess: Bool?
    let paidIsExclusive: Bool?
    let paidTranscriptURL: JSONNull?
    let freeTranscriptURL: JSONNull?
    let paidIsExclusivePartially: Bool?
    let paidExclusiveStartTime: Int?
    let paidEarlyAccessDate: JSONNull?
    let paidEarlyAccessAudioURL: JSONNull?
    let paidExclusivityType: JSONNull?
    let audiobookID: String?
    let articleID: String?

    /// Raw values match convertFromSnakeCase output so "audio_url" and "avatar_url" (and other API keys) decode correctly.
    enum CodingKeys: String, CodingKey {
        case podcastID = "podcastId"
        case name
        case description
        case avatarURL = "avatarUrl"
        case episodeCount = "episodeCount"
        case duration
        case language
        case priority
        case popularityScore = "popularityScore"
        case score
        case podcastPopularityScore = "podcastPopularityScore"
        case podcastPriority = "podcastPriority"
        case episodeID = "episodeId"
        case seasonNumber = "seasonNumber"
        case episodeType = "episodeType"
        case podcastName = "podcastName"
        case authorName = "authorName"
        case number
        case separatedAudioURL = "separatedAudioUrl"
        case audioURL = "audioUrl"
        case releaseDate = "releaseDate"
        case chapters
        case paidIsEarlyAccess = "paidIsEarlyAccess"
        case paidIsNowEarlyAccess = "paidIsNowEarlyAccess"
        case paidIsExclusive = "paidIsExclusive"
        case paidTranscriptURL = "paidTranscriptUrl"
        case freeTranscriptURL = "freeTranscriptUrl"
        case paidIsExclusivePartially = "paidIsExclusivePartially"
        case paidExclusiveStartTime = "paidExclusiveStartTime"
        case paidEarlyAccessDate = "paidEarlyAccessDate"
        case paidEarlyAccessAudioURL = "paidEarlyAccessAudioUrl"
        case paidExclusivityType = "paidExclusivityType"
        case audiobookID = "audiobookId"
        case articleID = "articleId"
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        podcastID = try container.decodeIfPresent(String.self, forKey: .podcastID)
        name = try container.decodeIfPresent(String.self, forKey: .name) ?? ""
        description = try container.decodeIfPresent(String.self, forKey: .description) ?? ""
        avatarURL = try container.decodeIfPresent(String.self, forKey: .avatarURL) ?? ""
        episodeCount = Self.decodeInt(container, forKey: .episodeCount)
        duration = Self.decodeDuration(container)
        language = try container.decodeIfPresent(String.self, forKey: .language)
        priority = Self.decodeInt(container, forKey: .priority)
        popularityScore = Self.decodeInt(container, forKey: .popularityScore)
        score = Self.decodeScore(container)
        podcastPopularityScore = Self.decodeInt(container, forKey: .podcastPopularityScore)
        podcastPriority = Self.decodeInt(container, forKey: .podcastPriority)
        episodeID = try container.decodeIfPresent(String.self, forKey: .episodeID)
        seasonNumber = try? container.decode(JSONNull.self, forKey: .seasonNumber)
        episodeType = try container.decodeIfPresent(String.self, forKey: .episodeType)
        podcastName = try container.decodeIfPresent(String.self, forKey: .podcastName)
        authorName = try container.decodeIfPresent(String.self, forKey: .authorName)
        number = try? container.decode(JSONNull.self, forKey: .number)
        separatedAudioURL = try container.decodeIfPresent(String.self, forKey: .separatedAudioURL)
        audioURL = try container.decodeIfPresent(String.self, forKey: .audioURL)
        releaseDate = try container.decodeIfPresent(String.self, forKey: .releaseDate)
        chapters = try container.decodeIfPresent([JSONAny].self, forKey: .chapters)
        paidIsEarlyAccess = try container.decodeIfPresent(Bool.self, forKey: .paidIsEarlyAccess)
        paidIsNowEarlyAccess = try container.decodeIfPresent(Bool.self, forKey: .paidIsNowEarlyAccess)
        paidIsExclusive = try container.decodeIfPresent(Bool.self, forKey: .paidIsExclusive)
        paidTranscriptURL = try? container.decode(JSONNull.self, forKey: .paidTranscriptURL)
        freeTranscriptURL = try? container.decode(JSONNull.self, forKey: .freeTranscriptURL)
        paidIsExclusivePartially = try container.decodeIfPresent(Bool.self, forKey: .paidIsExclusivePartially)
        paidExclusiveStartTime = Self.decodeInt(container, forKey: .paidExclusiveStartTime)
        paidEarlyAccessDate = try? container.decode(JSONNull.self, forKey: .paidEarlyAccessDate)
        paidEarlyAccessAudioURL = try? container.decode(JSONNull.self, forKey: .paidEarlyAccessAudioURL)
        paidExclusivityType = try? container.decode(JSONNull.self, forKey: .paidExclusivityType)
        audiobookID = try container.decodeIfPresent(String.self, forKey: .audiobookID)
        articleID = try container.decodeIfPresent(String.self, forKey: .articleID)
    }

    private static func decodeDuration(_ container: KeyedDecodingContainer<ContentItems.CodingKeys>) -> Int {
        if let i = try? container.decode(Int.self, forKey: .duration) { return i }
        if let s = try? container.decode(String.self, forKey: .duration), let i = Int(s) { return i }
        return 0
    }

    /// Decode Int or String (search API can send numbers as strings).
    private static func decodeInt(_ container: KeyedDecodingContainer<ContentItems.CodingKeys>, forKey key: ContentItems.CodingKeys) -> Int? {
        if let i = try? container.decode(Int.self, forKey: key) { return i }
        if let s = try? container.decode(String.self, forKey: key), let i = Int(s) { return i }
        return nil
    }

    /// Decode Double or String (search API can send score as string).
    private static func decodeScore(_ container: KeyedDecodingContainer<ContentItems.CodingKeys>) -> Double {
        if let d = try? container.decode(Double.self, forKey: .score) { return d }
        if let s = try? container.decode(String.self, forKey: .score), let d = Double(s) { return d }
        return 0
    }
}

// MARK: - JSONAny (for chapters and other arbitrary JSON)

struct JSONAny: Codable {
    let value: Any

    init(_ value: Any) {
        self.value = value
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        if container.decodeNil() {
            value = NSNull()
        } else if let bool = try? container.decode(Bool.self) {
            value = bool
        } else if let int = try? container.decode(Int.self) {
            value = int
        } else if let double = try? container.decode(Double.self) {
            value = double
        } else if let string = try? container.decode(String.self) {
            value = string
        } else if let array = try? container.decode([JSONAny].self) {
            value = array.map { $0.value }
        } else if let dict = try? container.decode([String: JSONAny].self) {
            value = dict.mapValues { $0.value }
        } else {
            throw DecodingError.dataCorruptedError(in: container, debugDescription: "JSONAny cannot decode value")
        }
    }

    func encode(to encoder: Encoder) throws {
        var container = encoder.singleValueContainer()
        switch value {
        case is NSNull:
            try container.encodeNil()
        case let bool as Bool:
            try container.encode(bool)
        case let int as Int:
            try container.encode(int)
        case let double as Double:
            try container.encode(double)
        case let string as String:
            try container.encode(string)
        case let array as [Any]:
            try container.encode(array.map { JSONAny($0) })
        case let dict as [String: Any]:
            try container.encode(dict.mapValues { JSONAny($0) })
        default:
            try container.encodeNil()
        }
    }
}
