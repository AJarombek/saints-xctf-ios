//
//  Comment.swift
//  SaintsXCTF
//
//  Created by Andy Jarombek on 3/31/17.
//  Copyright © 2017 Andy Jarombek. All rights reserved.
//

import Foundation
import ObjectMapper

class Comment: Mappable, CustomStringConvertible {
    
    var comment_id: String!
    var log_id: String!
    var username: String!
    var first: String!
    var last: String!
    var time: String!
    var content: String!
    
    required init?(map: Map) {
        // pass
    }
    
    // This class uses the CustomStringConvertible protocol.
    // The description will be printed whenever we try to print a Comment object
    var description: String {
        return "Comment: (\(username!), \(time!), \(content!))"
    }
    
    func mapping(map: Map) {
        comment_id <- map["comment_id"]
        log_id <- map["log_id"]
        username <- map["username"]
        first <- map["first"]
        last <- map["last"]
        time <- map["time"]
        content <- map["content"]
    }
}
