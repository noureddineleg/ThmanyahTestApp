//
//  APIEndpoint.swift
//  ThmanyahTestApp
//
//  Created by Nour-Eddine Legragui  on 9/3/2026.
//

import Foundation

enum APIEndpoint {
    case homeSections
    case search(query: String)
    
    var baseURL: String {
        switch self {
        case .homeSections:
            return "https://api-v2-b2sit6oh3a-uc.a.run.app"
        case .search:
            return "https://mock.apidog.com/m1/735111-711675-default"
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
        case .homeSections:
            return nil
        case .search(let query):
            return [URLQueryItem(name: "q", value: query)]
        }
    }
    
    func asURL() throws -> URL {
        guard var components = URLComponents(string: baseURL + path) else {
            throw NetworkError.invalidURL
        }
        components.queryItems = queryItems
        guard let url = components.url else {
            throw NetworkError.invalidURL
        }
        return url
    }
}
