//
//  SearchResult.swift
//  ThmanyahTestApp
//
//  Created by Nour-Eddine Legragui  on 10/3/2026.
//

import Foundation

struct SearchResult: Equatable {
    let query: String
    let sections: [Section]
    let totalCount: Int
}
