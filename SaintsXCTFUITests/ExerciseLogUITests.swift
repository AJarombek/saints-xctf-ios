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
        let nameValidationText = elementsQuery.staticTexts["nameValidationText"]
        
        XCTAssertEqual(nameField.value as? String, "")
        XCTAssertFalse(nameValidationText.exists)
        
        nameField.tap()
        nameField.typeText("5th Ave Mile")
        
        XCTAssertEqual(nameField.value as? String, "5th Ave Mile")
        XCTAssertFalse(nameValidationText.exists)
        
        nameField.typeText(String(repeating: XCUIKeyboardKey.delete.rawValue, count: 12))
        XCTAssertEqual(nameField.value as? String, "")
        XCTAssert(nameValidationText.exists)
        
        nameField.typeText("A")
        XCTAssertEqual(nameField.value as? String, "A")
        XCTAssertFalse(nameValidationText.exists)
        
        nameField.typeText(String(repeating: XCUIKeyboardKey.delete.rawValue, count: 1))
        XCTAssertEqual(nameField.value as? String, "")
        XCTAssert(nameValidationText.exists)
    }
    
    func testDistanceTimeFormValidation() throws {
        app.launch()
        signIn(app: app)

        let tabBar = app.tabBars["Tab Bar"]
        tabBar.buttons["New Log"].tap()
        
        let scrollViewsQuery = app.scrollViews
        let elementsQuery = scrollViewsQuery.otherElements
        
        let distanceField = elementsQuery.textFields["distanceField"]
        let distanceValidationText = elementsQuery.staticTexts["distanceValidationText"]
        
        let timeField = elementsQuery.textFields["timeField"]
        let timeValidationText = elementsQuery.staticTexts["timeValidationText"]
        
        XCTAssertEqual(distanceField.value as? String, "")
        XCTAssertFalse(distanceValidationText.exists)
        XCTAssertEqual(timeField.value as? String, "")
        XCTAssertFalse(timeValidationText.exists)
        
        distanceField.tap()
        distanceField.typeText("1")
        
        XCTAssertEqual(distanceField.value as? String, "1")
        XCTAssertFalse(distanceValidationText.exists)
        XCTAssertEqual(timeField.value as? String, "")
        XCTAssertFalse(timeValidationText.exists)
        
        distanceField.typeText(String(repeating: XCUIKeyboardKey.delete.rawValue, count: 1))
        
        XCTAssertEqual(distanceField.value as? String, "")
        XCTAssert(distanceValidationText.exists)
        XCTAssertEqual(timeField.value as? String, "")
        XCTAssert(timeValidationText.exists)
        
        timeField.tap()
        timeField.typeText("439")
        
        XCTAssertEqual(distanceField.value as? String, "")
        XCTAssertFalse(distanceValidationText.exists)
        XCTAssertEqual(timeField.value as? String, "4:39")
        XCTAssertFalse(timeValidationText.exists)
        
        timeField.typeText(String(repeating: XCUIKeyboardKey.delete.rawValue, count: 3))
        
        XCTAssertEqual(distanceField.value as? String, "")
        XCTAssert(distanceValidationText.exists)
        XCTAssertEqual(timeField.value as? String, "")
        XCTAssert(timeValidationText.exists)
    }
    
    func testDistanceTextFiltering() throws {
        app.launch()
        signIn(app: app)

        let tabBar = app.tabBars["Tab Bar"]
        tabBar.buttons["New Log"].tap()
        
        let scrollViewsQuery = app.scrollViews
        let elementsQuery = scrollViewsQuery.otherElements
        
        let distanceField = elementsQuery.textFields["distanceField"]
        XCTAssertEqual(distanceField.value as? String, "")
        
        distanceField.tap()
        distanceField.typeText("Aa! ")
        XCTAssertEqual(distanceField.value as? String, "")
        
        distanceField.typeText("10.40")
        XCTAssertEqual(distanceField.value as? String, "10.40")
        
        distanceField.typeText(".23")
        XCTAssertEqual(distanceField.value as? String, "10.4023")
    }
    
    func testTimeTextFiltering() throws {
        app.launch()
        signIn(app: app)

        let tabBar = app.tabBars["Tab Bar"]
        tabBar.buttons["New Log"].tap()
        
        let scrollViewsQuery = app.scrollViews
        let elementsQuery = scrollViewsQuery.otherElements
        
        let timeField = elementsQuery.textFields["timeField"]
        
        timeField.tap()
        timeField.typeText("Aa! : ")
        XCTAssertEqual(timeField.value as? String, "")
        
        timeField.typeText("1234")
        XCTAssertEqual(timeField.value as? String, "12:34")
    }
}
