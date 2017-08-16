//
//  Notification.swift
//  SaintsXCTF
//
//  Created by Andy Jarombek on 6/11/17.
//  Copyright © 2017 Andy Jarombek. All rights reserved.
//

import Foundation
import ObjectMapper

class Notification: NSObject, Mappable, NSCoding {
    
    var notification_id: String!
    var username: String!
    var time: String!
    var link: String!
    var notification_description: String!
    
    // Mappable Initializer
    required init?(map: Map) {}
    
    // NSCoder Initializer
    required init?(coder aDecoder: NSCoder) {
        notification_id = aDecoder.decodeObject(forKey: "notification_id") as! String!
        username = aDecoder.decodeObject(forKey: "username") as! String!
        time = aDecoder.decodeObject(forKey: "time") as! String!
        link = aDecoder.decodeObject(forKey: "link") as! String!
        notification_description = aDecoder.decodeObject(
            forKey: "notification_description") as! String!
    }
    
    // This class uses the CustomStringConvertible protocol.
    // The description will be printed whenever we try to print a Notification object
    override var description: String {
        return "Notification: (\(username!), \(time!), \(link!), \(notification_description!))"
    }
    
    func encode(with aCoder: NSCoder) {
        aCoder.encode(notification_id, forKey: "notification_id")
        aCoder.encode(username, forKey: "username")
        aCoder.encode(time, forKey: "time")
        aCoder.encode(link, forKey: "link")
        aCoder.encode(notification_description, forKey: "notification_description")
    }
    
    func mapping(map: Map) {
        notification_id <- map["notification_id"]
        username <- map["username"]
        time <- map["time"]
        link <- map["link"]
        notification_description <- map["description"]
    }
}
