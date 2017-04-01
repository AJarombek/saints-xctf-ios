//
//  GroupInfo.swift
//  SaintsXCTF
//
//  Created by Andy Jarombek on 3/31/17.
//  Copyright © 2017 Andy Jarombek. All rights reserved.
//

import Foundation
import ObjectMapper

class GroupInfo: Mappable {
    
    var group_name: String!
    var group_title: String!
    var newest_log: String?
    var newest_message: String?
    
    required init?(map: Map) {
        // pass
    }
    
    func mapping(map: Map) {
        group_name <- map["group_name"]
        group_title <- map["group_title"]
        newest_log <- map["newest_log"]
        newest_message <- map["newest_message"]
    }
}
