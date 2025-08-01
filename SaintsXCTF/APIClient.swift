//
//  APIClient.swift
//  SaintsXCTF
//
//  Created by Andy Jarombek on 3/28/17.
//  Copyright © 2017 Andy Jarombek. All rights reserved.
//

import Foundation
import ObjectMapper
import os.log

/**
 Class with methods to hit API endpoints.  These API endpoints interact with the database for the application.
 */
class APIClient {
    
    private static let logTag = OSLog(subsystem: "SaintsXCTF.APIClient.APIClient", category: "APIClient")
    
    private static var apiBaseUrl: String {
        switch NetworkEnvironment().environment {
        case .localUITestStub:
            return "http://localhost:9080"
        case .local, .localEmail:
            return "http://localhost:5000"
        case .development:
            return "http://dev.api.saintsxctf.com"
        case .production:
            return "https://api.saintsxctf.com"
        }
    }
    
    // MARK: - GET Requests
    
    /**
     Handle GET Requests for a User
     - parameters:
         - username: the username of a user to retrieve
         - controller:  UI Controller that the API request originates from
         - completion:  Callback function which is invoked once the GET request is fulfilled
     */
    public static func userGetRequest(
        withUsername username: String,
        fromController controller: UIViewController?,
        completion: @escaping (User) -> Void
    ) {
        
        // Create the URL
        let userGetEndpoint = "\(apiBaseUrl)/v2/users/\(username)"
        guard let url = URL(string: userGetEndpoint) else {
            os_log("Error, Cannot create URL.", log: APIClient.logTag, type: .error)
            OperationQueue.main.addOperation {
                completion(User())
            }
            return
        }
        
        // Generate the request with a completion function to parse JSON
        APIRequest.get(withURL: url, fromController: controller) {
            (json) -> Void in
            
            do {
                if let jsonDict = try JSONSerialization.jsonObject(with: Data(json.utf8), options: []) as? [String: Any] {
                    let userJsonDict = jsonDict["user"] ?? [:]
                    
                    let userJson = try JSONSerialization.data(withJSONObject: userJsonDict, options: [])
                    let userJsonString = String(data: userJson, encoding: String.Encoding.utf8) ?? "{}"
                    
                    if let user: User = Mapper<User>().map(JSONString: userJsonString) {
                        os_log("%@", log: APIClient.logTag, type: .debug, user.toJSONString()!)
                        
                        OperationQueue.main.addOperation {
                            completion(user)
                        }
                    } else {
                        os_log("User Conversion Failed.", log: APIClient.logTag, type: .error)
                        
                        // If no user exists, return an empty user object
                        OperationQueue.main.addOperation {
                            completion(User())
                        }
                    }
                }
            } catch {
                os_log("API Response JSON Parse Failed.", log: APIClient.logTag, type: .error)
                OperationQueue.main.addOperation {
                    completion(User())
                }
            }
        }
    }
    
    /**
     Handle a GET request for all Users in the database
     - parameters:
        - controller: UI Controller that the API request originates from
        - completion:  Callback function which is invoked once the GET request is fulfilled
     */
    public static func usersGetRequest(fromController controller: UIViewController?, completion: @escaping ([User]) -> Void) {
    
        let usersGetEndpoint = "\(apiBaseUrl)/v2/users"
        guard let url = URL(string: usersGetEndpoint) else {
            os_log("Error, Cannot create URL.", log: APIClient.logTag, type: .error)
            return
        }
        
        APIRequest.get(withURL: url, fromController: controller) {
            (json) -> Void in
            
            do {
                if let jsonDict = try JSONSerialization.jsonObject(with: Data(json.utf8), options: []) as? [String: Any] {
                    let usersJsonDict = jsonDict["users"] ?? [:]
                    
                    let usersJson = try JSONSerialization.data(withJSONObject: usersJsonDict, options: [])
                    let usersJsonString = String(data: usersJson, encoding: String.Encoding.utf8) ?? "[]"
                    
                    if let users: Array<User> = Mapper<User>().mapArray(JSONString: usersJsonString) {
                        os_log("%@", log: APIClient.logTag, type: .debug, users)
                    
                        OperationQueue.main.addOperation {
                            completion(users)
                        }
                    } else {
                        os_log("Users Conversion Failed.", log: APIClient.logTag, type: .error)
                    }
                }
            } catch {
                os_log("API Response JSON Parse Failed.", log: APIClient.logTag, type: .error)
            }
        }
    }
    
    /**
     Handle a GET request for the group memberships of a user
     - parameters:
        - username: Unique identifier for a user of the application
        - controller: UI Controller that the API request originates from
        - completion:  Callback function which is invoked once the GET request is fulfilled
     */
    public static func userGroupsGetRequest(
        withUsername username: String,
        fromController controller: UIViewController?,
        completion: @escaping ([GroupInfo]) -> Void
    ) {
        // Create the URL
        let userGroupsGetEndpoint = "\(apiBaseUrl)/v2/users/groups/\(username)"
        guard let url = URL(string: userGroupsGetEndpoint) else {
            os_log("Error, Cannot create URL.", log: APIClient.logTag, type: .error)
            return
        }
        
        APIRequest.get(withURL: url, fromController: controller) {
            (json) -> Void in
            
            do {
                if let jsonDict = try JSONSerialization.jsonObject(with: Data(json.utf8), options: []) as? [String: Any] {
                    let groupsJsonDict = jsonDict["groups"] ?? [:]
                    
                    let groupsJson = try JSONSerialization.data(withJSONObject: groupsJsonDict, options: [])
                    let groupsJsonString = String(data: groupsJson, encoding: String.Encoding.utf8) ?? "[]"
                    
                    if let groups: Array<GroupInfo> = Mapper<GroupInfo>().mapArray(JSONString: groupsJsonString) {
                        os_log("%@", log: APIClient.logTag, type: .debug, groups)
                    
                        OperationQueue.main.addOperation {
                            completion(groups)
                        }
                    } else {
                        os_log("Group Memberships Conversion Failed.", log: APIClient.logTag, type: .error)
                    }
                }
            } catch {
                os_log("API Response JSON Parse Failed.", log: APIClient.logTag, type: .error)
            }
        }
    }
    
