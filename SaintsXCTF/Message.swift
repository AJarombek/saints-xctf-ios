//
//  Message.swift
//  SaintsXCTF
//
//  Created by Andy Jarombek on 6/11/17.
//  Copyright © 2017 Andy Jarombek. All rights reserved.
//

import Foundation
import ObjectMapper

/**
 Class that represents a group message in the application.  Messages are stored in the MySQL database.
 - Important:
 ## Implements the following protocols:
 - Mappable: used to map an object to JSON
 - CustomStringConvertible: allows class instances to create a string representation of themself
 */
class Message: Mappable, CustomStringConvertible {
    
    var message_id: String!
    var username: String!
    var first: String!
    var last: String!
    var group_name: String!
    var time: String!
    var content: String!
    
    /**
     Default initializer for a Message object
     */
    init() {
        message_id = ""
    }
    
    /**
     Required initializer for the Mappable protocol
     - parameters:
     - map: JSON data is stored within this map
     */
    required init?(map: Map) {}
    
    // This class uses the CustomStringConvertible protocol.
    // The description will be printed whenever we try to print a Comment object
    var description: String {
        return "Message: (\(username!), \(content!))"
    }
    
    /**
     Required function for the Mappable protocol.  Defines how each member maps to and from JSON.
     - parameters:
     - map: JSON data is stored within this map
     */
    func mapping(map: Map) {
        message_id <- map["message_id"]
        username <- map["username"]
        first <- map["first"]
        last <- map["last"]
        group_name <- map["group_name"]
        time <- map["time"]
        content <- map["content"]
    }
}
