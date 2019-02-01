//
//  GroupInfo.swift
//  SaintsXCTF
//
//  Created by Andy Jarombek on 3/31/17.
//  Copyright © 2017 Andy Jarombek. All rights reserved.
//

import Foundation
import ObjectMapper

/**
 Class that represents information about a group in the application.  Group information is stored in the MySQL database.
 */
class GroupInfo: NSObject, Mappable, NSCoding {
    
    var group_name: String!
    var group_title: String!
    var status: String?
    var user: String?
    var newest_log: String?
    var newest_message: String?
    
    /**
     Default initializer for a GroupInfo object
     */
    override init() {}
    
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
        group_name = aDecoder.decodeObject(forKey: "group_name") as? String
        group_title = aDecoder.decodeObject(forKey: "group_title") as? String
        status = aDecoder.decodeObject(forKey: "status") as? String
        user = aDecoder.decodeObject(forKey: "user") as? String
        newest_log = aDecoder.decodeObject(forKey: "newest_log") as! String?
        newest_message = aDecoder.decodeObject(forKey: "newest_message") as! String?
    }
    
    // This class uses the CustomStringConvertible protocol.
    // The description will be printed whenever we try to print a GroupInfo object
    override var description: String {
        return "GroupInfo: (\(group_name!), \(group_title!))"
    }
    
    /**
     Required function for the NSCoder protocol.  Encodes the object fields so they can be persisted.
     - parameters:
     - aCoder: an NSCoder object which defines the NSCoding interface.
     Used in this method for encoding data to be persisted.
     */
    func encode(with aCoder: NSCoder) {
        aCoder.encode(group_name, forKey: "group_name")
        aCoder.encode(group_title, forKey: "group_title")
        aCoder.encode(status, forKey: "status")
        aCoder.encode(user, forKey: "user")
        aCoder.encode(newest_log, forKey: "newest_log")
        aCoder.encode(newest_message, forKey: "newest_message")
    }
    
    /**
     Required function for the Mappable protocol.  Defines how each member maps to and from JSON.
     - parameters:
     - map: JSON data is stored within this map
     */
    func mapping(map: Map) {
        group_name <- map["group_name"]
        group_title <- map["group_title"]
        status <- map["status"]
        user <- map["user"]
        newest_log <- map["newest_log"]
        newest_message <- map["newest_message"]
    }
}