    /**
     Handle GET Requests for an exercise Log
     - parameters:
        - logID: a unique identifier for an exercise log
        - controller: UI Controller that the API request originates from
        - completion:  Callback function which is invoked once the GET request is fulfilled
     */
    public static func logGetRequest(
        withLogID logID: Int,
        fromController controller: UIViewController?,
        completion: @escaping (Log) -> Void
    ) {
        
        // Create the URL
        let logGetEndpoint = "\(apiBaseUrl)/v2/logs/\(logID)"
        guard let url = URL(string: logGetEndpoint) else {
            os_log("Error, Cannot create URL.", log: APIClient.logTag, type: .error)
            return
        }
        
        // Generate the request with a completion function to parse JSON
        APIRequest.get(withURL: url, fromController: controller) {
            (json) -> Void in
            
            do {
                if let jsonDict = try JSONSerialization.jsonObject(with: Data(json.utf8), options: []) as? [String: Any] {
                    let logJsonDict = jsonDict["log"] ?? [:]
                    
                    let logJson = try JSONSerialization.data(withJSONObject: logJsonDict, options: [])
                    let logJsonString = String(data: logJson, encoding: String.Encoding.utf8) ?? "{}"
                    
                    if let log: Log = Mapper<Log>().map(JSONString: logJsonString) {
                        os_log("%@", log: APIClient.logTag, type: .debug, log.toJSONString()!)
                        
                        OperationQueue.main.addOperation {
                            completion(log)
                        }
                    } else {
                        os_log("Log Conversion Failed.", log: APIClient.logTag, type: .error)
                    }
                }
            } catch {
                os_log("API Response JSON Parse Failed.", log: APIClient.logTag, type: .error)
            }
        }
    }
    
    /**
     Handle a GET Request for all Logs in the database
     - parameters:
        - controller: UI Controller that the API request originates from
        - completion:  Callback function which is invoked once the GET request is fulfilled
     */
    public static func logsGetRequest(fromController controller: UIViewController?, completion: @escaping ([Log]) -> Void) {
        
        let logsGetEndpoint = "\(apiBaseUrl)/v2/logs"
        guard let url = URL(string: logsGetEndpoint) else {
            os_log("Error, Cannot create URL.", log: APIClient.logTag, type: .error)
            return
        }
        
        APIRequest.get(withURL: url, fromController: controller) {
            (json) -> Void in
            
            do {
                if let jsonDict = try JSONSerialization.jsonObject(with: Data(json.utf8), options: []) as? [String: Any] {
                    let logsJsonDict = jsonDict["log"] ?? [:]
                    
                    let logsJson = try JSONSerialization.data(withJSONObject: logsJsonDict, options: [])
                    let logsJsonString = String(data: logsJson, encoding: String.Encoding.utf8) ?? "[]"
                    
                    if let logs: Array<Log> = Mapper<Log>().mapArray(JSONString: logsJsonString) {
                        os_log("%@", log: APIClient.logTag, type: .debug, logs)
                        
                        OperationQueue.main.addOperation {
                            completion(logs)
                        }
                    } else {
                        os_log("Logs Conversion Failed.", log: APIClient.logTag, type: .error)
                    }
                }
            } catch {
                os_log("API Response JSON Parse Failed.", log: APIClient.logTag, type: .error)
            }
        }
    }
    
    /**
     Handle GET Requests for a Group
     - parameters:
        - groupname: a unique name for a group
        - teamname:  a unique name for the team that a group is in
        - controller: UI Controller that the API request originates from
        - completion:  Callback function which is invoked once the GET request is fulfilled
     */
    public static func groupGetRequest(
        withGroupname groupname: String,
        inTeam teamname: String,
        fromController controller: UIViewController?,
        completion: @escaping (Group) -> Void
    ) {
        
        // Create the URL
        let groupGetEndpoint = "\(apiBaseUrl)/v2/groups/\(teamname)/\(groupname)"
        guard let url = URL(string: groupGetEndpoint) else {
            os_log("Error, Cannot create URL.", log: APIClient.logTag, type: .error)
            return
        }
        
        APIRequest.get(withURL: url, fromController: controller) {
            (json) -> Void in
            
            do {
                if let jsonDict = try JSONSerialization.jsonObject(with: Data(json.utf8), options: []) as? [String: Any] {
                    let groupJsonDict = jsonDict["group"] ?? [:]
                    
                    let groupJson = try JSONSerialization.data(withJSONObject: groupJsonDict, options: [])
                    let groupJsonString = String(data: groupJson, encoding: String.Encoding.utf8) ?? "{}"
                    
                    if let group: Group = Mapper<Group>().map(JSONString: groupJsonString) {
                        os_log("%@", log: APIClient.logTag, type: .debug, group.toJSONString()!)
                        
                        OperationQueue.main.addOperation {
                            completion(group)
                        }
                    } else {
                        os_log("Group Conversion Failed.", log: APIClient.logTag, type: .error)
                    }
                }
            } catch {
                os_log("API Response JSON Parse Failed.", log: APIClient.logTag, type: .error)
            }
        }
    }
    
    /**
     Handle a GET Request for all the Groups in the database
     - parameters:
        - controller: UI Controller that the API request originates from
        - completion:  Callback function which is invoked once the GET request is fulfilled
     */
    public static func groupsGetRequest(fromController controller: UIViewController?, completion: @escaping ([Group]) -> Void) {
        
        let groupsGetEndpoint = "\(apiBaseUrl)/v2/groups"
        guard let url = URL(string: groupsGetEndpoint) else {
            os_log("Error, Cannot create URL.", log: APIClient.logTag, type: .error)
            return
        }
        
        APIRequest.get(withURL: url, fromController: controller) {
            (json) -> Void in
            
            do {
                if let jsonDict = try JSONSerialization.jsonObject(with: Data(json.utf8), options: []) as? [String: Any] {
                    let groupsJsonDict = jsonDict["groups"] ?? [:]
                    
                    let groupsJson = try JSONSerialization.data(withJSONObject: groupsJsonDict, options: [])
                    let groupsJsonString = String(data: groupsJson, encoding: String.Encoding.utf8) ?? "[]"
                    
                    if let groups: Array<Group> = Mapper<Group>().mapArray(JSONString: groupsJsonString) {
                        os_log("%@", log: APIClient.logTag, type: .debug, groups)
                        
                        OperationQueue.main.addOperation {
                            completion(groups)
                        }
                    } else {
                        os_log("Groups Conversion Failed.", log: APIClient.logTag, type: .error)
                    }
                }
            } catch {
                os_log("API Response JSON Parse Failed.", log: APIClient.logTag, type: .error)
            }
        }
    }
    
