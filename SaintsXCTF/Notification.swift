//
//  Notification.swift
//  SaintsXCTF
//
//  Created by Andy Jarombek on 6/11/17.
//  Copyright © 2017 Andy Jarombek. All rights reserved.
//

import Foundation
import ObjectMapper

/**
 Class that represents a users notification in the application.  Notifications are stored in the MySQL database.
 */
class Notification: NSObject, Mappable, NSCoding {
    
    var notification_id: String!
    var username: String!
    var time: String!
    var link: String!
    var viewed: String!
    var notification_description: String!
    
    /**
     Default initializer for a Notification object
     */
    override init() {
        notification_id = ""
    }
    
    /**
     Required initializer for the Mappable protocol
     - parameters:
     - map: JSON data is stored within this map
     */
    required init?(map: Map) {}
    
    /**
     Required initializer for the NSCoder protocol.  NSCoding is used to persist app data on a device.
     The initializer declares how object fields are decoded.
     - parameters:
     - aDecoder: an NSCoder object which defines the NSCoding interface.
     Used in this method for decoding persisted data.
     */
    required init?(coder aDecoder: NSCoder) {
        notification_id = aDecoder.decodeObject(forKey: "notification_id") as? String
        username = aDecoder.decodeObject(forKey: "username") as? String
        time = aDecoder.decodeObject(forKey: "time") as? String
        link = aDecoder.decodeObject(forKey: "link") as? String
        viewed = aDecoder.decodeObject(forKey: "viewed") as? String
        notification_description = aDecoder.decodeObject(
            forKey: "notification_description") as? String
    }
    
    // This class uses the CustomStringConvertible protocol.
    // The description will be printed whenever we try to print a Notification object
    override var description: String {
        return "Notification: (\(username!), \(time!), \(link!), \(notification_description!))"
    }
    
    /**
     Required function for the NSCoder protocol.  Encodes the object fields so they can be persisted.
     - parameters:
     - aCoder: an NSCoder object which defines the NSCoding interface.
     Used in this method for encoding data to be persisted.
     */
    func encode(with aCoder: NSCoder) {
        aCoder.encode(notification_id, forKey: "notification_id")
        aCoder.encode(username, forKey: "username")
        aCoder.encode(time, forKey: "time")
        aCoder.encode(link, forKey: "link")
        aCoder.encode(viewed, forKey: "viewed")
        aCoder.encode(notification_description, forKey: "notification_description")
    }
    
    /**
     Required function for the Mappable protocol.  Defines how each member maps to and from JSON.
     - parameters:
     - map: JSON data is stored within this map
     */
    func mapping(map: Map) {
        notification_id <- map["notification_id"]
        username <- map["username"]
        time <- map["time"]
        link <- map["link"]
        viewed <- map["viewed"]
        notification_description <- map["description"]
    }
}
