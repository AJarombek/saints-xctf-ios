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

class APIClient {
    
    private static let logTag = OSLog(subsystem: "SaintsXCTF.APIClient.APIClient", category: "APIClient")
    
    // MARK: - GET Requests
    
    // Handle GET Requests for a User
    public static func userGetRequest(withUsername username: String,
                                      completion: @escaping (User) -> Void) {
        
        // Create the URL
        let userGetEndpoint = "https://www.saintsxctf.com/api/api.php/users/\(username)"
        guard let url = URL(string: userGetEndpoint) else {
            os_log("Error, Cannot create URL.", log: APIClient.logTag, type: .error)
            return
        }
        
        // Generate the request with a completion function to parse JSON
        APIRequest.get(withURL: url) {
            (json) -> Void in
        
            if let user: User = Mapper<User>().map(JSONString: json) {
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
    }
    
    // Handle GET Requests for all Users
    public static func usersGetRequest(completion: @escaping ([User]) -> Void) {
    
        let usersGetEndpoint = "https://www.saintsxctf.com/api/api.php/users"
        guard let url = URL(string: usersGetEndpoint) else {
            os_log("Error, Cannot create URL.", log: APIClient.logTag, type: .error)
            return
        }
        
        APIRequest.get(withURL: url) {
            (json) -> Void in
            
            if let users: Array<User> = Mapper<User>().mapArray(JSONString: json) {
                os_log("%@", log: APIClient.logTag, type: .debug, users)
            
                OperationQueue.main.addOperation {
                    completion(users)
                }
            } else {
                os_log("Users Conversion Failed.", log: APIClient.logTag, type: .error)
            }
        }
    }
    
    // Handle GET Requests for a Log
    public static func logGetRequest(withLogID logID: Int,
                                     completion: @escaping (Log) -> Void) {
        
        // Create the URL
        let logGetEndpoint = "https://www.saintsxctf.com/api/api.php/log/\(logID)"
        guard let url = URL(string: logGetEndpoint) else {
            os_log("Error, Cannot create URL.", log: APIClient.logTag, type: .error)
            return
        }
        
        // Generate the request with a completion function to parse JSON
        APIRequest.get(withURL: url) {
            (json) -> Void in
            
            if let log: Log = Mapper<Log>().map(JSONString: json) {
                os_log("%@", log: APIClient.logTag, type: .debug, log.toJSONString()!)
                
                OperationQueue.main.addOperation {
                    completion(log)
                }
            } else {
                os_log("Log Conversion Failed.", log: APIClient.logTag, type: .error)
            }
        }
    }
    
    // Handle GET Requests for all Logs
    public static func logsGetRequest(completion: @escaping ([Log]) -> Void) {
        
        let logsGetEndpoint = "https://www.saintsxctf.com/api/api.php/logs"
        guard let url = URL(string: logsGetEndpoint) else {
            os_log("Error, Cannot create URL.", log: APIClient.logTag, type: .error)
            return
        }
        
        APIRequest.get(withURL: url) {
            (json) -> Void in
            
            if let logs: Array<Log> = Mapper<Log>().mapArray(JSONString: json) {
                os_log("%@", log: APIClient.logTag, type: .debug, logs)
                
                OperationQueue.main.addOperation {
                    completion(logs)
                }
            } else {
                os_log("Logs Conversion Failed.", log: APIClient.logTag, type: .error)
            }
        }
    }
    
    // Handle GET Requests for a Group
    public static func groupGetRequest(withGroupname groupname: String,
                                       completion: @escaping (Group) -> Void) {
        
        // Create the URL
        let groupGetEndpoint = "https://www.saintsxctf.com/api/api.php/group/\(groupname)"
        guard let url = URL(string: groupGetEndpoint) else {
            os_log("Error, Cannot create URL.", log: APIClient.logTag, type: .error)
            return
        }
        
        APIRequest.get(withURL: url) {
            (json) -> Void in
            
            if let group: Group = Mapper<Group>().map(JSONString: json) {
                os_log("%@", log: APIClient.logTag, type: .debug, group.description)
                
                OperationQueue.main.addOperation {
                    completion(group)
                }
            } else {
                os_log("Group Conversion Failed.", log: APIClient.logTag, type: .error)
            }
        }
    }
    
    // Handle GET Requests for all Groups
    public static func groupsGetRequest(completion: @escaping ([Group]) -> Void) {
        
        let groupsGetEndpoint = "https://www.saintsxctf.com/api/api.php/groups"
        guard let url = URL(string: groupsGetEndpoint) else {
            os_log("Error, Cannot create URL.", log: APIClient.logTag, type: .error)
            return
        }
        
        APIRequest.get(withURL: url) {
            (json) -> Void in
            
            if let groups: Array<Group> = Mapper<Group>().mapArray(JSONString: json) {
                os_log("%@", log: APIClient.logTag, type: .debug, groups)
                
                OperationQueue.main.addOperation {
                    completion(groups)
                }
            } else {
                os_log("Groups Conversion Failed.", log: APIClient.logTag, type: .error)
            }
        }
    }
    
    // Handle GET Requests for a Comment
    public static func commentGetRequest(withCommentId commentId: Int,
                                         completion: @escaping (Comment) -> Void) {
        
        // Create the URL
        let commentGetEndpoint = "https://www.saintsxctf.com/api/api.php/comment/\(commentId)"
        guard let url = URL(string: commentGetEndpoint) else {
            os_log("Error, Cannot create URL.", log: APIClient.logTag, type: .error)
            return
        }
        
        APIRequest.get(withURL: url) {
            (json) -> Void in
            
            if let comment: Comment = Mapper<Comment>().map(JSONString: json) {
                os_log("%@", log: APIClient.logTag, type: .debug, comment.description)
                
                OperationQueue.main.addOperation {
                    completion(comment)
                }
            } else {
                os_log("Comment Conversion Failed.", log: APIClient.logTag, type: .error)
            }
        }
    }
    
    // Handle GET Requests for all Comments
    public static func commentsGetRequest(completion: @escaping ([Comment]) -> Void) {
        
        let commentsGetEndpoint = "https://www.saintsxctf.com/api/api.php/comments"
        guard let url = URL(string: commentsGetEndpoint) else {
            os_log("Error, Cannot create URL.", log: APIClient.logTag, type: .error)
            return
        }
        
        APIRequest.get(withURL: url) {
            (json) -> Void in
            
            if let comments: Array<Comment> = Mapper<Comment>().mapArray(JSONString: json) {
                os_log("%@", log: APIClient.logTag, type: .debug, comments)
                
                OperationQueue.main.addOperation {
                    completion(comments)
                }
            } else {
                os_log("Comments Conversion Failed.", log: APIClient.logTag, type: .error)
            }
        }
    }
    
    // Handle GET Requests for a Message
    public static func messageGetRequest(withMessageId messageId: Int,
                                         completion: @escaping (Message) -> Void) {
        
        // Create the URL
        let messageGetEndpoint = "https://www.saintsxctf.com/api/api.php/message/\(messageId)"
        guard let url = URL(string: messageGetEndpoint) else {
            os_log("Error, Cannot create URL.", log: APIClient.logTag, type: .error)
            return
        }
        
        APIRequest.get(withURL: url) {
            (json) -> Void in
            
            if let message: Message = Mapper<Message>().map(JSONString: json) {
                os_log("%@", log: APIClient.logTag, type: .debug, message.description)
                
                OperationQueue.main.addOperation {
                    completion(message)
                }
            } else {
                os_log("Message Conversion Failed.", log: APIClient.logTag, type: .error)
            }
        }
    }
    
    // Handle GET Requests for all Messages
    public static func messagesGetRequest(completion: @escaping ([Message]) -> Void) {
        
        let messagesGetEndpoint = "https://www.saintsxctf.com/api/api.php/messages"
        guard let url = URL(string: messagesGetEndpoint) else {
            os_log("Error, Cannot create URL.", log: APIClient.logTag, type: .error)
            return
        }
        
        APIRequest.get(withURL: url) {
            (json) -> Void in
            
            if let messages: Array<Message> = Mapper<Message>().mapArray(JSONString: json) {
                os_log("%@", log: APIClient.logTag, type: .debug, messages)
                
                OperationQueue.main.addOperation {
                    completion(messages)
                }
            } else {
                os_log("Messages Conversion Failed.", log: APIClient.logTag, type: .error)
            }
        }
    }
    
    // Handle GET Requests for an Activation Code
    public static func activationCodeGetRequest(withCode code: String,
                                                completion: @escaping (ActivationCode?) -> Void) {
        
        // Create the URL
        let activationCodeGetEndpoint = "https://www.saintsxctf.com/api/api.php/activationcode/\(code)"
        guard let url = URL(string: activationCodeGetEndpoint) else {
            os_log("Error, Cannot create URL.", log: APIClient.logTag, type: .error)
            return
        }
        
        APIRequest.get(withURL: url) {
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
    
    // Handle GET Requests for a Notification
    public static func notificationGetRequest(withNotificationId notificationId: Int,
                                              completion: @escaping (Notification) -> Void) {
        
        // Create the URL
        let notificationGetEndpoint = "https://www.saintsxctf.com/api/api.php/notification/\(notificationId)"
        guard let url = URL(string: notificationGetEndpoint) else {
            os_log("Error, Cannot create URL.", log: APIClient.logTag, type: .error)
            return
        }
        
        APIRequest.get(withURL: url) {
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
    
    // Handle GET Requests for all Notifications
    public static func notificationsGetRequest(completion: @escaping ([Notification]) -> Void) {
        
        let notificationsGetEndpoint = "https://www.saintsxctf.com/api/api.php/notifications"
        guard let url = URL(string: notificationsGetEndpoint) else {
            os_log("Error, Cannot create URL.", log: APIClient.logTag, type: .error)
            return
        }
        
        APIRequest.get(withURL: url) {
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
    
    // Handle GET Requests for a Log Feed
    public static func logfeedGetRequest(withParamType paramType: String, sortParam: String,
                                         limit: Int, offset: Int, completion: @escaping ([Log]) -> Void) {
        
        let logfeedGetEndpoint = "https://www.saintsxctf.com/api/api.php/logfeed/"
            + "\(paramType)/\(sortParam)/\(limit)/\(offset)"
        guard let url = URL(string: logfeedGetEndpoint) else {
            os_log("Error, Cannot create URL.", log: APIClient.logTag, type: .error)
            return
        }
        
        APIRequest.get(withURL: url) {
            (json) -> Void in
            
            if let logfeed: Array<Log> = Mapper<Log>().mapArray(JSONString: json) {
                os_log("%@", log: APIClient.logTag, type: .debug, logfeed)
                
                OperationQueue.main.addOperation {
                    completion(logfeed)
                }
            } else {
                os_log("Log Feed Conversion Failed.", log: APIClient.logTag, type: .error)
            }
        }
    }
    
    // Handle GET Requests for a Message Feed
    public static func messagefeedGetRequest(withParamType paramType: String, sortParam: String,
                                             limit: Int, offset: Int, completion: @escaping ([Message]) -> Void) {
        
        let messagefeedGetEndpoint = "https://www.saintsxctf.com/api/api.php/messagefeed/"
            + "\(paramType)/\(sortParam)/\(limit)/\(offset)"
        guard let url = URL(string: messagefeedGetEndpoint) else {
            os_log("Error, Cannot create URL.", log: APIClient.logTag, type: .error)
            return
        }
        
        APIRequest.get(withURL: url) {
            (json) -> Void in
            
            if let messagefeed: Array<Message> = Mapper<Message>().mapArray(JSONString: json) {
                os_log("%@", log: APIClient.logTag, type: .debug, messagefeed)
                
                OperationQueue.main.addOperation {
                    completion(messagefeed)
                }
            } else {
                os_log("Message Feed Conversion Failed.", log: APIClient.logTag, type: .error)
            }
        }
    }
    
    // Handle GET Requests for a Range View
    public static func rangeViewGetRequest(withParamType paramType: String, sortParam: String, filter: String,
                                           start: String, end: String, completion: @escaping ([RangeView]) -> Void) {
        
        let rangeviewGetEndpoint = "https://www.saintsxctf.com/api/api.php/rangeview/"
            + "\(paramType)/\(sortParam)/\(filter)/\(start)/\(end)"
        print(rangeviewGetEndpoint)
        guard let url = URL(string: rangeviewGetEndpoint) else {
            os_log("Error, Cannot create URL.", log: APIClient.logTag, type: .error)
            return
        }
        
        APIRequest.get(withURL: url) {
            (json) -> Void in
            
            if let rangeview: Array<RangeView> = Mapper<RangeView>().mapArray(JSONString: json) {
                os_log("%@", log: APIClient.logTag, type: .debug, rangeview.description)
                
                OperationQueue.main.addOperation {
                    completion(rangeview)
                }
            } else {
                os_log("Range View Conversion Failed.", log: APIClient.logTag, type: .error)
            }
        }
    }
    
    // MARK: - POST Requests
    
    // Handle POST Request for a User
    public static func userPostRequest(withUser user: User, completion: @escaping (User?) -> Void) {
        
        let usersPostEndpoint = "https://www.saintsxctf.com/api/api.php/users"
        guard let url = URL(string: usersPostEndpoint) else {
            os_log("Error, Cannot create URL.", log: APIClient.logTag, type: .error)
            return
        }
        
        // Convert the User to a JSON string
        let userJSON = Mapper().toJSONString(user, prettyPrint: false)
        
        APIRequest.post(withURL: url, andJson: userJSON ?? "") {
            (json) -> Void in
            
            if let user: User = Mapper<User>().map(JSONString: json) {
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
    
    // Handle POST Request for a Log
    public static func logPostRequest(withLog log: Log, completion: @escaping (Log) -> Void) {
        
        let logPostEndpoint = "https://www.saintsxctf.com/api/api.php/log"
        guard let url = URL(string: logPostEndpoint) else {
            os_log("Error, Cannot create URL.", log: APIClient.logTag, type: .error)
            return
        }
        
        // Convert the Log to a JSON string
        let logJSON = Mapper().toJSONString(log, prettyPrint: false)
        
        APIRequest.post(withURL: url, andJson: logJSON ?? "") {
            (json) -> Void in
            
            if let log: Log = Mapper<Log>().map(JSONString: json) {
                os_log("%@", log: APIClient.logTag, type: .debug, log.description)
                
                OperationQueue.main.addOperation {
                    completion(log)
                }
            } else {
                os_log("Log Conversion Failed.", log: APIClient.logTag, type: .error)
            }
        }
    }
    
    // Handle POST Request for a Comment
    public static func commentPostRequest(withComment comment: Comment,
                                          completion: @escaping (Comment) -> Void) {
        
        let commentPostEndpoint = "https://www.saintsxctf.com/api/api.php/comment"
        guard let url = URL(string: commentPostEndpoint) else {
            os_log("Error, Cannot create URL.", log: APIClient.logTag, type: .error)
            return
        }
        
        // Convert the Comment to a JSON string
        let commentJSON = Mapper().toJSONString(comment, prettyPrint: false)
        
        APIRequest.post(withURL: url, andJson: commentJSON ?? "") {
            (json) -> Void in
            
            if let comment: Comment = Mapper<Comment>().map(JSONString: json) {
                os_log("%@", log: APIClient.logTag, type: .debug, comment.description)
                
                OperationQueue.main.addOperation {
                    completion(comment)
                }
            } else {
                os_log("Comment Conversion Failed.", log: APIClient.logTag, type: .error)
            }
        }
    }
    
    // Handle POST Request for a Message
    public static func messagePostRequest(withMessage message: Message,
                                          completion: @escaping (Message) -> Void) {
        
        let messagePostEndpoint = "https://www.saintsxctf.com/api/api.php/message"
        guard let url = URL(string: messagePostEndpoint) else {
            os_log("Error, Cannot create URL.", log: APIClient.logTag, type: .error)
            return
        }
        
        // Convert the Comment to a JSON string
        let messageJSON = Mapper().toJSONString(message, prettyPrint: false)
        
        APIRequest.post(withURL: url, andJson: messageJSON ?? "") {
            (json) -> Void in
            
            if let message: Message = Mapper<Message>().map(JSONString: json) {
                os_log("%@", log: APIClient.logTag, type: .debug, message.description)
                
                OperationQueue.main.addOperation {
                    completion(message)
                }
            } else {
                os_log("Message Conversion Failed.", log: APIClient.logTag, type: .error)
            }
        }
    }
    
    // Handle POST Request for an Activation Code
    public static func activationCodePostRequest(withActivationCode activationCode: ActivationCode,
                                                 completion: @escaping (ActivationCode) -> Void) {
        
        let activationCodePostEndpoint = "https://www.saintsxctf.com/api/api.php/activationcode"
        guard let url = URL(string: activationCodePostEndpoint) else {
            os_log("Error, Cannot create URL.", log: APIClient.logTag, type: .error)
            return
        }
        
        // Convert the Comment to a JSON string
        let activationCodeJSON = Mapper().toJSONString(activationCode, prettyPrint: false)
        
        APIRequest.post(withURL: url, andJson: activationCodeJSON ?? "") {
            (json) -> Void in
            
            if let activationcode: ActivationCode = Mapper<ActivationCode>().map(JSONString: json) {
                os_log("%@", log: APIClient.logTag, type: .debug, activationcode.description)
                
                OperationQueue.main.addOperation {
                    completion(activationcode)
                }
            } else {
                os_log("Activation Code Conversion Failed.", log: APIClient.logTag, type: .error)
            }
        }
    }
    
    // Handle POST Request for a Notification
    public static func notificationPostRequest(withNotification notification: Notification,
                                               completion: @escaping (Notification) -> Void) {
        
        let notificationPostEndpoint = "https://www.saintsxctf.com/api/api.php/notification"
        guard let url = URL(string: notificationPostEndpoint) else {
            os_log("Error, Cannot create URL.", log: APIClient.logTag, type: .error)
            return
        }
        
        // Convert the Comment to a JSON string
        let notificationJSON = Mapper().toJSONString(notification, prettyPrint: false)
        
        APIRequest.post(withURL: url, andJson: notificationJSON ?? "") {
            (json) -> Void in
            
            if let notification: Notification = Mapper<Notification>().map(JSONString: json) {
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
    
    // Handle PUT Request for a User
    public static func userPutRequest(withUsername username: String, andUser user: User,
                                      completion: @escaping (User?) -> Void) {
        
        let usersPutEndpoint = "https://www.saintsxctf.com/api/api.php/user/\(username)"
        guard let url = URL(string: usersPutEndpoint) else {
            os_log("Error, Cannot create URL.", log: APIClient.logTag, type: .error)
            return
        }
        
        // Convert the User to a JSON string
        let userJSON = Mapper().toJSONString(user, prettyPrint: false)
        os_log("%@", log: APIClient.logTag, type: .debug, userJSON!)
        
        APIRequest.put(withURL: url, andJson: userJSON ?? "") {
            (json) -> Void in
            
            if let user: User = Mapper<User>().map(JSONString: json) {
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
    
    // Handle PUT Request for a Log
    public static func logPutRequest(withLogID logID: Int, andLog log: Log,
                                     completion: @escaping (Log) -> Void) {
        
        let logPutEndpoint = "https://www.saintsxctf.com/api/api.php/log/\(logID)"
        guard let url = URL(string: logPutEndpoint) else {
            os_log("Error, Cannot create URL.", log: APIClient.logTag, type: .error)
            return
        }
        
        // Convert the User to a JSON string
        let logJSON = Mapper().toJSONString(log, prettyPrint: false)
        
        APIRequest.put(withURL: url, andJson: logJSON ?? "") {
            (json) -> Void in
            
            if let log: Log = Mapper<Log>().map(JSONString: json) {
                os_log("%@", log: APIClient.logTag, type: .debug, log.description)
                
                OperationQueue.main.addOperation {
                    completion(log)
                }
            } else {
                os_log("Log Conversion Failed.", log: APIClient.logTag, type: .error)
            }
        }
    }
    
    // Handle PUT Request for a Group
    public static func groupPutRequest(withGroupname groupname: String, andGroup group: Group,
                                       completion: @escaping (Group) -> Void) {
        
        let groupPutEndpoint = "https://www.saintsxctf.com/api/api.php/group/\(groupname)"
        guard let url = URL(string: groupPutEndpoint) else {
            os_log("Error, Cannot create URL.", log: APIClient.logTag, type: .error)
            return
        }
        
        // Convert the User to a JSON string
        let groupJSON = Mapper().toJSONString(group, prettyPrint: false)
        
        APIRequest.put(withURL: url, andJson: groupJSON ?? "") {
            (json) -> Void in
            
            if let group: Group = Mapper<Group>().map(JSONString: json) {
                os_log("%@", log: APIClient.logTag, type: .debug, group.description)
                
                OperationQueue.main.addOperation {
                    completion(group)
                }
            } else {
                os_log("Group Conversion Failed.", log: APIClient.logTag, type: .error)
            }
        }
    }
    
    // Handle PUT Request for a Comment
    public static func commentPutRequest(withCommentId commentId: Int, andComment comment: Comment,
                                         completion: @escaping (Comment) -> Void) {
        
        let commentPutEndpoint = "https://www.saintsxctf.com/api/api.php/comment/\(commentId)"
        guard let url = URL(string: commentPutEndpoint) else {
            os_log("Error, Cannot create URL.", log: APIClient.logTag, type: .error)
            return
        }
        
        // Convert the User to a JSON string
        let commentJSON = Mapper().toJSONString(comment, prettyPrint: false)
        
        APIRequest.put(withURL: url, andJson: commentJSON ?? "") {
            (json) -> Void in
            
            if let comment: Comment = Mapper<Comment>().map(JSONString: json) {
                os_log("%@", log: APIClient.logTag, type: .debug, comment.description)
                
                OperationQueue.main.addOperation {
                    completion(comment)
                }
            } else {
                os_log("Comment Conversion Failed.", log: APIClient.logTag, type: .error)
            }
        }
    }
    
    // Handle PUT Request for a Message
    public static func messagePutRequest(withMessageId messageId: Int, andMessage message: Message,
                                         completion: @escaping (Message) -> Void) {
        
        let messagePutEndpoint = "https://www.saintsxctf.com/api/api.php/message/\(messageId)"
        guard let url = URL(string: messagePutEndpoint) else {
            os_log("Error, Cannot create URL.", log: APIClient.logTag, type: .error)
            return
        }
        
        // Convert the User to a JSON string
        let messageJSON = Mapper().toJSONString(message, prettyPrint: false)
        
        APIRequest.put(withURL: url, andJson: messageJSON ?? "") {
            (json) -> Void in
            
            if let message: Message = Mapper<Message>().map(JSONString: json) {
                os_log("%@", log: APIClient.logTag, type: .debug, message.description)
                
                OperationQueue.main.addOperation {
                    completion(message)
                }
            } else {
                os_log("Message Conversion Failed.", log: APIClient.logTag, type: .error)
            }
        }
    }
    
    // MARK: - DELETE Requests
    
    // Handle DELETE Request for a User
    public static func userDeleteRequest(withUsername username: String,
                                         completion: @escaping (Bool) -> Void) {
        
        let usersDeleteEndpoint = "https://www.saintsxctf.com/api/api.php/user/\(username)"
        guard let url = URL(string: usersDeleteEndpoint) else {
            os_log("Error, Cannot create URL.", log: APIClient.logTag, type: .error)
            return
        }
        
        APIRequest.delete(withURL: url) {
            (success) -> Void in
            
            os_log("Delete Result: %@", log: APIClient.logTag, type: .debug, String(success))
            
            OperationQueue.main.addOperation {
                completion(success)
            }
        }
    }
    
    // Handle DELETE Request for a Log
    public static func logDeleteRequest(withLogID logID: Int,
                                        completion: @escaping (Bool) -> Void) {
        
        let logDeleteEndpoint = "https://www.saintsxctf.com/api/api.php/log/\(logID)"
        guard let url = URL(string: logDeleteEndpoint) else {
            os_log("Error, Cannot create URL.", log: APIClient.logTag, type: .error)
            return
        }
        
        APIRequest.delete(withURL: url) {
            (success) -> Void in
            
            os_log("Delete Result: %@", log: APIClient.logTag, type: .debug, String(success))
            
            OperationQueue.main.addOperation {
                completion(success)
            }
        }
    }
    
    // Handle DELETE Request for a Comment
    public static func commentDeleteRequest(withCommentID commentID: Int,
                                            completion: @escaping (Bool) -> Void) {
        
        let commentDeleteEndpoint = "https://www.saintsxctf.com/api/api.php/comment/\(commentID)"
        guard let url = URL(string: commentDeleteEndpoint) else {
            os_log("Error, Cannot create URL.", log: APIClient.logTag, type: .error)
            return
        }
        
        APIRequest.delete(withURL: url) {
            (success) -> Void in
            
            os_log("Delete Result: %@", log: APIClient.logTag, type: .debug, String(success))
            
            OperationQueue.main.addOperation {
                completion(success)
            }
        }
    }
    
    // Handle DELETE Request for a Message
    public static func messageDeleteRequest(withMessageID messageID: Int,
                                            completion: @escaping (Bool) -> Void) {
        
        let messageDeleteEndpoint = "https://www.saintsxctf.com/api/api.php/message/\(messageID)"
        guard let url = URL(string: messageDeleteEndpoint) else {
            os_log("Error, Cannot create URL.", log: APIClient.logTag, type: .error)
            return
        }
        
        APIRequest.delete(withURL: url) {
            (success) -> Void in
            
            os_log("Delete Result: %@", log: APIClient.logTag, type: .debug, String(success))
            
            OperationQueue.main.addOperation {
                completion(success)
            }
        }
    }
    
    // Handle DELETE Request for a Activation Code
    public static func activationCodeDeleteRequest(withActivationCode activationCode: String,
                                                   completion: @escaping (Bool) -> Void) {
        
        let activationCodeDeleteEndpoint = "https://www.saintsxctf.com/api/api.php/"
                                            + "activationcode/\(activationCode)"
        guard let url = URL(string: activationCodeDeleteEndpoint) else {
            os_log("Error, Cannot create URL.", log: APIClient.logTag, type: .error)
            return
        }
        
        APIRequest.delete(withURL: url) {
            (success) -> Void in
            
            os_log("Delete Result: %@", log: APIClient.logTag, type: .debug, String(success))
            
            OperationQueue.main.addOperation {
                completion(success)
            }
        }
    }
    
    // Handle DELETE Request for a Notification
    public static func notificationDeleteRequest(withNotificationId notificationId: String,
                                                 completion: @escaping (Bool) -> Void) {
        
        let notificationDeleteEndpoint = "https://www.saintsxctf.com/api/api.php/"
            + "notification/\(notificationId)"
        guard let url = URL(string: notificationDeleteEndpoint) else {
            os_log("Error, Cannot create URL.", log: APIClient.logTag, type: .error)
            return
        }
        
        APIRequest.delete(withURL: url) {
            (success) -> Void in
            
            os_log("Delete Result: %@", log: APIClient.logTag, type: .debug, String(success))
            
            OperationQueue.main.addOperation {
                completion(success)
            }
        }
    }
}