    /**
     Handle a GET Request for all the members of a group in the database
     - parameters:
        - groupname: a unique name for a group
        - teamname:  a unique name for the team that a group is in
        - controller: UI Controller that the API request originates from
        - completion:  Callback function which is invoked once the GET request is fulfilled
     */
    public static func groupMembersGetRequest(
        withGroupname groupname: String,
        inTeam teamname: String,
        fromController controller: UIViewController?,
        completion: @escaping ([GroupMember]?) -> Void
    ) {
        
        let groupMembersGetEndpoint = "\(apiBaseUrl)/v2/groups/members/\(teamname)/\(groupname)"
        guard let url = URL(string: groupMembersGetEndpoint) else {
            os_log("Error, Cannot create URL.", log: APIClient.logTag, type: .error)
            return
        }
        
        APIRequest.get(withURL: url, fromController: controller) {
            (json) -> Void in
            
            do {
                if let jsonDict = try JSONSerialization.jsonObject(with: Data(json.utf8), options: []) as? [String: Any] {
                    let groupMembersJsonDict = jsonDict["group_members"] ?? [:]
                    
                    let groupMembersJson = try JSONSerialization.data(withJSONObject: groupMembersJsonDict, options: [])
                    let groupMembersJsonString = String(data: groupMembersJson, encoding: String.Encoding.utf8) ?? "[]"
                    
                    if let groupMembers: Array<GroupMember> = Mapper<GroupMember>().mapArray(JSONString: groupMembersJsonString) {
                        os_log("%@", log: APIClient.logTag, type: .debug, groupMembers)
                        
                        OperationQueue.main.addOperation {
                            completion(groupMembers)
                        }
                    } else {
                        os_log("Group Members Conversion Failed.", log: APIClient.logTag, type: .error)
                        
                        OperationQueue.main.addOperation {
                            completion(nil)
                        }
                    }
                }
            } catch {
                os_log("API Response JSON Parse Failed.", log: APIClient.logTag, type: .error)
                
                OperationQueue.main.addOperation {
                    completion(nil)
                }
            }
        }
    }
    
    /**
     Handle a GET Request for leaderboard information about a group in the database
     - parameters:
        - groupname: a unique name for a group
        - teamname:  a unique name for the team that a group is in
        - controller: UI Controller that the API request originates from
        - completion:  Callback function which is invoked once the GET request is fulfilled
     */
    public static func groupLeaderboardGetRequest(
        withGroupId groupId: Int,
        inInterval interval: String?,
        fromController controller: UIViewController?,
        completion: @escaping ([LeaderboardItem]?) -> Void
    ) {
        let intervalString: String = (interval != nil) ? "/\(interval ?? "")" : ""
        let groupLeaderboardGetEndpoint = "\(apiBaseUrl)/v2/groups/leaderboard/\(groupId)\(intervalString)"
        guard let url = URL(string: groupLeaderboardGetEndpoint) else {
            os_log("Error, Cannot create URL.", log: APIClient.logTag, type: .error)
            return
        }
        
        APIRequest.get(withURL: url, fromController: controller) {
            (json) -> Void in
            
            do {
                if let jsonDict = try JSONSerialization.jsonObject(with: Data(json.utf8), options: []) as? [String: Any] {
                    let leaderboardJsonDict = jsonDict["leaderboard"] ?? [:]
                    
                    let leaderboardJson = try JSONSerialization.data(withJSONObject: leaderboardJsonDict, options: [])
                    let leaderboardJsonString = String(data: leaderboardJson, encoding: String.Encoding.utf8) ?? "[]"
                    
                    if let leaderboardItems: Array<LeaderboardItem> =
                        Mapper<LeaderboardItem>().mapArray(JSONString: leaderboardJsonString) {
                        
                        os_log("%@", log: APIClient.logTag, type: .debug, leaderboardItems)
                        
                        OperationQueue.main.addOperation {
                            completion(leaderboardItems)
                        }
                    } else {
                        os_log("Leaderboard Conversion Failed.", log: APIClient.logTag, type: .error)
                        
                        OperationQueue.main.addOperation {
                            completion(nil)
                        }
                    }
                }
            } catch {
                os_log("API Response JSON Parse Failed.", log: APIClient.logTag, type: .error)
                
                OperationQueue.main.addOperation {
                    completion(nil)
                }
            }
        }
    }
    
    /**
     Handle GET Requests for a Comment
     - parameters:
        - commentId: a unique identifer for a comment
        - controller: UI Controller that the API request originates from
        - completion:  Callback function which is invoked once the GET request is fulfilled
     */
    public static func commentGetRequest(
        withCommentId commentId: Int,
        fromController controller: UIViewController?,
        completion: @escaping (Comment?) -> Void
    ) {
        
        // Create the URL
        let commentGetEndpoint = "\(apiBaseUrl)/v2/comments/\(commentId)"
        guard let url = URL(string: commentGetEndpoint) else {
            os_log("Error, Cannot create URL.", log: APIClient.logTag, type: .error)
            return
        }
        
        APIRequest.get(withURL: url, fromController: controller) {
            (json) -> Void in
            
            do {
                if let jsonDict = try JSONSerialization.jsonObject(with: Data(json.utf8), options: []) as? [String: Any] {
                    let commentJsonDict = jsonDict["comment"] ?? [:]
                    
                    let commentJson = try JSONSerialization.data(withJSONObject: commentJsonDict, options: [])
                    let commentJsonString = String(data: commentJson, encoding: String.Encoding.utf8) ?? "{}"
                    
                    if let comment: Comment = Mapper<Comment>().map(JSONString: commentJsonString) {
                        os_log("%@", log: APIClient.logTag, type: .debug, comment.toJSONString()!)
                        
                        OperationQueue.main.addOperation {
                            completion(comment)
                        }
                    } else {
                        os_log("Comment Conversion Failed.", log: APIClient.logTag, type: .error)
                        
                        OperationQueue.main.addOperation {
                            completion(nil)
                        }
                    }
                }
            } catch {
                os_log("API Response JSON Parse Failed.", log: APIClient.logTag, type: .error)
                
                OperationQueue.main.addOperation {
                    completion(nil)
                }
            }
        }
    }
    
