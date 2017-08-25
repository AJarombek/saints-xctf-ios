//
//  GroupInfo.swift
//  SaintsXCTF
//
//  Created by Andy Jarombek on 3/31/17.
//  Copyright © 2017 Andy Jarombek. All rights reserved.
//

import Foundation
import ObjectMapper

class GroupInfo: NSObject, Mappable, NSCoding {
    
    var group_name: String!
    var group_title: String!
    var status: String?
    var user: String?
    var newest_log: String?
    var newest_message: String?
    
    override init() {}
    
    // Mappable Initializer
    required init?(map: Map) {}
    
    // NSCoder Initializer
    required init?(coder aDecoder: NSCoder) {
        group_name = aDecoder.decodeObject(forKey: "group_name") as! String!
        group_title = aDecoder.decodeObject(forKey: "group_title") as! String!
        status = aDecoder.decodeObject(forKey: "status") as! String!
        user = aDecoder.decodeObject(forKey: "user") as! String!
        newest_log = aDecoder.decodeObject(forKey: "newest_log") as! String?
        newest_message = aDecoder.decodeObject(forKey: "newest_message") as! String?
    }
    
    // This class uses the CustomStringConvertible protocol.
    // The description will be printed whenever we try to print a GroupInfo object
    override var description: String {
        return "GroupInfo: (\(group_name!), \(group_title!))"
    }
    
    func encode(with aCoder: NSCoder) {
        aCoder.encode(group_name, forKey: "group_name")
        aCoder.encode(group_title, forKey: "group_title")
        aCoder.encode(status, forKey: "status")
        aCoder.encode(user, forKey: "user")
        aCoder.encode(newest_log, forKey: "newest_log")
        aCoder.encode(newest_message, forKey: "newest_message")
    }
    
    func mapping(map: Map) {
        group_name <- map["group_name"]
        group_title <- map["group_title"]
        status <- map["status"]
        user <- map["user"]
        newest_log <- map["newest_log"]
        newest_message <- map["newest_message"]
    }
}
