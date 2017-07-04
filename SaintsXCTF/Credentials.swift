//
//  Credentials.swift
//  SaintsXCTF
//
//  Created by Andy Jarombek on 7/4/17.
//  Copyright © 2017 Andy Jarombek. All rights reserved.
//

import Foundation
import ObjectMapper

class Credentials: Mappable {
    
    var api_key: String!
    var privilege: String!
    var user: String!
    
    required init() {
        api_key = "saintsxctfandapp"
        privilege = "null"
        user = "user"
    }
    
    required init?(map: Map) {
        // pass
    }
    
    func mapping(map: Map) {
        api_key <- map["api_key"]
        privilege <- map["privilege"]
        user <- map["user"]
    }
}