    /**
     Handle a GET Request for all the comments in the database
     - parameters:
         - controller: UI Controller that the API request originates from
         - completion:  Callback function which is invoked once the GET request is fulfilled
     */
    public static func commentsGetRequest(
        fromController controller: UIViewController?,
        completion: @escaping ([Comment]?) -> Void
    ) {
        
        let commentsGetEndpoint = "\(apiBaseUrl)/v2/comments/"
        guard let url = URL(string: commentsGetEndpoint) else {
            os_log("Error, Cannot create URL.", log: APIClient.logTag, type: .error)
            return
        }
        
        APIRequest.get(withURL: url, fromController: controller) {
            (json) -> Void in
            
            do {
                if let jsonDict = try JSONSerialization.jsonObject(with: Data(json.utf8), options: []) as? [String: Any] {
                    let commentsJsonDict = jsonDict["comments"] ?? [:]
                    
                    let commentsJson = try JSONSerialization.data(withJSONObject: commentsJsonDict, options: [])
                    let commentsJsonString = String(data: commentsJson, encoding: String.Encoding.utf8) ?? "[]"
                    
                    if let comments: Array<Comment> = Mapper<Comment>().mapArray(JSONString: commentsJsonString) {
                        os_log("%@", log: APIClient.logTag, type: .debug, comments)
                        
                        OperationQueue.main.addOperation {
                            completion(comments)
                        }
                    } else {
                        os_log("Comments Conversion Failed.", log: APIClient.logTag, type: .error)
                        
                        OperationQueue.main.addOperation {
                            completion(nil)
                        }
                    }
                }
            } catch {
                os_log("API Response JSON Parse Failed.", log: APIClient.logTag, type: .error)
                
                OperationQueue.main.addOperation {
                    completion(nil)
                }
            }
        }
    }
    
    /**
     Handle GET Requests for an Activation Code
     - parameters:
         - code: a unique code to activate an account
         - controller: UI Controller that the API request originates from
         - completion:  Callback function which is invoked once the GET request is fulfilled
     */
    public static func activationCodeGetRequest(
        withCode code: String,
        fromController controller: UIViewController?,
        completion: @escaping (ActivationCode?) -> Void
    ) {
        
        // Create the URL
        let activationCodeGetEndpoint = "\(apiBaseUrl)/v2/activationcode/\(code)"
        guard let url = URL(string: activationCodeGetEndpoint) else {
            os_log("Error, Cannot create URL.", log: APIClient.logTag, type: .error)
            return
        }
        
        APIRequest.get(withURL: url, fromController: controller) {
            (json) -> Void in
            
            if let activationcode: ActivationCode = Mapper<ActivationCode>().map(JSONString: json) {
                os_log("%@", log: APIClient.logTag, type: .debug, activationcode.description)
                
                OperationQueue.main.addOperation {
                    completion(activationcode)
                }
            } else {
                os_log("Activation Code Conversion Failed.", log: APIClient.logTag, type: .error)
                
                OperationQueue.main.addOperation {
                    completion(nil)
                }
            }
        }
    }
    
    /**
     Handle GET Requests for a Notification
     - parameters:
         - notificationId: a unique identifer for a notification
         - controller: UI Controller that the API request originates from
         - completion:  Callback function which is invoked once the GET request is fulfilled
     */
    public static func notificationGetRequest(
        withNotificationId notificationId: Int,
        fromController controller: UIViewController?,
        completion: @escaping (Notification) -> Void
    ) {
        
        // Create the URL
        let notificationGetEndpoint = "\(apiBaseUrl)/v2/notification/\(notificationId)"
        guard let url = URL(string: notificationGetEndpoint) else {
            os_log("Error, Cannot create URL.", log: APIClient.logTag, type: .error)
            return
        }
        
        APIRequest.get(withURL: url, fromController: controller) {
            (json) -> Void in
            
            if let notification: Notification = Mapper<Notification>().map(JSONString: json) {
                os_log("%@", log: APIClient.logTag, type: .debug, notification.description)
                
                OperationQueue.main.addOperation {
                    completion(notification)
                }
            } else {
                os_log("Notification Conversion Failed.", log: APIClient.logTag, type: .error)
            }
        }
    }
    
    /**
     Handle a GET Request for all the notifications in the database
     - parameters:
         - controller: UI Controller that the API request originates from
         - completion:  Callback function which is invoked once the GET request is fulfilled
     */
    public static func notificationsGetRequest(
        fromController controller: UIViewController?,
        completion: @escaping ([Notification]) -> Void
    ) {
        
        let notificationsGetEndpoint = "\(apiBaseUrl)/v2/notifications"
        guard let url = URL(string: notificationsGetEndpoint) else {
            os_log("Error, Cannot create URL.", log: APIClient.logTag, type: .error)
            return
        }
        
        APIRequest.get(withURL: url, fromController: controller) {
            (json) -> Void in
            
            if let notifications: Array<Notification> = Mapper<Notification>().mapArray(JSONString: json) {
                os_log("%@", log: APIClient.logTag, type: .debug, notifications)
                
                OperationQueue.main.addOperation {
                    completion(notifications)
                }
            } else {
                os_log("Notifications Conversion Failed.", log: APIClient.logTag, type: .error)
            }
        }
    }
    
