//
//  HomeStore.swift
//  ThmanyahTestApp
//
//  Created by Nour-Eddine Legragui  on 9/3/2026.
//

import Foundation

protocol HomeStoreProtocol {
    func fetchHomeSections(page: Int) async throws -> [Section]
}

final class HomeStore: HomeStoreProtocol {
    private let service: HomeServiceProtocol

    init(service: HomeServiceProtocol) {
        self.service = service
    }

    func fetchHomeSections(page: Int) async throws -> [Section] {
        let response = try await service.fetchHomeSections(page: page)
        let hasMore = (response.pagination?.nextPage).map { !$0.isEmpty } ?? false
        return response.sections
            .enumerated()
            .map { index, dto in
                mapToSection(dto, page: page, index: index, hasMore: hasMore)
            }
            .sorted { $0.order < $1.order }
    }

    private func mapToSection(_ dto: HomeSection, page: Int, index: Int, hasMore: Bool) -> Section {
        let sectionId = "\(dto.baseSectionIdentifier)-p\(page)-i\(index)"
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
        let description = dto.description.isEmpty ? nil : dto.description
        let imageURL = URL(string: dto.avatarURL)
        let durationString = formatDuration(dto.duration)
        let contentTypeEnum = ContentType(rawValue: contentType) ?? .podcast
        let publishedAt = parseDate(dto.releaseDate)
        let isPremium = dto.paidIsExclusive ?? dto.paidIsEarlyAccess ?? false
        let audioURL = (dto.audioURL.flatMap { URL(string: $0) }) ?? (dto.separatedAudioURL.flatMap { URL(string: $0) })
        let videoURL: URL? = nil
        return ContentItem(
            id: id.isEmpty ? UUID().uuidString : id,
            title: title,
            subtitle: subtitle,
            description: description,
            imageURL: imageURL,
            duration: durationString,
            contentType: contentTypeEnum,
            episodeType: dto.episodeType,
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
        if seconds < 60 {
            return "\(seconds) ث"
        }
        let minutes = seconds / 60
        if minutes < 60 {
            return "\(minutes) د"
        }
        let hours = minutes / 60
        let mins = minutes % 60
        if mins == 0 {
            return "\(hours) س"
        }
        return "\(hours) س \(mins) د"
    }

    private func parseDate(_ dateString: String?) -> Date? {
        guard let dateString = dateString else { return nil }
        let formatter = ISO8601DateFormatter()
        formatter.formatOptions = [.withInternetDateTime, .withFractionalSeconds]
        return formatter.date(from: dateString)
            ?? ISO8601DateFormatter().date(from: dateString)
    }
}
