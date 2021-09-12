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
    
    func testSliderChangesFeel() throws {
        app.launch()
        signIn(app: app)

        let tabBar = app.tabBars["Tab Bar"]
        tabBar.buttons["New Log"].tap()
        
        let scrollViewsQuery = app.scrollViews
        let elementsQuery = scrollViewsQuery.otherElements
        let feelSlider = elementsQuery.sliders["feel"]
        
        XCTAssert(elementsQuery.staticTexts["Average"].exists)
        
        feelSlider.adjust(toNormalizedSliderPosition: 0.0)
        XCTAssert(elementsQuery.staticTexts["Terrible"].exists)
        
        feelSlider.adjust(toNormalizedSliderPosition: 0.1)
        XCTAssert(elementsQuery.staticTexts["Very Bad"].exists)
        
        feelSlider.adjust(toNormalizedSliderPosition: 0.2)
        XCTAssert(elementsQuery.staticTexts["Bad"].exists)
        
        feelSlider.adjust(toNormalizedSliderPosition: 0.3)
        XCTAssert(elementsQuery.staticTexts["Pretty Bad"].exists)
        
        feelSlider.adjust(toNormalizedSliderPosition: 0.4)
        XCTAssert(elementsQuery.staticTexts["Mediocre"].exists)
        
        feelSlider.adjust(toNormalizedSliderPosition: 0.6)
        XCTAssert(elementsQuery.staticTexts["Average"].exists)
        
        feelSlider.adjust(toNormalizedSliderPosition: 0.7)
        XCTAssert(elementsQuery.staticTexts["Fairly Good"].exists)
        
        feelSlider.adjust(toNormalizedSliderPosition: 0.8)
        XCTAssert(elementsQuery.staticTexts["Good"].exists)
        
        feelSlider.adjust(toNormalizedSliderPosition: 0.9)
        XCTAssert(elementsQuery.staticTexts["Great"].exists)
        
        feelSlider.adjust(toNormalizedSliderPosition: 1.0)
        XCTAssert(elementsQuery.staticTexts["Fantastic"].exists)
    }
    
    func testNameFormValidation() throws {
        app.launch()
        signIn(app: app)

        let tabBar = app.tabBars["Tab Bar"]
        tabBar.buttons["New Log"].tap()
        
        let scrollViewsQuery = app.scrollViews
        let elementsQuery = scrollViewsQuery.otherElements
        
        let nameField = elementsQuery.textFields["nameField"]
        nameField.tap()
        nameField.typeText("5th Ave Mile")
        
        XCTAssertEqual(nameField.value as? String, "5th Ave Mile")
    }
}
