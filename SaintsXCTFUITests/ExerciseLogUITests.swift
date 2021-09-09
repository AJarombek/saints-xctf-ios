//
//  ExerciseLogUITests.swift
//  SaintsXCTFUITests
//
//  Created by Andrew Jarombek on 9/8/21.
//  Copyright © 2021 Andy Jarombek. All rights reserved.
//

import XCTest

class ExerciseLogUITests: XCTestCase {

    lazy var app = XCUIApplication()

    override func setUpWithError() throws {
        app.launchArguments += ["UI_TESTING"]
        continueAfterFailure = false
    }

    override func tearDownWithError() throws {}
    
    func testShowsCreateLog() throws {
        app.launch()
        signIn(app: app)

        let tabBar = app.tabBars["Tab Bar"]
        tabBar.buttons["New Log"].tap()
        
        
        let app = XCUIApplication()
        app.tabBars["Tab Bar"].buttons["New Log"].tap()
        
        let scrollViewsQuery = app.scrollViews
        let elementsQuery = scrollViewsQuery.otherElements
        
        XCTAssert(elementsQuery.staticTexts["Create Exercise Log"].exists)
        XCTAssert(elementsQuery.staticTexts["Average"].exists)
        XCTAssert(elementsQuery.staticTexts["Exercise Name*"].exists)
        XCTAssert(elementsQuery.staticTexts["Location"].exists)
        XCTAssert(elementsQuery.staticTexts["Date*"].exists)
        XCTAssert(elementsQuery.staticTexts["Exercise Type"].exists)
        XCTAssert(elementsQuery.staticTexts["Distance"].exists)
        XCTAssert(elementsQuery.staticTexts["Time"].exists)
        XCTAssert(elementsQuery.staticTexts["Feel"].exists)
        XCTAssert(elementsQuery.staticTexts["Description"].exists)
        
        XCTAssert(elementsQuery.buttons["Create"].exists)
        XCTAssert(elementsQuery.buttons["Cancel"].exists)
    }
}
