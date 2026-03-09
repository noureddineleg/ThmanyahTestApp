//
//  NetworkingManager.swift
//  ThmanyahTestApp
//
//  Created by Nour-Eddine Legragui  on 9/3/2026.
//

import Foundation
import Alamofire

protocol NetworkingManaging {
    func request<T: Decodable>(_ endpoint: Endpoint) async throws -> T
}

final class NetworkingManager: NetworkingManaging {
    private let urlSession: URLSession
    private let decoder: JSONDecoder

    init(
        urlSession: URLSession = .shared,
        decoder: JSONDecoder = JSONDecoder()
    ) {
        self.urlSession = urlSession
        self.decoder = decoder
        configureDecoder()
    }

    private func configureDecoder() {
        decoder.keyDecodingStrategy = .convertFromSnakeCase
        decoder.dateDecodingStrategy = .iso8601
    }

    func request<T: Decodable>(_ endpoint: Endpoint) async throws -> T {
        let request = try endpoint.asURLRequest()

        do {
            let (data, response) = try await urlSession.data(for: request)

            guard let httpResponse = response as? HTTPURLResponse else {
                throw NetworkError.unknown
            }

            guard (200...299).contains(httpResponse.statusCode) else {
                throw NetworkError.serverError(httpResponse.statusCode)
            }

            let dataToDecode = data.isEmpty ? Data("{}".utf8) : data
            do {
                return try decoder.decode(T.self, from: dataToDecode)
            } catch {
                if data.isEmpty {
                    throw NetworkError.noData
                }
                throw NetworkError.decodingError(error.localizedDescription)
            }
        } catch let error as NetworkError {
            throw error
        } catch {
            throw NetworkError.networkFailure(error.localizedDescription)
        }
    }
}
