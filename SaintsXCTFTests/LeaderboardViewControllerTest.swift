//
//  LeaderboardViewController.swift
//  SaintsXCTFTests
//
//  Created by Andy Jarombek on 9/21/19.
//  Copyright © 2019 Andy Jarombek. All rights reserved.
//

import XCTest
@testable import SaintsXCTF

/**
 Unit tests for the LeaderboardViewController.
 - Important:
 ## Extends the following class:
 - XCTestCase: class used for defining test cases
 */
class LeaderboardViewControllerTest: XCTestCase {
    
    var sut: LeaderboardViewController!

    /**
     Setup code called before unit tests execute.
     */
    override func setUp() {
        super.setUp()
        sut = UIStoryboard(name: "Main", bundle: nil)
            .instantiateViewController(withIdentifier: "leaderboardViewController") as? LeaderboardViewController
    }

    /**
     Teardown code called after unit tests execute.
     */
    override func tearDown() {
        super.tearDown()
        sut = nil
    }

    /**
     Unit test for sortLeaderboardByMileage() when the input array is empty.
     */
    func testSortLeaderboardByMileageEmpty() {
        let leaderArray: [[String]] = [[]]
        let resultArray = sut.sortLeaderboardByMileage(leaderArray: leaderArray)
        XCTAssertEqual(resultArray, [[]])
    }
    
    /**
     Unit test for sortLeaderboardByMileage() when the input array is populated with
     athletes and distances exercised.
     */
    func testSortLeaderboardByMileage() {
        let leaderArray: [[String]] = [
            ["Andy Jarombek", "12.31"],
            ["Joseph Smith", "50.01"],
            ["Ben Fishbein", "43.2"],
            ["Thomas Caulfield", "50"]
        ]
        
        let expectedResult: [[String]] = [
            ["Joseph Smith", "50.01"],
            ["Thomas Caulfield", "50"],
            ["Ben Fishbein", "43.2"],
            ["Andy Jarombek", "12.31"]
        ]
        
        let resultArray = sut.sortLeaderboardByMileage(leaderArray: leaderArray)
        XCTAssertEqual(resultArray, expectedResult)
    }
    
    /**
     Unit test for buildLeaderboardDataStructureEmpty() when the input leaderboard
     array is empty.
     */
    func testBuildLeaderboardDataStructureEmpty() {
        let inputLeaderboardItems: [LeaderboardItem] = []
        let expectedResult: [[String]] = []
        
        let result: [[String]] =
            sut.buildLeaderboardDataStructure(leaderboardItems: inputLeaderboardItems)
        
        XCTAssertEqual(result, expectedResult)
    }
    
    /**
     Unit test for buildLeaderboardDataStructureEmpty() when the input array is contains
     a single athletes statistics.
     */
    func testBuildLeaderboardDataStructure() {
        let inputLeaderboardItems: [LeaderboardItem] = [
            LeaderboardItem(JSON: [
                "username": "andy",
                "first": "Andy",
                "last": "Jarombek",
                "miles": "12.31",
                "milesrun": "12.31",
                "milesbiked": "0",
                "milesswam": "0",
                "milesother": "0"
            ])!
        ]
        let expectedResult: [[String]] = [
            ["Andy Jarombek", "12.31"]
        ]
        
        let result: [[String]] =
            sut.buildLeaderboardDataStructure(leaderboardItems: inputLeaderboardItems)
        
        XCTAssertEqual(result, expectedResult)
    }
}
