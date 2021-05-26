//
//  HomeUITests.swift
//  SaintsXCTFUITests
//
//  Created by Andrew Jarombek on 5/23/21.
//  Copyright © 2021 Andy Jarombek. All rights reserved.
//

import XCTest

class HomeUITests: XCTestCase {
    
    let stubs = Stubs()
    
    lazy var app = XCUIApplication()

    override func setUpWithError() throws {
        try! stubs.server.start(9080)
        continueAfterFailure = false
    }

    override func tearDownWithError() throws {
        stubs.server.stop()
    }
    

    func testDisplaysLogs() throws {
        stubs.stubRequest(path: "/v2/log_feed/all/all/25/0", jsonData: LogFeedStubs().pageOneData)
        app.launch()
        signIn(app: app)

        let logTableView = app.tables.matching(identifier: "LogTableView")

        let logCell = logTableView.cells.firstMatch
        XCTAssert(logCell.exists)
    }
    
    func testAbleToViewProfileFromLog() throws {
        app.launch()
        signIn(app: app)

        let logTableView = app.tables.matching(identifier: "LogTableView")
        let logCell = logTableView.cells.firstMatch
        let nameLabel = logCell.textViews.element(matching: .textView, identifier: "NameLabel")
        print(nameLabel.value!)
    }
}
