//
//  L10n.swift
//  ThmanyahTestApp
//
//  Created by Nour-Eddine Legragui  on 10/3/2026.
//

import Foundation

enum L10n {
    enum Tab {
        static let home = NSLocalizedString("tab.home", value: "الرئيسية", comment: "Home tab title")
        static let search = NSLocalizedString("tab.search", value: "بحث", comment: "Search tab title")
        static let community = NSLocalizedString("tab.community", value: "المجتمع", comment: "Community tab title")
        static let library = NSLocalizedString("tab.library", value: "مكتبتي", comment: "Library tab title")
        static let settings = NSLocalizedString("tab.setting", value: "الإعدادات", comment: "Settings tab title")
    }

    enum Home {
        static let eveningGreeting = NSLocalizedString("home.greeting.evening", value: "مساء الخير", comment: "Evening greeting")
        static let username = NSLocalizedString("home.greeting.username", value: "عبدالرحمن", comment: "Current user name in greeting")
        static let filterAll = NSLocalizedString("home.filter.all", value: "الكل", comment: "All content filter title")
    }
}
