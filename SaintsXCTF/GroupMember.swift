//
//  GroupMember.swift
//  SaintsXCTF
//
//  Created by Andy Jarombek on 3/31/17.
//  Copyright © 2017 Andy Jarombek. All rights reserved.
//

import Foundation
import ObjectMapper

/**
 Class that represents a group member in the application.  Group members are stored in the MySQL database.
 - Important:
 ## Implements the following protocols:
 - Mappable: used to map an object to JSON
 */
class GroupMember: Mappable {
    
    var username: String!
    var first: String!
    var last: String!
    var status: String!
    var user: String!
    var member_since: String!
    
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
        status <- map["status"]
        user <- map["user"]
        member_since <- map["member_since"]
    }
}
