//
//  SectionType.swift
//  ThmanyahTestApp
//
//  Created by Nour-Eddine Legragui  on 9/3/2026.
//

import Foundation

enum SectionType: String, Codable {
    case grid = "grid"
    case squareGrid = "square_grid"
    case horizontalList = "horizontal_list"
    case featuredBanner = "featured_banner"
    // API section types
    case square = "square"
    case twoLinesGrid = "2_lines_grid"
    case bigSquare = "big_square"
    case queue = "queue"
    case bigSquareWithSpace = "big square"
}
