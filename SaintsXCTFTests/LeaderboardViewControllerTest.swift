//
//  LeaderboardViewController.swift
//  SaintsXCTFTests
//
//  Created by Andy Jarombek on 9/21/19.
//  Copyright © 2019 Andy Jarombek. All rights reserved.
//

import XCTest
@testable import SaintsXCTF

class LeaderboardViewControllerTest: XCTestCase {
    
    var sut: LeaderboardViewController!

    override func setUp() {
        super.setUp()
        sut = UIStoryboard(name: "Main", bundle: nil)
            .instantiateInitialViewController() as? LeaderboardViewController
    }

    override func tearDown() {
        super.tearDown()
    }

    func testExample() {}
    
    func testAnother() {}
}
