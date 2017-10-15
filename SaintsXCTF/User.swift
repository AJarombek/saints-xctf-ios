//
//  User.swift
//  SaintsXCTF
//
//  Created by Andy Jarombek on 3/30/17.
//  Copyright © 2017 Andy Jarombek. All rights reserved.
//

import Foundation
import ObjectMapper

class User: NSObject, Mappable, NSCoding {
    
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
    var class_year: String?
    var location: String?
    var favorite_event: String?
    var forgot_password: [String]!
    var flair: [String]!
    var notifications: [Notification]!
    var groups: [GroupInfo]!
    var statistics: [String:Double]!
    var last_signin: String?
    var week_start: String?
    var give_flair: String?
    
    override init() {
        username = ""
    }
    
    // NSCoder Initializer
    // A required initializer means that all subclasses must implement the initializer
    required init?(coder aDecoder: NSCoder) {
        username = aDecoder.decodeObject(forKey: "username") as! String!
        first = aDecoder.decodeObject(forKey: "first") as! String!
        last = aDecoder.decodeObject(forKey: "last") as! String!
        email = aDecoder.decodeObject(forKey: "email") as! String?
        salt = aDecoder.decodeObject(forKey: "salt") as! String?
        password = aDecoder.decodeObject(forKey: "password") as! String?
        profilepic = aDecoder.decodeObject(forKey: "profilepic") as! String?
        profilepic_name = aDecoder.decodeObject(forKey: "profilepic_name") as! String?
        user_description = aDecoder.decodeObject(forKey: "description") as! String?
        activation_code = aDecoder.decodeObject(forKey: "activation_code") as! String?
        member_since = aDecoder.decodeObject(forKey: "member_since") as! Date!
        class_year = aDecoder.decodeObject(forKey: "class_year") as! String?
        location = aDecoder.decodeObject(forKey: "location") as! String?
        favorite_event = aDecoder.decodeObject(forKey: "favorite_event") as! String?
        forgot_password = aDecoder.decodeObject(forKey: "forgot_password") as! [String]!
        flair = aDecoder.decodeObject(forKey: "flair") as! [String]!
        notifications = aDecoder.decodeObject(forKey: "notifications") as! [Notification]!
        groups = aDecoder.decodeObject(forKey: "groups") as! [GroupInfo]!
        statistics = aDecoder.decodeObject(forKey: "statistics") as! [String:Double]!
        last_signin = aDecoder.decodeObject(forKey: "last_signin") as! String?
        week_start = aDecoder.decodeObject(forKey: "week_start") as! String?
        give_flair = aDecoder.decodeObject(forKey: "give_flair") as! String?
        
        super.init()
    }
    
    // Mappable Initializer
    required init?(map: Map) {}
    
    // This class uses the CustomStringConvertible protocol.
    // The description will be printed whenever we try to print a User object
    override var description: String {
        return "User: (\(username!), \(first ?? ""), \(last ?? ""))"
    }
    
    func encode(with aCoder: NSCoder) {
        aCoder.encode(username, forKey: "username")
        aCoder.encode(first, forKey: "first")
        aCoder.encode(last, forKey: "last")
        aCoder.encode(email, forKey: "email")
        aCoder.encode(salt, forKey: "salt")
        aCoder.encode(password, forKey: "password")
        aCoder.encode(profilepic, forKey: "profilepic")
        aCoder.encode(profilepic_name, forKey: "profilepic_name")
        aCoder.encode(user_description, forKey: "description")
        aCoder.encode(activation_code, forKey: "activation_code")
        aCoder.encode(member_since, forKey: "member_since")
        aCoder.encode(class_year, forKey: "class_year")
        aCoder.encode(location, forKey: "location")
        aCoder.encode(favorite_event, forKey: "favorite_event")
        aCoder.encode(forgot_password, forKey: "forgot_password")
        aCoder.encode(flair, forKey: "flair")
        aCoder.encode(notifications, forKey: "notifications")
        aCoder.encode(groups, forKey: "groups")
        aCoder.encode(statistics, forKey: "statistics")
        aCoder.encode(last_signin, forKey: "last_signin")
        aCoder.encode(week_start, forKey: "week_start")
        aCoder.encode(give_flair, forKey: "give_flair")
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
        give_flair <- map["give_flair"]
    }
}
