//
//  ProfileUIStubTests.swift
//  SaintsXCTFUITests
//
//  Created by Andrew Jarombek on 6/4/21.
//  Copyright © 2021 Andy Jarombek. All rights reserved.
//

import XCTest

class ProfileUIStubTests: XCTestCase {

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
    

    func testShowsCalendarData() throws {
        apiStubs.stubRequest(path: "/v2/log_feed/all/all/25/0", jsonData: LogFeedStubs().pageOneData)
        apiStubs.stubRequest(
            path: "/v2/range_view/users/andy/r/2021-05-31/2021-07-11",
            jsonData: RangeViewStubs().userAndyCurrentMonthData
        )
        apiStubs.stubRequest(
            path: "/v2/range_view/users/andy/r/2021-04-26/2021-06-06",
            jsonData: RangeViewStubs().userAndyPreviousMonthData
        )
        app.launch()
        
        let tabBar = app.tabBars["Tab Bar"]
        tabBar.buttons["Profile"].tap()
        
        app.staticTexts["Monthly Calendar"].tap()
        app.buttons["prev"].tap()
        app.staticTexts["May 2021"].tap()
        
        app.staticTexts["6.57\n Miles"].tap()
        app.staticTexts["5.87\n Miles"].tap()
    }
}
