//
//  User.swift
//  SaintsXCTF
//
//  Created by Andy Jarombek on 3/30/17.
//  Copyright © 2017 Andy Jarombek. All rights reserved.
//

import Foundation
import ObjectMapper

class User: Mappable, CustomStringConvertible {
    
    var username: String!
    var first: String!
    var last: String!
    var email: String?
    var salt: String?
    var password: String?
    var profilepic: String?
    var profilepic_name: String?
    var user_description: String?
    var activation_code: String?
    var member_since: Date!
    var class_year: Int?
    var location: String?
    var favorite_event: String?
    var forgot_password: [String]!
    var flair: [String]!
    var notifications: [Notification]!
    var groups: [GroupInfo]!
    var statistics: [String:Double]!
    var last_signin: String?
    var week_start: String?
    
    required init?(map: Map) {
        // pass
    }
    
    // This class uses the CustomStringConvertible protocol.
    // The description will be printed whenever we try to print a User object
    var description: String {
        return "User: (\(username!), \(first!), \(last!))"
    }
    
    func mapping(map: Map) {
        username <- map["username"]
        first <- map["first"]
        last <- map["last"]
        email <- map["email"]
        salt <- map["salt"]
        password <- map["password"]
        profilepic <- map["profilepic"]
        profilepic_name <- map["profilepic_name"]
        user_description <- map["description"]
        activation_code <- map["activation_code"]
        member_since <- map["member_since"]
        class_year <- map["class_year"]
        location <- map["location"]
        favorite_event <- map["favorite_event"]
        forgot_password <- map["forgot_password"]
        flair <- map["flair"]
        notifications <- map["notifications"]
        groups <- map["groups"]
        statistics <- map["statistics"]
        last_signin <- map["last_signin"]
        week_start <- map["week_start"]
    }
}
