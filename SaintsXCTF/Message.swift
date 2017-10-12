//
//  Message.swift
//  SaintsXCTF
//
//  Created by Andy Jarombek on 6/11/17.
//  Copyright © 2017 Andy Jarombek. All rights reserved.
//

import Foundation
import ObjectMapper

class Message: Mappable, CustomStringConvertible {
    
    var message_id: String!
    var username: String!
    var first: String!
    var last: String!
    var group_name: String!
    var time: String!
    var content: String!
    
    init() {
        message_id = ""
    }
    
    required init?(map: Map) {
        // pass
    }
    
    // This class uses the CustomStringConvertible protocol.
    // The description will be printed whenever we try to print a Comment object
    var description: String {
        return "Message: (\(username!), \(content!))"
    }
    
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
