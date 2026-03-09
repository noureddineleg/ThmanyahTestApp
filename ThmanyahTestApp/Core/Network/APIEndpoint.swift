//
//  APIEndpoint.swift
//  ThmanyahTestApp
//
//  Created by Nour-Eddine Legragui  on 9/3/2026.
//

import Foundation

enum APIEndpoint {
    case homeSections(page: Int)
    case search(query: String)
}

extension APIEndpoint: Endpoint {
    var baseURL: String {
        switch self {
        case .homeSections:
            return AppConfig.baseAPIURL
        case .search:
            return AppConfig.searchAPIURL
        }
    }

    var path: String {
        switch self {
        case .homeSections:
            return "/home_sections"
        case .search:
            return "/search"
        }
    }

    var method: HTTPMethod {
        switch self {
        case .homeSections, .search:
            return .get
        }
    }

    var queryItems: [URLQueryItem]? {
        switch self {
        case .homeSections(let page):
            return [URLQueryItem(name: "page", value: "\(page)")]
        case .search(let query):
            return [URLQueryItem(name: "q", value: query)]
        }
    }

    var headers: [String: String] {
        [
            "Accept": "application/json",
            "Content-Type": "application/json"
        ]
    }

    var mockFileName: String? {
        switch self {
        case .homeSections:
            return "home_sections"
        case .search:
            return "search_results"
        }
    }
}
