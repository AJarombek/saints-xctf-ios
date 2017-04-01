//
//  Log.swift
//  SaintsXCTF
//
//  Created by Andy Jarombek on 3/31/17.
//  Copyright © 2017 Andy Jarombek. All rights reserved.
//

import Foundation
import ObjectMapper

class Log: Mappable {
    
    var log_id: Int!
    var username: String!
    var first: String!
    var last: String!
    var name: String!
    var location: String?
    var date: Date!
    var type: String?
    var distance: Double?
    var metric: String!
    var time: String?
    var pace: String?
    var feel: Int!
    var description: String?
    var time_created: Date?
    var comments: [Comment]!
    
    required init?(map: Map) {
        // pass
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
        metric <- map["metric"]
        time <- map["time"]
        pace <- map["pace"]
        feel <- map["feel"]
        description <- map["description"]
        time_created <- map["time_created"]
        comments <- map["comments"]
    }
}
