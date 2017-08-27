//
//  Log.swift
//  SaintsXCTF
//
//  Created by Andy Jarombek on 3/31/17.
//  Copyright © 2017 Andy Jarombek. All rights reserved.
//

import Foundation
import ObjectMapper

class Log: Mappable, CustomStringConvertible {
    
    var log_id: String!
    var username: String!
    var first: String!
    var last: String!
    var name: String!
    var location: String?
    var date: Date!
    var type: String?
    var distance: String?
    var miles: String?
    var metric: String!
    var time: String?
    var pace: String?
    var feel: String!
    var log_description: String?
    var time_created: Date?
    var comments: [Comment]!
    
    required init?(map: Map) {
        // pass
    }
    
    // This class uses the CustomStringConvertible protocol.
    // The description will be printed whenever we try to print a User object
    var description: String {
        let logdistance = distance ?? "0.0"
        let logtime = time ?? "0:00"
        return "Log: (\(username!), \(name!), \(logdistance) - \(logtime))"
    }
    
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
