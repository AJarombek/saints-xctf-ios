//
//  GroupMember.swift
//  SaintsXCTF
//
//  Created by Andy Jarombek on 3/31/17.
//  Copyright © 2017 Andy Jarombek. All rights reserved.
//

import Foundation
import ObjectMapper

class GroupMember: Mappable {
    
    var username: String!
    var first: String!
    var last: String!
    var member_since: String!
    
    required init?(map: Map) {
        // pass
    }
    
    func mapping(map: Map) {
        username <- map["username"]
        first <- map["first"]
        last <- map["last"]
        member_since <- map["member_since"]
    }
}
