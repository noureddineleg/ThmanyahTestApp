//
//  Endpoint.swift
//  ThmanyahTestApp
//
//  Created by Nour-Eddine Legragui  on 9/3/2026.
//

import Foundation

protocol Endpoint {
    var baseURL: String { get }
    var path: String { get }
    var method: HTTPMethod { get }
    var queryItems: [URLQueryItem]? { get }
    var headers: [String: String] { get }
    var mockFileName: String? { get }
}

extension Endpoint {
    func asURLRequest() throws -> URLRequest {
        let base = baseURL.trimmingCharacters(in: CharacterSet(charactersIn: "/"))
        let pathNorm = path.hasPrefix("/") ? path : "/" + path
        guard !base.isEmpty else {
            throw NetworkError.invalidURL
        }
        let urlString = base + pathNorm
        guard var components = URLComponents(string: urlString) else {
            throw NetworkError.invalidURL
        }
        components.queryItems = queryItems
        guard let url = components.url else {
            throw NetworkError.invalidURL
        }

        var request = URLRequest(url: url)
        request.httpMethod = method.rawValue
        request.timeoutInterval = 30
        headers.forEach { key, value in
            request.setValue(value, forHTTPHeaderField: key)
        }
        return request
    }
}

