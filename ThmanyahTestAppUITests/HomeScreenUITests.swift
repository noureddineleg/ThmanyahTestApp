//
//  HomeScreenUITests.swift
//  ThmanyahTestAppUITests
//
//  Created by Nour-Eddine Legragui  on 9/3/2026.
//

import XCTest

final class HomeScreenUITests: XCTestCase {
    private var app: XCUIApplication!

    override func setUp() {
        super.setUp()
        continueAfterFailure = false
        app = XCUIApplication()
        app.launch()
    }

    func test_homeScreen_displaysGreeting() {
        XCTAssertTrue(app.staticTexts["مساء الخير"].waitForExistence(timeout: 5))
    }

    func test_tappingSearchButton_opensSearchScreen() {
        let searchButton = app.buttons["magnifyingglass"]
        XCTAssertTrue(searchButton.waitForExistence(timeout: 5))
        searchButton.tap()

        XCTAssertTrue(app.textFields["ابحث عن بودكاست، حلقة، كتاب..."].waitForExistence(timeout: 5))
    }
}
