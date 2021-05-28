//
//  LeaderboardItem.swift
//  SaintsXCTF
//
//  Created by Andy Jarombek on 3/31/17.
//  Copyright © 2017 Andy Jarombek. All rights reserved.
//

import Foundation
import ObjectMapper

/**
 Class that represents a leaderboard item in the application.  Leaderboard items are stored across
 multiple tables in the MySQL database.
 - Important:
 ## Implements the following protocols:
 - Mappable: used to map an object to JSON
 */
class LeaderboardItem: Mappable {
    
    var username: String!
    var first: String!
    var last: String!
    var miles: Double!
    var miles_run: Double!
    var miles_biked: Double!
    var miles_swam: Double!
    var miles_other: Double!
    
    /**
     Required initializer for the Mappable protocol
     - parameters:
     - map: JSON data is stored within this map
     */
    required init?(map: Map) {}
    
    /**
     Required function for the Mappable protocol.  Defines how each member maps to and from JSON.
     - parameters:
     - map: JSON data is stored within this map
     */
    func mapping(map: Map) {
        username <- map["username"]
        first <- map["first"]
        last <- map["last"]
        miles <- map["miles"]
        miles_run <- map["miles_run"]
        miles_biked <- map["miles_biked"]
        miles_swam <- map["miles_swam"]
        miles_other <- map["miles_other"]
    }
}
