//
//  SaintsXCTFUITests.swift
//  SaintsXCTFUITests
//
//  Created by Andrew Jarombek on 4/20/21.
//  Copyright © 2021 Andy Jarombek. All rights reserved.
//

import XCTest

class SaintsXCTFUITests: XCTestCase {

    override func setUpWithError() throws {
        continueAfterFailure = false
    }

    override func tearDownWithError() throws {}

    func testAbleToViewEula() throws {
        let app = XCUIApplication()
        app.launch()
        
        let usernameTextField = app.textFields["Username"]
        let passwordSecureTextField = app.secureTextFields["Password"]
        
        let signUpButton = app/*@START_MENU_TOKEN@*/.staticTexts["Sign Up"]/*[[".buttons[\"Sign Up\"].staticTexts[\"Sign Up\"]",".staticTexts[\"Sign Up\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/
        let logInButton = app/*@START_MENU_TOKEN@*/.staticTexts["Log In"]/*[[".buttons[\"Log In\"].staticTexts[\"Log In\"]",".staticTexts[\"Log In\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/
        
        let inRunningState = app.wait(for: XCUIApplication.State(rawValue: 4)!, timeout: 3)
        XCTAssert(inRunningState)
        
        XCTAssert(usernameTextField.waitForExistence(timeout: 5))
        
        XCTAssert(usernameTextField.exists)
        XCTAssert(passwordSecureTextField.exists)
        
        XCTAssert(signUpButton.exists)
        XCTAssert(logInButton.exists)
        
        signUpButton.tap()
        
        let firstNameTextField = app.textFields["First Name"]
        let lastNameTextField = app.textFields["Last Name"]
        let confirmPasswordSecureTextField = app.secureTextFields["Confirm Password"]
        let activationCodeTextField = app.textFields["Activation Code"]
        
        let submitButton = app.staticTexts["Submit"]
        let cancelButton = app/*@START_MENU_TOKEN@*/.staticTexts["Cancel"]/*[[".buttons[\"Cancel\"].staticTexts[\"Cancel\"]",".staticTexts[\"Cancel\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/
        
        XCTAssert(usernameTextField.exists)
        XCTAssert(firstNameTextField.exists)
        XCTAssert(lastNameTextField.exists)
        XCTAssert(passwordSecureTextField.exists)
        XCTAssert(confirmPasswordSecureTextField.exists)
        XCTAssert(activationCodeTextField.exists)
        
        XCTAssert(submitButton.exists)
        XCTAssert(cancelButton.exists)
        
        let eula = app.textViews.textViews.matching(identifier: "I have read and agree to the SaintsXCTF EULA").links["SaintsXCTF EULA"]
            
        XCTAssert(eula.exists)
        
        eula.tap()
        
        let eulaUrl = "https://www.termsfeed.com/eula/ef5f58cef41e72df54c0b73d8ee8be15"
        
        let safari = XCUIApplication(bundleIdentifier: "com.apple.mobilesafari")
        safari.buttons["URL"].tap()
        let browserUrl = safari.textFields["URL"].value as! String
        
        XCTAssert(browserUrl == eulaUrl)
        
        safari.buttons["Cancel"].tap()
        app.activate()
    }

    func testLaunchPerformance() throws {
        if #available(macOS 10.15, iOS 13.0, tvOS 13.0, *) {
            // This measures how long it takes to launch your application.
            measure(metrics: [XCTApplicationLaunchMetric()]) {
                XCUIApplication().launch()
            }
        }
    }
}
