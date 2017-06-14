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
    
    // Handle GET Requests for a Log
    public static func logGetRequest(withLogID logID: String) -> Log? {
        
        // Create the URL
        let logGetEndpoint = "https://www.saintsxctf.com/api/api.php/log/\(logID)"
        guard let url = URL(string: logGetEndpoint) else {
            print("\(logTag) Error, Cannot create URL")
            return nil
        }
        
        var logObj: Log?
        
        // Generate the request with a completion function to parse JSON
        APIRequest.get(withURL: url) {
            (json) -> Void in
            
            let log: Log? = Mapper<Log>().map(JSONString: json)
            print(log ?? "\(logTag) Log Conversion Failed.")
            
            logObj = log
        }
        
        return logObj
    }
    
    // Handle GET Requests for all Logs
    public static func logsGetRequest() -> [Log]? {
        
        let logsGetEndpoint = "https://www.saintsxctf.com/api/api.php/logs"
        guard let url = URL(string: logsGetEndpoint) else {
            print("\(logTag) Error, Cannot create URL")
            return nil
        }
        
        var logArray: Array<Log>?
        
        APIRequest.get(withURL: url) {
            (json) -> Void in
            
            let logs: Array<Log>? = Mapper<Log>().mapArray(JSONString: json)
            print(logs ?? "\(logTag) Logs Conversion Failed.")
            
            logArray = logs
        }
        
        return logArray
    }
    
    // Handle GET Requests for a Group
    public static func groupGetRequest(withGroupname groupname: String) -> Group? {
        
        // Create the URL
        let groupGetEndpoint = "https://www.saintsxctf.com/api/api.php/group/\(groupname)"
        guard let url = URL(string: groupGetEndpoint) else {
            print("\(logTag) Error, Cannot create URL")
            return nil
        }
        
        var groupObj: Group?
        
        // Generate the request with a completion function to parse JSON
        APIRequest.get(withURL: url) {
            (json) -> Void in
            
            let group: Group? = Mapper<Group>().map(JSONString: json)
            print(group ?? "\(logTag) Group Conversion Failed.")
            
            groupObj = group
        }
        
        return groupObj
    }
    
    // Handle GET Requests for all Groups
    public static func groupsGetRequest() -> [Group]? {
        
        let groupsGetEndpoint = "https://www.saintsxctf.com/api/api.php/groups"
        guard let url = URL(string: groupsGetEndpoint) else {
            print("\(logTag) Error, Cannot create URL")
            return nil
        }
        
        var groupArray: Array<Group>?
        
        APIRequest.get(withURL: url) {
            (json) -> Void in
            
            let groups: Array<Group>? = Mapper<Group>().mapArray(JSONString: json)
            print(groups ?? "\(logTag) Groups Conversion Failed.")
            
            groupArray = groups
        }
        
        return groupArray
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
    
    // Handle POST Request for a Log
    public static func logPostRequest(withLog log: Log) -> Log? {
        
        let logPostEndpoint = "https://www.saintsxctf.com/api/api.php/log"
        guard let url = URL(string: logPostEndpoint) else {
            print("\(logTag) Error, Cannot create URL")
            return nil
        }
        
        var logObj: Log?
        
        APIRequest.post(withURL: url, andObject: log) {
            (json) -> Void in
            
            let log = Mapper<Log>().map(JSONString: json)
            print(log ?? "\(logTag) Log Conversion Failed")
            
            logObj = log
        }
        
        return logObj
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
    
    // Handle PUT Request for a Log
    public static func logPutRequest(withLogID logID: String, andLog log: Log) -> Log? {
        
        let logPutEndpoint = "https://www.saintsxctf.com/api/api.php/log/\(logID)"
        guard let url = URL(string: logPutEndpoint) else {
            print("\(logTag) Error, Cannot create URL")
            return nil
        }
        
        var logObj: Log?
        
        APIRequest.put(withURL: url, andObject: log) {
            (json) -> Void in
            
            let log = Mapper<Log>().map(JSONString: json)
            print(log ?? "\(logTag) Log Conversion Failed")
            
            logObj = log
        }
        
        return logObj
    }
    
    // Handle PUT Request for a Group
    public static func groupPutRequest(withGroupname groupname: String, andGroup group: Group) -> Group? {
        
        let groupPutEndpoint = "https://www.saintsxctf.com/api/api.php/group/\(groupname)"
        guard let url = URL(string: groupPutEndpoint) else {
            print("\(logTag) Error, Cannot create URL")
            return nil
        }
        
        var groupObj: Group?
        
        APIRequest.put(withURL: url, andObject: group) {
            (json) -> Void in
            
            let group = Mapper<Group>().map(JSONString: json)
            print(group ?? "\(logTag) Group Conversion Failed")
            
            groupObj = group
        }
        
        return groupObj
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
    
    // Handle DELETE Request for a Log
    public static func logDeleteRequest(withLogID logID: String) -> Bool {
        
        let logDeleteEndpoint = "https://www.saintsxctf.com/api/api.php/log/\(logID)"
        guard let url = URL(string: logDeleteEndpoint) else {
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
