//
//  HomeUITests.swift
//  SaintsXCTFUITests
//
//  Created by Andrew Jarombek on 5/23/21.
//  Copyright © 2021 Andy Jarombek. All rights reserved.
//

import XCTest

class HomeUITests: XCTestCase {

    override func setUpWithError() throws {
        continueAfterFailure = false
        let app = XCUIApplication()
        app.launch()
        signIn(app: app)
    }

    override func tearDownWithError() throws {}
    

    func testDisplaysLogs() throws {
        let app = XCUIApplication()
        let logTableView = app.tables.matching(identifier: "LogTableView")

        let logCell = logTableView.cells.firstMatch
        XCTAssert(logCell.exists)
    }
    
    func testAbleToViewProfileFromLog() throws {
        let app = XCUIApplication()
        let logTableView = app.tables.matching(identifier: "LogTableView")
        let logCell = logTableView.cells.firstMatch
        let nameLabel = logCell.textViews.element(matching: .textView, identifier: "NameLabel")
        print(nameLabel.value!)
    }
}
