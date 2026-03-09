//
//  NetworkError.swift
//  ThmanyahTestApp
//
//  Created by Nour-Eddine Legragui  on 9/3/2026.
//

import Foundation

enum NetworkError: Error, Equatable {
    case invalidURL
    case noData
    case decodingError(String)
    case serverError(Int)
    case networkFailure(String)
    case unknown

    var localizedDescription: String {
        switch self {
        case .invalidURL:
            return "Invalid URL"
        case .noData:
            return "No data received"
        case .decodingError(let message):
            return "Decoding error: \(message)"
        case .serverError(let code):
            return "Server error with code: \(code)"
        case .networkFailure(let message):
            return "Network failure: \(message)"
        case .unknown:
            return "Unknown error occurred"
        }
    }
}
