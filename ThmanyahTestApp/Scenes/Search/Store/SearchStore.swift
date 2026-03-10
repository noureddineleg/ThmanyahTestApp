//
//  SearchStore.swift
//  ThmanyahTestApp
//
//  Created by Nour-Eddine Legragui  on 10/3/2026.
//

import Foundation

protocol SearchStoreProtocol {
    func search(query: String) async throws -> SearchResult
}

final class SearchStore: SearchStoreProtocol {
    private let service: SearchServiceProtocol

    init(service: SearchServiceProtocol) {
        self.service = service
    }

    func search(query: String) async throws -> SearchResult {
        let response = try await service.search(query: query)
        let sections = response.sections.map { mapToSection($0) }
        return SearchResult(
            query: query,
            sections: sections,
            totalCount: response.totalCount ?? sections.flatMap { $0.items }.count
        )
    }

    private func mapToSection(_ dto: HomeSection, hasMore: Bool = false) -> Section {
        let sectionId = "\(dto.name)-\(dto.type)-\(dto.order)"
        return Section(
            id: sectionId,
            name: dto.name,
            sectionType: SectionType(rawValue: dto.type) ?? .grid,
            contentType: ContentType(rawValue: dto.contentType) ?? .podcast,
            order: dto.order,
            items: dto.content.map { mapToContentItem($0, contentType: dto.contentType) },
            hasMore: hasMore
        )
    }

    private func mapToContentItem(_ dto: ContentItems, contentType: String) -> ContentItem {
        let id = dto.podcastID ?? dto.episodeID ?? dto.audiobookID ?? dto.articleID ?? ""
        let title = dto.name
        let subtitle = dto.podcastName ?? dto.authorName
        let imageURL = URL(string: dto.avatarURL)
        let durationString = formatDuration(dto.duration)
        let contentTypeEnum = ContentType(rawValue: contentType) ?? .podcast
        let publishedAt = parseDate(dto.releaseDate)
        let isPremium = dto.paidIsExclusive ?? dto.paidIsEarlyAccess ?? false
        let description = dto.description.isEmpty ? nil : dto.description
        let audioURL = (dto.audioURL.flatMap { URL(string: $0) }) ?? (dto.separatedAudioURL.flatMap { URL(string: $0) })
        let videoURL: URL? = nil
        return ContentItem(
            id: id.isEmpty ? UUID().uuidString : id,
            title: title,
            subtitle: subtitle,
            description: description,
            imageURL: imageURL,
            duration: durationString,
            contentType: contentTypeEnum, episodeType: dto.episodeType,
            isPremium: isPremium,
            publishedAt: publishedAt,
            episodeCount: dto.episodeCount,
            language: dto.language,
            audioURL: audioURL,
            videoURL: videoURL
        )
    }

    private func formatDuration(_ seconds: Int) -> String? {
        guard seconds > 0 else { return nil }
        if seconds < 60 { return "\(seconds) ث" }
        let minutes = seconds / 60
        if minutes < 60 { return "\(minutes) د" }
        let hours = minutes / 60
        let mins = minutes % 60
        return mins == 0 ? "\(hours) س" : "\(hours) س \(mins) د"
    }

    private func parseDate(_ dateString: String?) -> Date? {
        guard let dateString = dateString else { return nil }
        let formatter = ISO8601DateFormatter()
        formatter.formatOptions = [.withInternetDateTime, .withFractionalSeconds]
        return formatter.date(from: dateString)
            ?? ISO8601DateFormatter().date(from: dateString)
    }
}