    /**
     Handle GET Requests for a Log Feed
     - parameters:
         - paramType: the grouping of logs to return (ex. user, group)
         - sortParam: a string to query the param type.  For example, if the paramType is user, the sortParam can
         be the username of a user
         - limit: the maximum number of logs to return
         - offset: not the rapper
         - controller: UI Controller that the API request originates from
         - completion:  Callback function which is invoked once the GET request is fulfilled
     */
    public static func logfeedGetRequest(
        withParamType paramType: String,
        sortParam: String,
        limit: Int,
        offset: Int,
        fromController controller: UIViewController?,
        completion: @escaping ([Log]) -> Void
    ) {
        
        let logfeedGetEndpoint = "\(apiBaseUrl)/v2/log_feed/\(paramType)/\(sortParam)/\(limit)/\(offset)"
        guard let url = URL(string: logfeedGetEndpoint) else {
            os_log("Error, Cannot create URL.", log: APIClient.logTag, type: .error)
            return
        }
        
        APIRequest.get(withURL: url, fromController: controller) {
            (json) -> Void in
            
            do {
                if let jsonDict = try JSONSerialization.jsonObject(with: Data(json.utf8), options: []) as? [String: Any] {
                    let logsJsonDict = jsonDict["logs"] ?? [:]
                    
                    let logsJson = try JSONSerialization.data(withJSONObject: logsJsonDict, options: [])
                    let logsJsonString = String(data: logsJson, encoding: String.Encoding.utf8) ?? "[]"
                    
                    if let logfeed: Array<Log> = Mapper<Log>().mapArray(JSONString: logsJsonString) {
                        os_log("%@", log: APIClient.logTag, type: .debug, logfeed)
                        
                        OperationQueue.main.addOperation {
                            completion(logfeed)
                        }
                    } else {
                        os_log("Log Feed Conversion Failed.", log: APIClient.logTag, type: .error)
                    }
                }
            } catch {
                os_log("Log Feed API Response JSON Parse Failed.", log: APIClient.logTag, type: .error)
            }
        }
    }
    
    /**
     Handle GET Requests for a Range View
     - parameters:
         - paramType: the grouping of range views to return (ex. user, group)
         - sortParam: a string to query the param type.  For example, if the paramType is user, the sortParam can
         be the username of a user
         - filter: the types of exercises to include in the range view (any combination of 'r', 'b', 's', 'o') where
         r->Run, b->Bike, s->Swim, o->Other
         - start: the first day in the range view
         - end: the last day in the range view
         - controller: UI Controller that the API request originates from
         - completion:  Callback function which is invoked once the GET request is fulfilled
     */
    public static func rangeViewGetRequest(
        withParamType paramType: String,
        sortParam: String,
        filter: String,
        start: String,
        end: String,
        fromController controller: UIViewController?,
        completion: @escaping ([RangeView]) -> Void
    ) {
        
        let rangeviewGetEndpoint = "\(apiBaseUrl)/v2/range_view/\(paramType)/\(sortParam)/\(filter)/\(start)/\(end)"
        guard let url = URL(string: rangeviewGetEndpoint) else {
            os_log("Error, Cannot create URL.", log: APIClient.logTag, type: .error)
            return
        }
        
        APIRequest.get(withURL: url, fromController: controller) {
            (json) -> Void in
            
            do {
                if let jsonDict = try JSONSerialization.jsonObject(with: Data(json.utf8), options: []) as? [String: Any] {
                    let rangeViewJsonDict = jsonDict["range_view"] ?? [:]
                    
                    let rangeViewJson = try JSONSerialization.data(withJSONObject: rangeViewJsonDict, options: [])
                    let rangeViewJsonString = String(data: rangeViewJson, encoding: String.Encoding.utf8) ?? "[]"
                    
                    if let rangeview: Array<RangeView> = Mapper<RangeView>().mapArray(JSONString: rangeViewJsonString) {
                        os_log("%@", log: APIClient.logTag, type: .debug, rangeview.description)
                        
                        OperationQueue.main.addOperation {
                            completion(rangeview)
                        }
                    } else {
                        os_log("Range View Conversion Failed.", log: APIClient.logTag, type: .error)
                        
                        OperationQueue.main.addOperation {
                            completion([])
                        }
                    }
                }
            } catch {
                os_log("Range View API Response JSON Parse Failed.", log: APIClient.logTag, type: .error)
                
                OperationQueue.main.addOperation {
                    completion([])
                }
            }
        }
    }
    
    // MARK: - POST Requests
    
    /**
     Handle POST Requests for a User
     - parameters:
         - user: an object representing the user to create on the server
         - controller: UI Controller that the API request originates from
         - completion:  Callback function which is invoked once the POST request is fulfilled
     */
    public static func userPostRequest(
        withUser user: User,
        fromController controller: UIViewController?,
        completion: @escaping (User?) -> Void
    ) {
        
        let usersPostEndpoint = "\(apiBaseUrl)/v2/users"
        guard let url = URL(string: usersPostEndpoint) else {
            os_log("Error, Cannot create URL.", log: APIClient.logTag, type: .error)
            return
        }
        
        // Convert the User to a JSON string
        let userJSON = Mapper().toJSONString(user, prettyPrint: false)
        
        APIRequest.post(withURL: url, andJson: userJSON ?? "", fromController: controller) {
            (json) -> Void in
            
            if let user: User = Mapper<User>().map(JSONString: json ?? "") {
                os_log("%@", log: APIClient.logTag, type: .debug, user.description)
                
                OperationQueue.main.addOperation {
                    completion(user)
                }
            } else {
                os_log("User Conversion Failed.", log: APIClient.logTag, type: .error)
                
                OperationQueue.main.addOperation {
                    completion(nil)
                }
            }
        }
    }
    
