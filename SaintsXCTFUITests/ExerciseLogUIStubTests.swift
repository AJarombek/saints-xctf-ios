//
//  ExerciseLogUIStubTests.swift
//  SaintsXCTFUITests
//
//  Created by Andrew Jarombek on 9/14/21.
//  Copyright © 2021 Andy Jarombek. All rights reserved.
//

import XCTest

class ExerciseLogUIStubTests: XCTestCase {

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

    func testCreateLogSuccess() throws {
        apiStubs.stubRequest(path: "/v2/logs/", jsonData: LogStubs().createdData, verb: .post)
        app.launch()
        signIn(app: app)

        let tabBar = app.tabBars["Tab Bar"]
        tabBar.buttons["New Log"].tap()
        
        let scrollViewsQuery = app.scrollViews
        let elementsQuery = scrollViewsQuery.otherElements
        
        let nameField = elementsQuery.textFields["Name Field"]
        let locationField = elementsQuery.textFields["Location Field"]
        let distanceField = elementsQuery.textFields["Distance Field"]
        let timeField = elementsQuery.textFields["Time Field"]
        let descriptionField = elementsQuery.textFields["Description Field"]
        let feelSlider = elementsQuery.sliders["Feel"]
        
        nameField.tap()
        nameField.typeText("Central Park")
        
        locationField.tap()
        locationField.typeText("New York, NY")
        
        distanceField.tap()
        distanceField.typeText("6.3")
        
        timeField.tap()
        timeField.typeText("43")
        timeField.typeText("21")
        
        feelSlider.adjust(toNormalizedSliderPosition: 0.7)
        
        descriptionField.tap()
        descriptionField.typeText("Wednesday AM Run")
        
        let alert = app.alerts["Exercise log created!"]
        XCTAssertFalse(alert.exists)
        
        let createButton = elementsQuery.buttons["Create"]
        createButton.tap()
        
        XCTAssert(elementsQuery.staticTexts["Average"].waitForExistence(timeout: 2))
        XCTAssert(alert.exists)
        
        alert.buttons["Continue"].tap()
        XCTAssertFalse(alert.exists)
        
        XCTAssertEqual(nameField.value as? String, "")
        XCTAssertEqual(locationField.value as? String, "")
        XCTAssertEqual(distanceField.value as? String, "")
        XCTAssertEqual(timeField.value as? String, "")
        XCTAssert(elementsQuery.staticTexts["Average"].exists)
        XCTAssertEqual(descriptionField.value as? String, "")
    }
    
    func testCreateLogFailure() throws {
        apiStubs.stubRequest(path: "/v2/logs/", jsonData: LogStubs().createdData, verb: .post, status: .badRequest)
        app.launch()
        signIn(app: app)

        let tabBar = app.tabBars["Tab Bar"]
        tabBar.buttons["New Log"].tap()
        
        let scrollViewsQuery = app.scrollViews
        let elementsQuery = scrollViewsQuery.otherElements
        
        let nameField = elementsQuery.textFields["Name Field"]
        let locationField = elementsQuery.textFields["Location Field"]
        let distanceField = elementsQuery.textFields["Distance Field"]
        let timeField = elementsQuery.textFields["Time Field"]
        let descriptionField = elementsQuery.textFields["Description Field"]
        let feelSlider = elementsQuery.sliders["Feel"]
        
        nameField.tap()
        nameField.typeText("Central Park Hills")
        
        locationField.tap()
        locationField.typeText("New York, NY")
        
        distanceField.tap()
        distanceField.typeText("10.75")
        
        timeField.tap()
        timeField.typeText("1")
        timeField.typeText("13")
        timeField.typeText("02")
        
        feelSlider.adjust(toNormalizedSliderPosition: 0.8)
        
        descriptionField.tap()
        descriptionField.typeText("Thursday Hill Workout")
        
        let alert = app.alerts["An unexpected error occurred while creating an exercise log."]
        XCTAssertFalse(alert.exists)
        
        let createButton = elementsQuery.buttons["Create"]
        createButton.tap()
        
        XCTAssert(alert.waitForExistence(timeout: 2))
        
        alert.buttons["Try Again"].tap()
        XCTAssert(alert.waitForExistence(timeout: 2))
        
        alert.buttons["Cancel"].tap()
        XCTAssertFalse(alert.exists)
        
        XCTAssertEqual(nameField.value as? String, "Central Park Hills")
        XCTAssertEqual(locationField.value as? String, "New York, NY")
        XCTAssertEqual(distanceField.value as? String, "10.75")
        XCTAssertEqual(timeField.value as? String, "1:13:02")
        XCTAssert(elementsQuery.staticTexts["Good"].exists)
        XCTAssertEqual(descriptionField.value as? String, "Thursday Hill Workout")
    }
}
