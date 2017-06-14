//
//  APIClient.swift
//  SaintsXCTF
//
//  Created by Andy Jarombek on 3/28/17.
//  Copyright © 2017 Andy Jarombek. All rights reserved.
//

import Foundation
import ObjectMapper

class APIClient {
    
    private static let logTag = "APIClient:"
    
    // MARK: - GET Requests
    
    // Handle GET Requests for a User
    public static func userGetRequest(withUsername username: String) -> User? {
        
        // Create the URL
        let userGetEndpoint = "https://www.saintsxctf.com/api/api.php/users/\(username)"
        guard let url = URL(string: userGetEndpoint) else {
            print("\(logTag) Error, Cannot create URL")
            return nil
        }
        
        var userObj: User?
        
        // Generate the request with a completion function to parse JSON
        APIRequest.get(withURL: url) {
            (json) -> Void in
        
            let user: User? = Mapper<User>().map(JSONString: json)
            print(user ?? "\(logTag) User Conversion Failed.")
            
            userObj = user
        }
        
        return userObj
    }
    
    // Handle GET Requests for all Users
    public static func usersGetRequest() -> [User]? {
        
        let usersGetEndpoint = "https://www.saintsxctf.com/api/api.php/users"
        guard let url = URL(string: usersGetEndpoint) else {
            print("\(logTag) Error, Cannot create URL")
            return nil
        }
        
        var userArray: Array<User>?
        
        APIRequest.get(withURL: url) {
            (json) -> Void in
            
            let user: Array<User>? = Mapper<User>().mapArray(JSONString: json)
            print(user ?? "\(logTag) User Conversion Failed.")
            
            userArray = user
        }
        
        return userArray
    }
    
    // MARK: - POST Requests
    
    // Handle POST Request for a User
    public static func userPostRequest(withUser user: User) -> User? {
        
        let usersPostEndpoint = "https://www.saintsxctf.com/api/api.php/users"
        guard let url = URL(string: usersPostEndpoint) else {
            print("\(logTag) Error, Cannot create URL")
            return nil
        }
        
        var userObj: User?
        
        APIRequest.post(withURL: url, andObject: user) {
            (json) -> Void in
            
            let user = Mapper<User>().map(JSONString: json)
            print(user ?? "\(logTag) User Conversion Failed")
            
            userObj = user
        }
        
        return userObj
    }
    
    // MARK: - PUT Requests
    
    // Handle PUT Request for a User
    public static func userPutRequest(withUsername username: String, andUser user: User) -> User? {
        
        let usersPutEndpoint = "https://www.saintsxctf.com/api/api.php/user/\(username)"
        guard let url = URL(string: usersPutEndpoint) else {
            print("\(logTag) Error, Cannot create URL")
            return nil
        }
        
        var userObj: User?
        
        APIRequest.put(withURL: url, andObject: user) {
            (json) -> Void in
            
            let user = Mapper<User>().map(JSONString: json)
            print(user ?? "\(logTag) User Conversion Failed")
            
            userObj = user
        }
        
        return userObj
    }
    
    // MARK: - DELETE Requests
    
    // Handle DELETE Request for a User
    public static func userDeleteRequest(withUsername username: String) -> Bool {
        
        let usersDeleteEndpoint = "https://www.saintsxctf.com/api/api.php/user/\(username)"
        guard let url = URL(string: usersDeleteEndpoint) else {
            print("\(logTag) Error, Cannot create URL")
            return false
        }
        
        var deleteSuccess: Bool!
        
        APIRequest.delete(withURL: url) {
            (success) -> Void in
            
            print(success)
            
            deleteSuccess = success
        }
        
        return deleteSuccess
    }
}