    /**
     Handle POST Requests for a Log
     - parameters:
         - log: an object representing the exercie log to create on the server
         - controller: UI Controller that the API request originates from
         - completion:  Callback function which is invoked once the POST request is fulfilled
     */
    public static func logPostRequest(
        withLog log: Log,
        fromController controller: UIViewController?,
        completion: @escaping (Log?) -> Void
    ) {
        
        let logPostEndpoint = "\(apiBaseUrl)/v2/logs/"
        guard let url = URL(string: logPostEndpoint) else {
            os_log("Error, Cannot create URL.", log: APIClient.logTag, type: .error)
            return
        }
        
        // Convert the Log to a JSON string
        let logJSON = Mapper().toJSONString(log, prettyPrint: false)
        
        APIRequest.post(withURL: url, andJson: logJSON ?? "", fromController: controller) {
            (json) -> Void in
            
            let jsonResponse = json ?? ""
            
            do {
                if let jsonDict = try JSONSerialization.jsonObject(with: Data(jsonResponse.utf8), options: []) as? [String: Any] {
                    let logJsonDict = jsonDict["log"] ?? [:]
                    
                    let logJson = try JSONSerialization.data(withJSONObject: logJsonDict, options: [])
                    let logJsonString = String(data: logJson, encoding: String.Encoding.utf8) ?? "{}"
                    
                    if let log: Log = Mapper<Log>().map(JSONString: logJsonString) {
                        os_log("%@", log: APIClient.logTag, type: .debug, log.toJSONString()!)
                        
                        OperationQueue.main.addOperation {
                            completion(log)
                        }
                    } else {
                        os_log("Log Conversion Failed.", log: APIClient.logTag, type: .error)
                        
                        OperationQueue.main.addOperation {
                            completion(nil)
                        }
                    }
                }
            } catch {
                os_log("API Response JSON Parse Failed.", log: APIClient.logTag, type: .error)
                
                OperationQueue.main.addOperation {
                    completion(nil)
                }
            }
        }
    }
    
    /**
     Handle POST Requests for a Comment
     - parameters:
         - comment: an object representing the comment to create on the server
         - controller: UI Controller that the API request originates from
         - completion:  Callback function which is invoked once the POST request is fulfilled
     */
    public static func commentPostRequest(
        withComment comment: Comment,
        fromController controller: UIViewController?,
        completion: @escaping (Comment?) -> Void
    ) {

        let commentPostEndpoint = "\(apiBaseUrl)/v2/comments/"
        guard let url = URL(string: commentPostEndpoint) else {
            os_log("Error, Cannot create URL.", log: APIClient.logTag, type: .error)
            return
        }
        
        // Convert the Comment to a JSON string
        let commentJSON = Mapper().toJSONString(comment, prettyPrint: false)
        
        APIRequest.post(withURL: url, andJson: commentJSON ?? "", fromController: controller) {
            (json) -> Void in
            
            let jsonResponse = json ?? ""
            
            do {
                if let jsonDict = try JSONSerialization.jsonObject(with: Data(jsonResponse.utf8), options: []) as? [String: Any] {
                    let commentJsonDict = jsonDict["comment"] ?? [:]
                    
                    let commentJson = try JSONSerialization.data(withJSONObject: commentJsonDict, options: [])
                    let commentJsonString = String(data: commentJson, encoding: String.Encoding.utf8) ?? "{}"
                    
                    if let comment: Comment = Mapper<Comment>().map(JSONString: commentJsonString) {
                        os_log("%@", log: APIClient.logTag, type: .debug, comment.toJSONString()!)
                        
                        OperationQueue.main.addOperation {
                            completion(comment)
                        }
                    } else {
                        os_log("Comment Conversion Failed.", log: APIClient.logTag, type: .error)
                        
                        OperationQueue.main.addOperation {
                            completion(nil)
                        }
                    }
                }
            } catch {
                os_log("API Response JSON Parse Failed.", log: APIClient.logTag, type: .error)
                
                OperationQueue.main.addOperation {
                    completion(nil)
                }
            }
        }
    }
    
    /**
     Handle POST Requests for an Activation Code
     - parameters:
         - controller: UI Controller that the API request originates from
         - completion:  Callback function which is invoked once the POST request is fulfilled
     */
    public static func activationCodePostRequest(
        fromController controller: UIViewController?,
        completion: @escaping (ActivationCode?
    ) -> Void) {
        
        let activationCodePostEndpoint = "\(apiBaseUrl)/v2/activationcode"
        guard let url = URL(string: activationCodePostEndpoint) else {
            os_log("Error, Cannot create URL.", log: APIClient.logTag, type: .error)
            return
        }
        
        APIRequest.post(withURL: url, andJson: "", fromController: controller) {
            (json) -> Void in
            
            if let activationcode: ActivationCode = Mapper<ActivationCode>().map(JSONString: json ?? "") {
                os_log("%@", log: APIClient.logTag, type: .debug, activationcode.description)
                
                OperationQueue.main.addOperation {
                    completion(activationcode)
                }
            } else {
                os_log("Activation Code Conversion Failed.", log: APIClient.logTag, type: .error)
                OperationQueue.main.addOperation {
                    completion(nil)
                }
            }
        }
    }
    
    /**
     Handle POST Requests for a Notification
     - parameters:
         - notification: an object representing the notification to create on the server
         - controller: UI Controller that the API request originates from
         - completion:  Callback function which is invoked once the POST request is fulfilled
     */
    public static func notificationPostRequest(
        withNotification notification: Notification,
        fromController controller: UIViewController?,
        completion: @escaping (Notification) -> Void
    ) {
        
        let notificationPostEndpoint = "\(apiBaseUrl)/v2/notification"
        guard let url = URL(string: notificationPostEndpoint) else {
            os_log("Error, Cannot create URL.", log: APIClient.logTag, type: .error)
            return
        }
        
        // Convert the Notification to a JSON string
        let notificationJSON = Mapper().toJSONString(notification, prettyPrint: false)
        
        APIRequest.post(withURL: url, andJson: notificationJSON ?? "", fromController: controller) {
            (json) -> Void in
            
            if let notification: Notification = Mapper<Notification>().map(JSONString: json ?? "") {
                os_log("%@", log: APIClient.logTag, type: .debug, notification.description)
                
                OperationQueue.main.addOperation {
                    completion(notification)
                }
            } else {
                os_log("Notifications Conversion Failed.", log: APIClient.logTag, type: .error)
            }
        }
    }
    
    // MARK: - PUT Requests
    
