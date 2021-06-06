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
    

    func testShowsCalendarDataMondayWeekstart() throws {
        apiStubs.stubRequest(path: "/v2/users/andy", jsonData: UserStubs().andyData)
        apiStubs.stubRequest(path: "/v2/log_feed/all/all/25/0", jsonData: LogFeedStubs().pageOneData)
        apiStubs.stubRequest(
            path: "/v2/range_view/user/andy/r/2021-05-31/2021-07-11",
            jsonData: RangeViewStubs().userAndyCurrentMonthData
        )
        apiStubs.stubRequest(
            path: "/v2/range_view/user/andy/r/2021-04-26/2021-06-06",
            jsonData: RangeViewStubs().userAndyPreviousMonthData
        )
        app.launch()
        
        let tabBar = app.tabBars["Tab Bar"]
        tabBar.buttons["Profile"].tap()
        
        app.otherElements["monthlyCalendar"].tap()
        
        let day1 = app.staticTexts["miles1"].value
        XCTAssertEqual(day1 as? String, "7.28\n Miles")
        
        app.buttons["prev"].tap()
        
        // XCTAssertEqual(day1, "2.87\n Miles")
        app.otherElements["totalWeek1"].tap()
    }
    
    func testShowsCalendarDataSundayWeekstart() throws {
        apiStubs.stubRequest(path: "/v2/users/andy", jsonData: UserStubs().andySundayWeekStartData)
        apiStubs.stubRequest(path: "/v2/log_feed/all/all/25/0", jsonData: LogFeedStubs().pageOneData)
        apiStubs.stubRequest(
            path: "/v2/range_view/user/andy/r/2021-05-30/2021-07-10",
            jsonData: RangeViewStubs().userAndyCurrentMonthData
        )
        apiStubs.stubRequest(
            path: "/v2/range_view/user/andy/r/2021-04-25/2021-06-05",
            jsonData: RangeViewStubs().userAndyPreviousMonthData
        )
        app.launch()
    }
}
