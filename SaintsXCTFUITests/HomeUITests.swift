//
//  HomeUITests.swift
//  SaintsXCTFUITests
//
//  Created by Andrew Jarombek on 5/23/21.
//  Copyright © 2021 Andy Jarombek. All rights reserved.
//

import XCTest

class HomeUITests: XCTestCase {
    
    lazy var app = XCUIApplication()

    override func setUpWithError() throws {
        app.launchArguments += ["UI_TESTING"]
        continueAfterFailure = false
    }

    override func tearDownWithError() throws {}
    
    func testDisplaysLogs() throws {
        app.launch()
        signIn(app: app)

        let logTableView = app.tables.matching(identifier: "LogTableView")

        let logCell = logTableView.cells.firstMatch
        XCTAssert(logCell.exists)
    }
    
    func testNavigateToProfile() throws {
        app.launch()
        signIn(app: app)
        
        let tabBar = app.tabBars["Tab Bar"]
        tabBar.buttons["Profile"].tap()
    }
    
    func testNavigateToNewLog() throws {
        app.launch()
        signIn(app: app)
        
        let tabBar = app.tabBars["Tab Bar"]
        tabBar.buttons["New Log"].tap()
    }
    
    func testNavigateToGroups() throws {
        app.launch()
        signIn(app: app)
        
        let tabBar = app.tabBars["Tab Bar"]
        tabBar.buttons["Groups"].tap()
    }
    
    func testNavigateToSignOut() throws {
        app.launch()
        signIn(app: app)
        
        let tabBar = app.tabBars["Tab Bar"]
        tabBar.buttons["Sign Out"].tap()
    }
}