    /**
     Handle PUT Requests for a User
     - parameters:
         - username: the username of an existing user on the server
         - user: an object representing the updated user to reflect on the server
         - controller: UI Controller that the API request originates from
         - completion:  Callback function which is invoked once the PUT request is fulfilled
     */
    public static func userPutRequest(
        withUsername username: String,
        andUser user: User,
        fromController controller: UIViewController?,
        completion: @escaping (User?) -> Void
    ) {
        
        let usersPutEndpoint = "\(apiBaseUrl)/v2/users/\(username)"
        guard let url = URL(string: usersPutEndpoint) else {
            os_log("Error, Cannot create URL.", log: APIClient.logTag, type: .error)
            return
        }
        
        // Convert the User to a JSON string
        let userJSON = Mapper().toJSONString(user, prettyPrint: false)
        os_log("%@", log: APIClient.logTag, type: .debug, userJSON!)
        
        APIRequest.put(withURL: url, andJson: userJSON ?? "", fromController: controller) {
            (json: String?) -> Void in
            
            let jsonResponse = json ?? ""
            
            do {
                if let jsonDict = try JSONSerialization.jsonObject(with: Data(jsonResponse.utf8), options: []) as? [String: Any] {
                    let userJsonDict = jsonDict["user"] ?? [:]
                    
                    let userJson = try JSONSerialization.data(withJSONObject: userJsonDict, options: [])
                    let userJsonString = String(data: userJson, encoding: String.Encoding.utf8) ?? "{}"
                    
                    if let user: User = Mapper<User>().map(JSONString: userJsonString) {
                        os_log("%@", log: APIClient.logTag, type: .debug, user.toJSONString()!)
                        
                        OperationQueue.main.addOperation {
                            completion(user)
                        }
                    } else {
                        os_log("User Conversion Failed.", log: APIClient.logTag, type: .error)
                        
                        // If no user exists, return an empty user object
                        OperationQueue.main.addOperation {
                            completion(nil)
                        }
                    }
                }
            } catch {
                os_log("API Response JSON Parse Failed.", log: APIClient.logTag, type: .error)
                OperationQueue.main.addOperation {
                    completion(nil)
                }
            }
        }
    }
    
    /**
     Handle PUT Requests for a Log
     - parameters:
         - logID: the unique logId of an existing log on the server
         - log: an object representing the updated log to reflect on the server
         - controller: UI Controller that the API request originates from
         - completion:  Callback function which is invoked once the PUT request is fulfilled
     */
    public static func logPutRequest(
        withLogID logID: Int,
        andLog log: Log,
        fromController controller: UIViewController?,
        completion: @escaping (Log?) -> Void
    ) {
        
        let logPutEndpoint = "\(apiBaseUrl)/v2/logs/\(logID)"
        guard let url = URL(string: logPutEndpoint) else {
            os_log("Error, Cannot create URL.", log: APIClient.logTag, type: .error)
            return
        }
        
        // Convert the User to a JSON string
        let logJSON = Mapper().toJSONString(log, prettyPrint: false)
        
        APIRequest.put(withURL: url, andJson: logJSON ?? "", fromController: controller) {
            (json) -> Void in
            
            let jsonResponse = json ?? ""
            
            do {
                if let jsonDict = try JSONSerialization.jsonObject(with: Data(jsonResponse.utf8), options: []) as? [String: Any] {
                    let logJsonDict = jsonDict["log"] ?? [:]
                    
                    let logJson = try JSONSerialization.data(withJSONObject: logJsonDict, options: [])
                    let logJsonString = String(data: logJson, encoding: String.Encoding.utf8) ?? "{}"
                    
                    if let log: Log = Mapper<Log>().map(JSONString: logJsonString) {
                        os_log("%@", log: APIClient.logTag, type: .debug, log.toJSONString()!)
                        
                        OperationQueue.main.addOperation {
                            completion(log)
                        }
                    } else {
                        os_log("Log Conversion Failed.", log: APIClient.logTag, type: .error)
                        
                        OperationQueue.main.addOperation {
                            completion(nil)
                        }
                    }
                }
            } catch {
                os_log("API Response JSON Parse Failed.", log: APIClient.logTag, type: .error)
                
                OperationQueue.main.addOperation {
                    completion(nil)
                }
            }
        }
    }
    
    /**
     Handle PUT Requests for a Group
     - parameters:
         - groupname: the groupname of an existing group on the server
         - group: an object representing the updated group to reflect on the server
         - controller: UI Controller that the API request originates from
         - completion:  Callback function which is invoked once the PUT request is fulfilled
     */
    public static func groupPutRequest(
        withGroupname groupname: String,
        andGroup group: Group,
        fromController controller: UIViewController?,
        completion: @escaping (Group?) -> Void
    ) {
        
        let groupPutEndpoint = "\(apiBaseUrl)/v2/groups/\(groupname)"
        guard let url = URL(string: groupPutEndpoint) else {
            os_log("Error, Cannot create URL.", log: APIClient.logTag, type: .error)
            return
        }
        
        // Convert the User to a JSON string
        let groupJSON = Mapper().toJSONString(group, prettyPrint: false)
        
        APIRequest.put(withURL: url, andJson: groupJSON ?? "", fromController: controller) {
            (json) -> Void in
            
            if let group: Group = Mapper<Group>().map(JSONString: json ?? "") {
                os_log("%@", log: APIClient.logTag, type: .debug, group.description)
                
                OperationQueue.main.addOperation {
                    completion(group)
                }
            } else {
                os_log("Group Conversion Failed.", log: APIClient.logTag, type: .error)
                
                OperationQueue.main.addOperation {
                    completion(nil)
                }
            }
        }
    }
    
