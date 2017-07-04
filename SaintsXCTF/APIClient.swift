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
    public static func userGetRequest(withUsername username: String,
                                      completion: @escaping (User) -> Void) {
        
        // Create the URL
        let userGetEndpoint = "https://www.saintsxctf.com/api/api.php/users/\(username)"
        guard let url = URL(string: userGetEndpoint) else {
            print("\(logTag) Error, Cannot create URL")
            return
        }
        
        // Generate the request with a completion function to parse JSON
        APIRequest.get(withURL: url) {
            (json) -> Void in
        
            if let user: User = Mapper<User>().map(JSONString: json) {
                print("\(logTag) \(user)")
                
                OperationQueue.main.addOperation {
                    completion(user)
                }
            } else {
                print("\(logTag) User Conversion Failed.")
            }
        }
    }
    
    // Handle GET Requests for all Users
    public static func usersGetRequest(completion: @escaping ([User]) -> Void) {
    
        let usersGetEndpoint = "https://www.saintsxctf.com/api/api.php/users"
        guard let url = URL(string: usersGetEndpoint) else {
            print("\(logTag) Error, Cannot create URL")
            return
        }
        
        APIRequest.get(withURL: url) {
            (json) -> Void in
            
            if let user: Array<User> = Mapper<User>().mapArray(JSONString: json) {
                print("\(logTag) \(user)")
            
                OperationQueue.main.addOperation {
                    completion(user)
                }
            } else {
                print("\(logTag) User Conversion Failed.")
            }
        }
    }
    
    // Handle GET Requests for a Log
    public static func logGetRequest(withLogID logID: Int) -> Log? {
        
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
    
    // Handle GET Requests for a Comment
    public static func commentGetRequest(withCommentId commentId: Int) -> Comment? {
        
        // Create the URL
        let commentGetEndpoint = "https://www.saintsxctf.com/api/api.php/comment/\(commentId)"
        guard let url = URL(string: commentGetEndpoint) else {
            print("\(logTag) Error, Cannot create URL")
            return nil
        }
        
        var commentObj: Comment?
        
        // Generate the request with a completion function to parse JSON
        APIRequest.get(withURL: url) {
            (json) -> Void in
            
            let comment: Comment? = Mapper<Comment>().map(JSONString: json)
            print(comment ?? "\(logTag) Comment Conversion Failed.")
            
            commentObj = comment
        }
        
        return commentObj
    }
    
    // Handle GET Requests for all Comments
    public static func commentsGetRequest() -> [Comment]? {
        
        let commentsGetEndpoint = "https://www.saintsxctf.com/api/api.php/comments"
        guard let url = URL(string: commentsGetEndpoint) else {
            print("\(logTag) Error, Cannot create URL")
            return nil
        }
        
        var commentArray: Array<Comment>?
        
        APIRequest.get(withURL: url) {
            (json) -> Void in
            
            let comments: Array<Comment>? = Mapper<Comment>().mapArray(JSONString: json)
            print(comments ?? "\(logTag) Comments Conversion Failed.")
            
            commentArray = comments
        }
        
        return commentArray
    }
    
    // Handle GET Requests for a Message
    public static func messageGetRequest(withMessageId messageId: Int) -> Message? {
        
        // Create the URL
        let messageGetEndpoint = "https://www.saintsxctf.com/api/api.php/message/\(messageId)"
        guard let url = URL(string: messageGetEndpoint) else {
            print("\(logTag) Error, Cannot create URL")
            return nil
        }
        
        var messageObj: Message?
        
        // Generate the request with a completion function to parse JSON
        APIRequest.get(withURL: url) {
            (json) -> Void in
            
            let message: Message? = Mapper<Message>().map(JSONString: json)
            print(message ?? "\(logTag) Message Conversion Failed.")
            
            messageObj = message
        }
        
        return messageObj
    }
    
    // Handle GET Requests for all Messages
    public static func messagesGetRequest() -> [Message]? {
        
        let messagesGetEndpoint = "https://www.saintsxctf.com/api/api.php/messages"
        guard let url = URL(string: messagesGetEndpoint) else {
            print("\(logTag) Error, Cannot create URL")
            return nil
        }
        
        var messageArray: Array<Message>?
        
        APIRequest.get(withURL: url) {
            (json) -> Void in
            
            let messages: Array<Message>? = Mapper<Message>().mapArray(JSONString: json)
            print(messages ?? "\(logTag) Messages Conversion Failed.")
            
            messageArray = messages
        }
        
        return messageArray
    }
    
    // Handle GET Requests for an Activation Code
    public static func activationCodeGetRequest(withCode code: String) -> ActivationCode? {
        
        // Create the URL
        let activationCodeGetEndpoint = "https://www.saintsxctf.com/api/api.php/activationcode/\(code)"
        guard let url = URL(string: activationCodeGetEndpoint) else {
            print("\(logTag) Error, Cannot create URL")
            return nil
        }
        
        var activationCodeObj: ActivationCode?
        
        // Generate the request with a completion function to parse JSON
        APIRequest.get(withURL: url) {
            (json) -> Void in
            
            let activationCode: ActivationCode? = Mapper<ActivationCode>().map(JSONString: json)
            print(activationCode ?? "\(logTag) Activation Code Conversion Failed.")
            
            activationCodeObj = activationCode
        }
        
        return activationCodeObj
    }
    
    // Handle GET Requests for a Notification
    public static func notificationGetRequest(withNotificationId notificationId: Int) -> Notification? {
        
        // Create the URL
        let notificationGetEndpoint = "https://www.saintsxctf.com/api/api.php/notification/\(notificationId)"
        guard let url = URL(string: notificationGetEndpoint) else {
            print("\(logTag) Error, Cannot create URL")
            return nil
        }
        
        var notificationObj: Notification?
        
        // Generate the request with a completion function to parse JSON
        APIRequest.get(withURL: url) {
            (json) -> Void in
            
            let notification: Notification? = Mapper<Notification>().map(JSONString: json)
            print(notification ?? "\(logTag) Notification Conversion Failed.")
            
            notificationObj = notification
        }
        
        return notificationObj
    }
    
    // Handle GET Requests for all Notifications
    public static func notificationsGetRequest() -> [Notification]? {
        
        let notificationsGetEndpoint = "https://www.saintsxctf.com/api/api.php/notifications"
        guard let url = URL(string: notificationsGetEndpoint) else {
            print("\(logTag) Error, Cannot create URL")
            return nil
        }
        
        var notificationsArray: Array<Notification>?
        
        APIRequest.get(withURL: url) {
            (json) -> Void in
            
            let notifications: Array<Notification>? = Mapper<Notification>().mapArray(JSONString: json)
            print(notifications ?? "\(logTag) Notifications Conversion Failed.")
            
            notificationsArray = notifications
        }
        
        return notificationsArray
    }
    
    // Handle GET Requests for a Log Feed
    public static func logfeedGetRequest(withParamType paramType: String, sortParam: String,
                                         limit: Int, offset: Int) -> [Log]? {
        
        let logfeedGetEndpoint = "https://www.saintsxctf.com/api/api.php/logfeed/"
            + "\(paramType)/\(sortParam)/\(limit)/\(offset)"
        guard let url = URL(string: logfeedGetEndpoint) else {
            print("\(logTag) Error, Cannot create URL")
            return nil
        }
        
        var logfeedArray: Array<Log>?
        
        APIRequest.get(withURL: url) {
            (json) -> Void in
            
            let logfeed: Array<Log>? = Mapper<Log>().mapArray(JSONString: json)
            print(logfeed ?? "\(logTag) LogFeed Conversion Failed.")
            
            logfeedArray = logfeed
        }
        
        return logfeedArray
    }
    
    // Handle GET Requests for a Message Feed
    public static func messagefeedGetRequest(withParamType paramType: String, sortParam: String,
                                         limit: Int, offset: Int) -> [Message]? {
        
        let messagefeedGetEndpoint = "https://www.saintsxctf.com/api/api.php/messagefeed/"
            + "\(paramType)/\(sortParam)/\(limit)/\(offset)"
        guard let url = URL(string: messagefeedGetEndpoint) else {
            print("\(logTag) Error, Cannot create URL")
            return nil
        }
        
        var messagefeedArray: Array<Message>?
        
        APIRequest.get(withURL: url) {
            (json) -> Void in
            
            let messagefeed: Array<Message>? = Mapper<Message>().mapArray(JSONString: json)
            print(messagefeed ?? "\(logTag) MessageFeed Conversion Failed.")
            
            messagefeedArray = messagefeed
        }
        
        return messagefeedArray
    }
    
    // Handle GET Requests for a Range View
    public static func rangeViewGetRequest(withParamType paramType: String, sortParam: String,
                                         start: Int, end: Int) -> [RangeView]? {
        
        let rangeviewGetEndpoint = "https://www.saintsxctf.com/api/api.php/rangeview/"
            + "\(paramType)/\(sortParam)/\(start)/\(end)"
        guard let url = URL(string: rangeviewGetEndpoint) else {
            print("\(logTag) Error, Cannot create URL")
            return nil
        }
        
        var rangeviewArray: Array<RangeView>?
        
        APIRequest.get(withURL: url) {
            (json) -> Void in
            
            let rangeview: Array<RangeView>? = Mapper<RangeView>().mapArray(JSONString: json)
            print(rangeview ?? "\(logTag) RangeView Conversion Failed.")
            
            rangeviewArray = rangeview
        }
        
        return rangeviewArray
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
    
    // Handle POST Request for a Comment
    public static func commentPostRequest(withComment comment: Comment) -> Comment? {
        
        let commentPostEndpoint = "https://www.saintsxctf.com/api/api.php/comment"
        guard let url = URL(string: commentPostEndpoint) else {
            print("\(logTag) Error, Cannot create URL")
            return nil
        }
        
        var commentObj: Comment?
        
        APIRequest.post(withURL: url, andObject: comment) {
            (json) -> Void in
            
            let comment = Mapper<Comment>().map(JSONString: json)
            print(comment ?? "\(logTag) Comment Conversion Failed")
            
            commentObj = comment
        }
        
        return commentObj
    }
    
    // Handle POST Request for a Message
    public static func messagePostRequest(withMessage message: Message) -> Message? {
        
        let messagePostEndpoint = "https://www.saintsxctf.com/api/api.php/message"
        guard let url = URL(string: messagePostEndpoint) else {
            print("\(logTag) Error, Cannot create URL")
            return nil
        }
        
        var messageObj: Message?
        
        APIRequest.post(withURL: url, andObject: message) {
            (json) -> Void in
            
            let message = Mapper<Message>().map(JSONString: json)
            print(message ?? "\(logTag) Message Conversion Failed")
            
            messageObj = message
        }
        
        return messageObj
    }
    
    // Handle POST Request for an Activation Code
    public static func activationCodePostRequest(withActivationCode activationCode:
                                                ActivationCode) -> ActivationCode? {
        
        let activationCodePostEndpoint = "https://www.saintsxctf.com/api/api.php/activationcode"
        guard let url = URL(string: activationCodePostEndpoint) else {
            print("\(logTag) Error, Cannot create URL")
            return nil
        }
        
        var activationCodeObj: ActivationCode?
        
        APIRequest.post(withURL: url, andObject: activationCode) {
            (json) -> Void in
            
            let activationCode = Mapper<ActivationCode>().map(JSONString: json)
            print(activationCode ?? "\(logTag) Activation Code Conversion Failed")
            
            activationCodeObj = activationCode
        }
        
        return activationCodeObj
    }
    
    // Handle POST Request for a Notification
    public static func notificationPostRequest(withNotification notification: Notification) -> Notification? {
        
        let notificationPostEndpoint = "https://www.saintsxctf.com/api/api.php/notification"
        guard let url = URL(string: notificationPostEndpoint) else {
            print("\(logTag) Error, Cannot create URL")
            return nil
        }
        
        var notificationObj: Notification?
        
        APIRequest.post(withURL: url, andObject: notification) {
            (json) -> Void in
            
            let notification = Mapper<Notification>().map(JSONString: json)
            print(notification ?? "\(logTag) Notification Conversion Failed")
            
            notificationObj = notification
        }
        
        return notificationObj
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
    public static func logPutRequest(withLogID logID: Int, andLog log: Log) -> Log? {
        
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
    
    // Handle PUT Request for a Comment
    public static func commentPutRequest(withCommentId commentId: Int, andComment comment: Comment) -> Comment? {
        
        let commentPutEndpoint = "https://www.saintsxctf.com/api/api.php/comment/\(commentId)"
        guard let url = URL(string: commentPutEndpoint) else {
            print("\(logTag) Error, Cannot create URL")
            return nil
        }
        
        var commentObj: Comment?
        
        APIRequest.put(withURL: url, andObject: comment) {
            (json) -> Void in
            
            let comment = Mapper<Comment>().map(JSONString: json)
            print(comment ?? "\(logTag) Comment Conversion Failed")
            
            commentObj = comment
        }
        
        return commentObj
    }
    
    // Handle PUT Request for a Message
    public static func messagePutRequest(withMessageId messageId: Int, andMessage message: Message) -> Message? {
        
        let messagePutEndpoint = "https://www.saintsxctf.com/api/api.php/message/\(messageId)"
        guard let url = URL(string: messagePutEndpoint) else {
            print("\(logTag) Error, Cannot create URL")
            return nil
        }
        
        var messageObj: Message?
        
        APIRequest.put(withURL: url, andObject: message) {
            (json) -> Void in
            
            let message = Mapper<Message>().map(JSONString: json)
            print(message ?? "\(logTag) Message Conversion Failed")
            
            messageObj = message
        }
        
        return messageObj
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
    public static func logDeleteRequest(withLogID logID: Int) -> Bool {
        
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
    
    // Handle DELETE Request for a Comment
    public static func commentDeleteRequest(withCommentID commentID: Int) -> Bool {
        
        let commentDeleteEndpoint = "https://www.saintsxctf.com/api/api.php/comment/\(commentID)"
        guard let url = URL(string: commentDeleteEndpoint) else {
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
    
    // Handle DELETE Request for a Message
    public static func messageDeleteRequest(withMessageID messageID: Int) -> Bool {
        
        let messageDeleteEndpoint = "https://www.saintsxctf.com/api/api.php/message/\(messageID)"
        guard let url = URL(string: messageDeleteEndpoint) else {
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
    
    // Handle DELETE Request for a Activation Code
    public static func activationCodeDeleteRequest(withActivationCode activationCode: String) -> Bool {
        
        let activationCodeDeleteEndpoint = "https://www.saintsxctf.com/api/api.php/"
                                            + "activationcode/\(activationCode)"
        guard let url = URL(string: activationCodeDeleteEndpoint) else {
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
    
    // Handle DELETE Request for a Notification
    public static func notificationDeleteRequest(withNotificationId notificationId: String) -> Bool {
        
        let notificationDeleteEndpoint = "https://www.saintsxctf.com/api/api.php/"
            + "notification/\(notificationId)"
        guard let url = URL(string: notificationDeleteEndpoint) else {
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
