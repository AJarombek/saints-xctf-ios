//
//  Group.swift
//  SaintsXCTF
//
//  Created by Andy Jarombek on 3/31/17.
//  Copyright © 2017 Andy Jarombek. All rights reserved.
//

import Foundation
import ObjectMapper

class Group: Mappable {
    
    var group_name: String!
    var group_title: String!
    var grouppic: String?
    var grouppic_name: String?
    var description: String?
    var members: [GroupMember]!
    var statistics: [String:Double]!
    var leaderboards: [String:[LeaderboardItem]]!
    
    required init?(map: Map) {
        // pass
    }
    
    func mapping(map: Map) {
        group_name <- map["group_name"]
        group_title <- map["group_title"]
        grouppic <- map["grouppic"]
        grouppic_name <- map["grouppic_name"]
        description <- map["description"]
        members <- map["members"]
        statistics <- map["statistics"]
        leaderboards <- map["leaderboards"]
    }
}
