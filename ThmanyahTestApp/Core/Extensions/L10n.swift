//
//  L10n.swift
//  ThmanyahTestApp
//
//  Created by Nour-Eddine Legragui  on 10/3/2026.
//

import Foundation

enum L10n {
    enum Tab {
        static let home = NSLocalizedString("tab.home", comment: "Home tab title")
        static let search = NSLocalizedString("tab.search", comment: "Search tab title")
        static let community = NSLocalizedString("tab.community", comment: "Community tab title")
        static let library = NSLocalizedString("tab.library", comment: "Library tab title")
        static let settings = NSLocalizedString("tab.setting", comment: "Settings tab title")
    }

    enum Home {
        static let eveningGreeting = NSLocalizedString("home.greeting.evening", comment: "Evening greeting")
        static let username = NSLocalizedString("home.greeting.username", comment: "Current user name in greeting")
        static let filterAll = NSLocalizedString("home.filter.all", comment: "All content filter title")
    }
}