    /**
     Handle PUT Requests for a Comment
     - parameters:
     - commentId: the unqiue comment identifier for an existing comment on the server
     - comment: an object representing the updated comment to reflect on the server
     - controller: UI Controller that the API request originates from
     - completion:  Callback function which is invoked once the PUT request is fulfilled
     */
    public static func commentPutRequest(
        withCommentId commentId: Int,
        andComment comment: Comment,
        fromController controller: UIViewController?,
        completion: @escaping (Comment?) -> Void
    ) {
        
        let commentPutEndpoint = "\(apiBaseUrl)/v2/comments/\(commentId)"
        guard let url = URL(string: commentPutEndpoint) else {
            os_log("Error, Cannot create URL.", log: APIClient.logTag, type: .error)
            return
        }
        
        // Convert the User to a JSON string
        let commentJSON = Mapper().toJSONString(comment, prettyPrint: false)
        
        APIRequest.put(withURL: url, andJson: commentJSON ?? "", fromController: controller) {
            (json) -> Void in
            
            let jsonResponse = json ?? ""
            
            do {
                if let jsonDict = try JSONSerialization.jsonObject(with: Data(jsonResponse.utf8), options: []) as? [String: Any] {
                    let commentJsonDict = jsonDict["comment"] ?? [:]
                    
                    let commentJson = try JSONSerialization.data(withJSONObject: commentJsonDict, options: [])
                    let commentJsonString = String(data: commentJson, encoding: String.Encoding.utf8) ?? "{}"
                    
                    if let comment: Comment = Mapper<Comment>().map(JSONString: commentJsonString) {
                        os_log("%@", log: APIClient.logTag, type: .debug, comment.toJSONString()!)
                        
                        OperationQueue.main.addOperation {
                            completion(comment)
                        }
                    } else {
                        os_log("Comment Conversion Failed.", log: APIClient.logTag, type: .error)
                        
                        OperationQueue.main.addOperation {
                            completion(nil)
                        }
                    }
                }
            } catch {
                os_log("API Response JSON Parse Failed.", log: APIClient.logTag, type: .error)
                
                OperationQueue.main.addOperation {
                    completion(nil)
                }
            }
        }
    }
    
    // MARK: - DELETE Requests
    
    /**
     Handle DELETE Requests for a User
     - parameters:
         - username: the username of an existing user on the server
         - controller: UI Controller that the API request originates from
         - completion:  Callback function which is invoked once the DELETE request is fulfilled
     */
    public static func userDeleteRequest(
        withUsername username: String,
        fromController controller: UIViewController?,
        completion: @escaping (Bool) -> Void
    ) {
        
        let usersDeleteEndpoint = "\(apiBaseUrl)/v2/users/soft/\(username)"
        guard let url = URL(string: usersDeleteEndpoint) else {
            os_log("Error, Cannot create URL.", log: APIClient.logTag, type: .error)
            return
        }
        
        APIRequest.delete(withURL: url, fromController: controller) {
            (success) -> Void in
            
            os_log("Delete Result: %@", log: APIClient.logTag, type: .debug, String(success))
            
            OperationQueue.main.addOperation {
                completion(success)
            }
        }
    }
    
    /**
     Handle DELETE Requests for a Log
     - parameters:
         - logID: the unique log identifier of an existing log on the server
         - controller: UI Controller that the API request originates from
         - completion:  Callback function which is invoked once the DELETE request is fulfilled
     */
    public static func logDeleteRequest(
        withLogID logID: Int,
        fromController controller: UIViewController?,
        completion: @escaping (Bool) -> Void
    ) {
        
        let logDeleteEndpoint = "\(apiBaseUrl)/v2/logs/soft/\(logID)"
        guard let url = URL(string: logDeleteEndpoint) else {
            os_log("Error, Cannot create URL.", log: APIClient.logTag, type: .error)
            return
        }
        
        APIRequest.delete(withURL: url, fromController: controller) {
            (success) -> Void in
            
            os_log("Delete Result: %@", log: APIClient.logTag, type: .debug, String(success))
            
            OperationQueue.main.addOperation {
                completion(success)
            }
        }
    }
    
    /**
     Handle DELETE Requests for a Comment
     - parameters:
         - commentID: the unique comment identifier for an existing comment on the server
         - controller: UI Controller that the API request originates from
         - completion:  Callback function which is invoked once the DELETE request is fulfilled
     */
    public static func commentDeleteRequest(
        withCommentID commentID: Int,
        fromController controller: UIViewController?,
        completion: @escaping (Bool) -> Void
    ) {
        
        let commentDeleteEndpoint = "\(apiBaseUrl)/v2/comments/soft/\(commentID)"
        guard let url = URL(string: commentDeleteEndpoint) else {
            os_log("Error, Cannot create URL.", log: APIClient.logTag, type: .error)
            return
        }
        
        APIRequest.delete(withURL: url, fromController: controller) {
            (success) -> Void in
            
            os_log("Delete Result: %@", log: APIClient.logTag, type: .debug, String(success))
            
            OperationQueue.main.addOperation {
                completion(success)
            }
        }
    }
    
    /**
     Handle DELETE Requests for an Activation Code
     - parameters:
         - activationCode: the existing activation code on the server
         - controller: UI Controller that the API request originates from
         - completion:  Callback function which is invoked once the DELETE request is fulfilled
     */
    public static func activationCodeDeleteRequest(
        withActivationCode activationCode: String,
        fromController controller: UIViewController?,
        completion: @escaping (Bool) -> Void
    ) {
        
        let activationCodeDeleteEndpoint = "\(apiBaseUrl)/v2/activation_code/soft/\(activationCode)"
        guard let url = URL(string: activationCodeDeleteEndpoint) else {
            os_log("Error, Cannot create URL.", log: APIClient.logTag, type: .error)
            return
        }
        
        APIRequest.delete(withURL: url, fromController: controller) {
            (success) -> Void in
            
            os_log("Delete Result: %@", log: APIClient.logTag, type: .debug, String(success))
            
            OperationQueue.main.addOperation {
                completion(success)
            }
        }
    }
    
    /**
     Handle DELETE Requests for a Notification
     - parameters:
         - notificationId: the unique notification identifier of an existing notification on the server
         - controller: UI Controller that the API request originates from
         - completion:  Callback function which is invoked once the DELETE request is fulfilled
     */
    public static func notificationDeleteRequest(
        withNotificationId notificationId: String,
        fromController controller: UIViewController?,
        completion: @escaping (Bool) -> Void
    ) {
        
        let notificationDeleteEndpoint = "\(apiBaseUrl)/v2/notification/soft/\(notificationId)"
        guard let url = URL(string: notificationDeleteEndpoint) else {
            os_log("Error, Cannot create URL.", log: APIClient.logTag, type: .error)
            return
        }
        
        APIRequest.delete(withURL: url, fromController: controller) {
            (success) -> Void in
            
            os_log("Delete Result: %@", log: APIClient.logTag, type: .debug, String(success))
            
            OperationQueue.main.addOperation {
                completion(success)
            }
        }
    }
}
