//
//  Group.swift
//  SaintsXCTF
//
//  Created by Andy Jarombek on 3/31/17.
//  Copyright © 2017 Andy Jarombek. All rights reserved.
//

import Foundation
import ObjectMapper

class Group: Mappable, CustomStringConvertible {
    
    var group_name: String!
    var group_title: String!
    var grouppic: String?
    var grouppic_name: String?
    var group_description: String?
    var week_start: String?
    var members: [GroupMember]!
    var statistics: [String:String]!
    var leaderboards: [String:[LeaderboardItem]]!
    
    required init?(map: Map) {
        // pass
    }
    
    // This class uses the CustomStringConvertible protocol.
    // The description will be printed whenever we try to print a Comment object
    var description: String {
        return "Group: (\(group_name!), \(group_title!))"
    }
    
    func mapping(map: Map) {
        group_name <- map["group_name"]
        group_title <- map["group_title"]
        grouppic <- map["grouppic"]
        grouppic_name <- map["grouppic_name"]
        group_description <- map["description"]
        week_start <- map["week_start"]
        members <- map["members"]
        statistics <- map["statistics"]
        leaderboards <- map["leaderboards"]
    }
}
