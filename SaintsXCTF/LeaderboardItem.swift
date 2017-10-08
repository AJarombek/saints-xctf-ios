//
//  LeaderboardItem.swift
//  SaintsXCTF
//
//  Created by Andy Jarombek on 3/31/17.
//  Copyright © 2017 Andy Jarombek. All rights reserved.
//

import Foundation
import ObjectMapper

class LeaderboardItem: Mappable {
    
    var username: String!
    var first: String!
    var last: String!
    var miles: String!
    var milesrun: String!
    var milesbiked: String!
    var milesswam: String!
    var milesother: String!
    
    required init?(map: Map) {
        // pass
    }
    
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
