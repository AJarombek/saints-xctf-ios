//
//  Notification.swift
//  SaintsXCTF
//
//  Created by Andy Jarombek on 6/11/17.
//  Copyright © 2017 Andy Jarombek. All rights reserved.
//

import Foundation
import ObjectMapper

class Notification: Mappable {
    
    var notification_id: Int!
    var username: String!
    var time: String!
    var link: String!
    var description: String!
    
    required init?(map: Map) {
        // pass
    }
    
    func mapping(map: Map) {
        notification_id <- map["notification_id"]
        username <- map["username"]
        time <- map["time"]
        link <- map["link"]
        description <- map["description"]
    }
}
