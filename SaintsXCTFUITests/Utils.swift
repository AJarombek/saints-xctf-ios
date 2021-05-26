//
//  Utils.swift
//  SaintsXCTFUITests
//
//  Created by Andrew Jarombek on 5/23/21.
//  Copyright © 2021 Andy Jarombek. All rights reserved.
//

import Foundation
import XCTest

func signIn(app: XCUIApplication) {
    let usernameTextField = app.textFields["Username"]
    let passwordSecureTextField = app.secureTextFields["Password"]
    
    sleep(5)
    let signedOut = usernameTextField.exists
    
    if signedOut {
        usernameTextField.tap()
        usernameTextField.typeText("SaintsIOS")
        
        passwordSecureTextField.tap()
        passwordSecureTextField.typeText("SaintsIOS")
        
        app.staticTexts["Log In"].tap()
        let homeTab = app.tabBars["Tab Bar"].buttons["Home"]
        
        XCTAssert(homeTab.waitForExistence(timeout: 10))
    }
}
