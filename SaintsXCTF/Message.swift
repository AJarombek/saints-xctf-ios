//
//  Message.swift
//  SaintsXCTF
//
//  Created by Andy Jarombek on 6/11/17.
//  Copyright © 2017 Andy Jarombek. All rights reserved.
//

import Foundation
import ObjectMapper

class Message: Mappable {
    
    var message_id: Int!
    var username: String!
    var first: String!
    var last: String!
    var group_name: String!
    
    required init?(map: Map) {
        // pass
    }
    
    func mapping(map: Map) {
        message_id <- map["message_id"]
        username <- map["username"]
        first <- map["first"]
        last <- map["last"]
        group_name <- map["group_name"]
    }
}
