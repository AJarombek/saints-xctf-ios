//
//  Log.swift
//  SaintsXCTF
//
//  Created by Andy Jarombek on 3/31/17.
//  Copyright © 2017 Andy Jarombek. All rights reserved.
//

import Foundation
import ObjectMapper

/**
 Class that represents an exercise log in the application.  Logs are stored in the MySQL database.
 - Important:
 ## Implements the following protocols:
 - Mappable: used to map an object to JSON
 - CustomStringConvertible: allows class instances to create a string representation of themself
 */
class Log: Mappable, CustomStringConvertible {
    
    var log_id: String!
    var username: String!
    var first: String!
    var last: String!
    var name: String!
    var location: String?
    var date: String!
    var type: String?
    var distance: String?
    var miles: String?
    var metric: String!
    var time: String?
    var pace: String?
    var feel: String!
    var log_description: String?
    var time_created: String?
    var comments: [Comment]!
    
    /**
     Default initializer for a Log object
     */
    init() {
        log_id = ""
    }
    
    /**
     Required initializer for the Mappable protocol
     - parameters:
     - map: JSON data is stored within this map
     */
    required init?(map: Map) {}
    
    // This class uses the CustomStringConvertible protocol.
    // The description will be printed whenever we try to print a User object
    var description: String {
        let logdistance = distance ?? "0.0"
        let logtime = time ?? "0:00"
        return "Log: (\(username!), \(name!), \(logdistance) - \(logtime))"
    }
    
    /**
     Required function for the Mappable protocol.  Defines how each member maps to and from JSON.
     - parameters:
     - map: JSON data is stored within this map
     */
    func mapping(map: Map) {
        log_id <- map["log_id"]
        username <- map["username"]
        first <- map["first"]
        last <- map["last"]
        name <- map["name"]
        location <- map["location"]
        date <- map["date"]
        type <- map["type"]
        distance <- map["distance"]
        miles <- map["miles"]
        metric <- map["metric"]
        time <- map["time"]
        pace <- map["pace"]
        feel <- map["feel"]
        log_description <- map["description"]
        time_created <- map["time_created"]
        comments <- map["comments"]
    }
}
