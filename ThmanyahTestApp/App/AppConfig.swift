//
//  AppConfig.swift
//  ThmanyahTestApp
//
//  Created by Nour-Eddine Legragui  on 9/3/2026.
//

import Foundation

enum AppConfig {
    private static func value(forKey key: String) -> String {
        Bundle.main.object(forInfoDictionaryKey: key) as? String ?? ""
    }

    static var baseAPIURL: String {
        value(forKey: "BASE_API_URL")
    }

    static var searchAPIURL: String {
        value(forKey: "SEARCH_API_URL")
    }
}
