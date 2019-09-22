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
    var milesrun: Double!
    var milesbiked: Double!
    var milesswam: Double!
    var milesother: Double!
    
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
        milesrun <- map["milesrun"]
        milesbiked <- map["milesbiked"]
        milesswam <- map["milesswam"]
        milesother <- map["milesother"]
    }
}
