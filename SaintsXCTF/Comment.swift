//
//  Comment.swift
//  SaintsXCTF
//
//  Created by Andy Jarombek on 3/31/17.
//  Copyright © 2017 Andy Jarombek. All rights reserved.
//

import Foundation
import ObjectMapper

class Comment: Mappable {
    
    var comment_id: Int!
    var log_id: Int!
    var username: String!
    var first: String!
    var last: String!
    
    required init?(map: Map) {
        // pass
    }
    
    func mapping(map: Map) {
        comment_id <- map["comment_id"]
        log_id <- map["log_id"]
        username <- map["username"]
        first <- map["first"]
        last <- map["last"]
    }
}
