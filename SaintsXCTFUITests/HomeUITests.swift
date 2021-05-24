//
//  HomeUITests.swift
//  SaintsXCTFUITests
//
//  Created by Andrew Jarombek on 5/23/21.
//  Copyright © 2021 Andy Jarombek. All rights reserved.
//

import XCTest

class HomeUITests: XCTestCase {

    override func setUpWithError() throws {
        continueAfterFailure = false
        XCUIApplication().launch()
    }

    override func tearDownWithError() throws {}

    func displaysLogs() throws {}

}
