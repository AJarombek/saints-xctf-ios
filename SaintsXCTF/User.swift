//
//  User.swift
//  SaintsXCTF
//
//  Created by Andy Jarombek on 3/30/17.
//  Copyright © 2017 Andy Jarombek. All rights reserved.
//

import Foundation
import ObjectMapper

class User: Mappable {
    
    var username: String!
    var first: String!
    var last: String!
    var email: String?
    var salt: String?
    var password: String?
    var profilepic: String?
    var profilepic_name: String?
    var description: String?
    var activation_code: String?
    var member_since: Date!
    var class_year: Int?
    var location: String?
    var favorite_event: String?
    var forgot_password: [String]!
    var groups: [GroupInfo]!
    var statistics: [String:Double]!
    var last_signin: String?
    
    required init?(map: Map) {
        // pass
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
        description <- map["description"]
        activation_code <- map["activation_code"]
        member_since <- map["member_since"]
        class_year <- map["class_year"]
        location <- map["location"]
        favorite_event <- map["favorite_event"]
        forgot_password <- map["forgot_password"]
        groups <- map["groups"]
        statistics <- map["statistics"]
        last_signin <- map["last_signin"]
    }
}
