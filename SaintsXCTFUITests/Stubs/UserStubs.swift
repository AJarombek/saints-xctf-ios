//
//  UserStubs.swift
//  SaintsXCTFUITests
//
//  Created by Andrew Jarombek on 6/5/21.
//  Copyright © 2021 Andy Jarombek. All rights reserved.
//

import Foundation

struct UserStubs {
    let andy = """
        {
           "self":"/v2/users/andy",
           "user":{
              "activation_code":"abc123",
              "class_year":2017,
              "deleted":false,
              "description":"I sometimes like to run...",
              "email":"andrew@jarombek.com",
              "favorite_event":"Shakeout",
              "first":"Andy",
              "last":"Jarombek",
              "last_signin":"2021-05-30 18:42:42",
              "location":"New York, NY",
              "member_since":"2016-12-23",
              "password":"$2b$12$KDaX8hy3PdsaUVf1TeXw/rJJ4YaeXYdBi.Bx9k8v3dFeHQ8a",
              "profilepic_name":"snow-race-profile-picture.jpg",
              "salt":"RjJH6PIndLmr8S5sjgGUj8",
              "subscribed":null,
              "username":"andy",
              "week_start":"monday"
           }
        }
    """
    
    let andySundayWeekStart = """
        {
           "self":"/v2/users/andy",
           "user":{
              "activation_code":"abc123",
              "class_year":2017,
              "deleted":false,
              "description":"I sometimes like to run...",
              "email":"andrew@jarombek.com",
              "favorite_event":"Shakeout",
              "first":"Andy",
              "last":"Jarombek",
              "last_signin":"2021-05-30 18:42:42",
              "location":"New York, NY",
              "member_since":"2016-12-23",
              "password":"$2b$12$KDaX8hy3PdsaUVf1TeXw/rJJ4YaeXYdBi.Bx9k8v3dFeHQ8a",
              "profilepic_name":"snow-race-profile-picture.jpg",
              "salt":"RjJH6PIndLmr8S5sjgGUj8",
              "subscribed":null,
              "username":"andy",
              "week_start":"sunday"
           }
        }
    """
    
    var andyData: Data {
        get {
            return andy.data(using: .utf8)!
        }
    }
    
    var andySundayWeekStartData: Data {
        get {
            return andySundayWeekStart.data(using: .utf8)!
        }
    }
}
