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
        let feelSlider = elementsQuery.sliders["Feel"]
        
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
        
        let nameField = elementsQuery.textFields["Name Field"]
        let nameValidationText = elementsQuery.staticTexts["Name Validation Text"]
        
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
        
        let distanceField = elementsQuery.textFields["Distance Field"]
        let distanceValidationText = elementsQuery.staticTexts["Distance Validation Text"]
        
        let timeField = elementsQuery.textFields["Time Field"]
        let timeValidationText = elementsQuery.staticTexts["Time Validation Text"]
        
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
        
        let distanceField = elementsQuery.textFields["Distance Field"]
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
        
        let timeField = elementsQuery.textFields["Time Field"]
        
        timeField.tap()
        timeField.typeText("Aa! : ")
        XCTAssertEqual(timeField.value as? String, "")
        
        timeField.typeText("1234")
        XCTAssertEqual(timeField.value as? String, "12:34")
    }
    
    func testTimeTextFormatting() throws {
        app.launch()
        signIn(app: app)

        let tabBar = app.tabBars["Tab Bar"]
        tabBar.buttons["New Log"].tap()
        
        let scrollViewsQuery = app.scrollViews
        let elementsQuery = scrollViewsQuery.otherElements
        
        let timeField = elementsQuery.textFields["Time Field"]
        
        timeField.tap()
        timeField.typeText("1")
        XCTAssertEqual(timeField.value as? String, "1")
        
        timeField.typeText("2")
        XCTAssertEqual(timeField.value as? String, "12")
        
        timeField.typeText("3")
        XCTAssertEqual(timeField.value as? String, "1:23")
        
        timeField.typeText("4")
        XCTAssertEqual(timeField.value as? String, "12:34")
        
        timeField.typeText("5")
        XCTAssertEqual(timeField.value as? String, "1:23:45")
        
        timeField.typeText("6")
        XCTAssertEqual(timeField.value as? String, "12:34:56")
        
        timeField.typeText("7")
        XCTAssertEqual(timeField.value as? String, "12:34:56")
        
        timeField.typeText(String(repeating: XCUIKeyboardKey.delete.rawValue, count: 1))
        XCTAssertEqual(timeField.value as? String, "1:23:45")
        
        timeField.typeText(String(repeating: XCUIKeyboardKey.delete.rawValue, count: 1))
        XCTAssertEqual(timeField.value as? String, "12:34")
        
        timeField.typeText(String(repeating: XCUIKeyboardKey.delete.rawValue, count: 1))
        XCTAssertEqual(timeField.value as? String, "1:23")
        
        timeField.typeText(String(repeating: XCUIKeyboardKey.delete.rawValue, count: 1))
        XCTAssertEqual(timeField.value as? String, "12")
        
        timeField.typeText(String(repeating: XCUIKeyboardKey.delete.rawValue, count: 1))
        XCTAssertEqual(timeField.value as? String, "1")
        
        timeField.typeText(String(repeating: XCUIKeyboardKey.delete.rawValue, count: 1))
        XCTAssertEqual(timeField.value as? String, "")
    }
    
    func testNameTextLimit() throws {
        app.launch()
        signIn(app: app)

        let tabBar = app.tabBars["Tab Bar"]
        tabBar.buttons["New Log"].tap()
        
        let scrollViewsQuery = app.scrollViews
        let elementsQuery = scrollViewsQuery.otherElements
        
        let nameField = elementsQuery.textFields["Name Field"]
        nameField.tap()
        nameField.typeText(String(repeating: "x", count: 45))
        XCTAssertEqual(nameField.value as? String, String(repeating: "x", count: 40))
    }
    
    func testLocationTextLimit() throws {
        app.launch()
        signIn(app: app)

        let tabBar = app.tabBars["Tab Bar"]
        tabBar.buttons["New Log"].tap()
        
        let scrollViewsQuery = app.scrollViews
        let elementsQuery = scrollViewsQuery.otherElements
        
        let locationField = elementsQuery.textFields["Location Field"]
        locationField.tap()
        locationField.typeText(String(repeating: "x", count: 55))
        XCTAssertEqual(locationField.value as? String, String(repeating: "x", count: 50))
    }
    
    func testTimeTextLimit() throws {
        app.launch()
        signIn(app: app)

        let tabBar = app.tabBars["Tab Bar"]
        tabBar.buttons["New Log"].tap()
        
        let scrollViewsQuery = app.scrollViews
        let elementsQuery = scrollViewsQuery.otherElements
        
        let timeField = elementsQuery.textFields["Time Field"]
        timeField.tap()
        timeField.typeText(String(repeating: "1", count: 10))
        XCTAssertEqual(timeField.value as? String, "11:11:11")
    }
    
    func testDescriptionTextLimit() throws {
        app.launch()
        signIn(app: app)

        let tabBar = app.tabBars["Tab Bar"]
        tabBar.buttons["New Log"].tap()
        
        let scrollViewsQuery = app.scrollViews
        let elementsQuery = scrollViewsQuery.otherElements
        
        let descriptionField = elementsQuery.textFields["Description Field"]
        descriptionField.tap()
        descriptionField.typeText(String(repeating: "x", count: 1005))
        XCTAssertEqual(descriptionField.value as? String, String(repeating: "x", count: 1000))
    }
    
    func testCancelButtonShowsAlert() throws {
        app.launch()
        signIn(app: app)

        let tabBar = app.tabBars["Tab Bar"]
        tabBar.buttons["New Log"].tap()
        
        let scrollViewsQuery = app.scrollViews
        let elementsQuery = scrollViewsQuery.otherElements
        let cancelButton = elementsQuery.buttons["Cancel"]
        
        let alert = app.alerts["Are you sure you want to cancel your changes?"]
        XCTAssertFalse(alert.exists)
        
        cancelButton.tap()
        XCTAssert(alert.exists)
        
        alert.buttons["Yes"].tap()
        XCTAssertFalse(alert.exists)
        
        cancelButton.tap()
        XCTAssert(alert.exists)
        
        alert.buttons["No"].tap()
        XCTAssertFalse(alert.exists)
    }
    
    func testCancelButtonResetsFields() throws {
        app.launch()
        signIn(app: app)

        let tabBar = app.tabBars["Tab Bar"]
        tabBar.buttons["New Log"].tap()
        
        let scrollViewsQuery = app.scrollViews
        let elementsQuery = scrollViewsQuery.otherElements
        let cancelButton = elementsQuery.buttons["Cancel"]
        let alert = app.alerts["Are you sure you want to cancel your changes?"]
        
        let nameField = elementsQuery.textFields["Name Field"]
        let locationField = elementsQuery.textFields["Location Field"]
        let distanceField = elementsQuery.textFields["Distance Field"]
        let timeField = elementsQuery.textFields["Time Field"]
        let descriptionField = elementsQuery.textFields["Description Field"]
        let feelSlider = elementsQuery.sliders["Feel"]
        
        nameField.tap()
        nameField.typeText("Riverside Park")
        
        locationField.tap()
        locationField.typeText("New York, NY")
        
        distanceField.tap()
        distanceField.typeText("16")
        
        timeField.tap()
        timeField.typeText("1")
        timeField.typeText("54")
        timeField.typeText("24")
        
        feelSlider.adjust(toNormalizedSliderPosition: 0.7)
        
        descriptionField.tap()
        descriptionField.typeText("Monday Long Run")
        
        XCTAssertEqual(nameField.value as? String, "Riverside Park")
        XCTAssertEqual(locationField.value as? String, "New York, NY")
        XCTAssertEqual(distanceField.value as? String, "16")
        XCTAssertEqual(timeField.value as? String, "1:54:24")
        XCTAssert(elementsQuery.staticTexts["Fairly Good"].exists)
        XCTAssertEqual(descriptionField.value as? String, "Monday Long Run")
        
        cancelButton.tap()
        alert.buttons["Yes"].tap()
        
        XCTAssert(elementsQuery.staticTexts["Average"].waitForExistence(timeout: 2))
        
        XCTAssertEqual(nameField.value as? String, "")
        XCTAssertEqual(locationField.value as? String, "")
        XCTAssertEqual(distanceField.value as? String, "")
        XCTAssertEqual(timeField.value as? String, "")
        XCTAssert(elementsQuery.staticTexts["Average"].exists)
        XCTAssertEqual(descriptionField.value as? String, "")
    }
    
    func testCreateButtonShowsValidation() throws {
        app.launch()
        signIn(app: app)

        let tabBar = app.tabBars["Tab Bar"]
        tabBar.buttons["New Log"].tap()
        
        let scrollViewsQuery = app.scrollViews
        let elementsQuery = scrollViewsQuery.otherElements
        let createButton = elementsQuery.buttons["Create"]
        
        let nameValidationText = elementsQuery.staticTexts["Name Validation Text"]
        let distanceValidationText = elementsQuery.staticTexts["Distance Validation Text"]
        let timeValidationText = elementsQuery.staticTexts["Time Validation Text"]
        
        XCTAssertFalse(nameValidationText.exists)
        XCTAssertFalse(distanceValidationText.exists)
        XCTAssertFalse(timeValidationText.exists)
        
        createButton.tap()
        
        XCTAssert(nameValidationText.exists)
        XCTAssert(distanceValidationText.exists)
        XCTAssert(timeValidationText.exists)
    }
}
