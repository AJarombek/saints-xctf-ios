//
//  HomeUIStubTests.swift
//  SaintsXCTFUITests
//
//  Created by Andrew Jarombek on 5/26/21.
//  Copyright © 2021 Andy Jarombek. All rights reserved.
//

import XCTest

class HomeUIStubTests: XCTestCase {

    let apiStubs = Stubs()
    
    lazy var app = XCUIApplication()

    override func setUpWithError() throws {
        try! apiStubs.server.start(9080)
        app.launchArguments += ["UI_STUB_TESTING"]
        continueAfterFailure = false
    }

    override func tearDownWithError() throws {
        apiStubs.server.stop()
    }
    

    func testDisplaysLogs() throws {
        apiStubs.stubRequest(path: "/v2/log_feed/all/all/25/0", jsonData: LogFeedStubs().pageOneData)
        app.launch()
        signIn(app: app)

        let logTableView = app.tables.matching(identifier: "LogTableView")

        let logCell = logTableView.cells.firstMatch
        XCTAssert(logCell.exists)
    }
    
    func testAbleToViewProfileFromLog() throws {
        apiStubs.stubRequest(path: "/v2/log_feed/all/all/25/0", jsonData: LogFeedStubs().pageOneData)
        app.launch()
        signIn(app: app)

        let logTableView = app.tables.matching(identifier: "LogTableView")
        let logCell = logTableView.cells.firstMatch
        let nameLabel = logCell.textViews.element(matching: .textView, identifier: "NameLabel")
        print(nameLabel.value!)
    }
}
