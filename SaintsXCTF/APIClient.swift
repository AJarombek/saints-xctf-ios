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
    
    // MARK: - GET Requests
    
    /**
     Handle GET Requests for a User
     - parameters:
     - username: the username of a user to retrieve
     - completion:  Callback function which is invoked once the GET request is fulfilled
     */
    public static func userGetRequest(withUsername username: String,
                                      completion: @escaping (User) -> Void) {
        
        // Create the URL
        let userGetEndpoint = "https://www.saintsxctf.com/api/api.php/users/\(username)"
        guard let url = URL(string: userGetEndpoint) else {
            os_log("Error, Cannot create URL.", log: APIClient.logTag, type: .error)
            OperationQueue.main.addOperation {
                completion(User())
            }
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
    
    /**
     Handle a GET request for all Users in the database
     - parameters:
     - completion:  Callback function which is invoked once the GET request is fulfilled
     */
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
    
    /**
     Handle GET Requests for an exercise Log
     - parameters:
     - logID: a unique identifier for an exercise log
     - completion:  Callback function which is invoked once the GET request is fulfilled
     */
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
    
    /**
     Handle a GET Request for all Logs in the database
     - parameters:
     - completion:  Callback function which is invoked once the GET request is fulfilled
     */
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
    
    /**
     Handle GET Requests for a Group
     - parameters:
     - groupname: a unique name for a group
     - completion:  Callback function which is invoked once the GET request is fulfilled
     */
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
    
    /**
     Handle a GET Request for all the Groups in the database
     - parameters:
     - completion:  Callback function which is invoked once the GET request is fulfilled
     */
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
    
    /**
     Handle GET Requests for a Comment
     - parameters:
     - commentId: a unique identifer for a comment
     - completion:  Callback function which is invoked once the GET request is fulfilled
     */
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
    
    /**
     Handle a GET Request for all the comments in the database
     - parameters:
     - completion:  Callback function which is invoked once the GET request is fulfilled
     */
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
    
    /**
     Handle GET Requests for a Message
     - parameters:
     - messageId: a unique identifer for a message
     - completion:  Callback function which is invoked once the GET request is fulfilled
     */
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
    
    /**
     Handle a GET Request for all the messages in the database
     - parameters:
     - completion:  Callback function which is invoked once the GET request is fulfilled
     */
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
    
    /**
     Handle GET Requests for an Activation Code
     - parameters:
     - code: a unique code to activate an account
     - completion:  Callback function which is invoked once the GET request is fulfilled
     */
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
    
    /**
     Handle GET Requests for a Notification
     - parameters:
     - notificationId: a unique identifer for a notification
     - completion:  Callback function which is invoked once the GET request is fulfilled
     */
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
    
    /**
     Handle a GET Request for all the notifications in the database
     - parameters:
     - completion:  Callback function which is invoked once the GET request is fulfilled
     */
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
    
    /**
     Handle GET Requests for a Log Feed
     - parameters:
     - paramType: the grouping of logs to return (ex. user, group)
     - sortParam: a string to query the param type.  For example, if the paramType is user, the sortParam can
     be the username of a user
     - limit: the maximum number of logs to return
     - offset: not the rapper
     - completion:  Callback function which is invoked once the GET request is fulfilled
     */
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
    
    /**
     Handle GET Requests for a Message Feed
     - parameters:
     - paramType: the grouping of messages to return (ex. group, all)
     - sortParam: a string to query the param type.  For example, if the paramType is group, the sortParam can
     be the group name
     - limit: the maximum number of messages to return
     - offset: not the rapper
     - completion:  Callback function which is invoked once the GET request is fulfilled
     */
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
     - completion:  Callback function which is invoked once the GET request is fulfilled
     */
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
     - completion:  Callback function which is invoked once the POST request is fulfilled
     */
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
    
    /**
     Handle POST Requests for a Log
     - parameters:
     - log: an object representing the exercie log to create on the server
     - completion:  Callback function which is invoked once the POST request is fulfilled
     */
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
    
    /**
     Handle POST Requests for a Comment
     - parameters:
     - comment: an object representing the comment to create on the server
     - completion:  Callback function which is invoked once the POST request is fulfilled
     */
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
    
    /**
     Handle POST Requests for a Message
     - parameters:
     - message: an object representing the message to create on the server
     - completion:  Callback function which is invoked once the POST request is fulfilled
     */
    public static func messagePostRequest(withMessage message: Message,
                                          completion: @escaping (Message) -> Void) {
        
        let messagePostEndpoint = "https://www.saintsxctf.com/api/api.php/message"
        guard let url = URL(string: messagePostEndpoint) else {
            os_log("Error, Cannot create URL.", log: APIClient.logTag, type: .error)
            return
        }
        
        // Convert the Message to a JSON string
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
    
    /**
     Handle POST Requests for an Activation Code
     - parameters:
     - completion:  Callback function which is invoked once the POST request is fulfilled
     */
    public static func activationCodePostRequest(completion: @escaping (ActivationCode?) -> Void) {
        
        let activationCodePostEndpoint = "https://www.saintsxctf.com/api/api.php/activationcode"
        guard let url = URL(string: activationCodePostEndpoint) else {
            os_log("Error, Cannot create URL.", log: APIClient.logTag, type: .error)
            return
        }
        
        APIRequest.post(withURL: url, andJson: "") {
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
     Handle POST Requests for a Notification
     - parameters:
     - notification: an object representing the notification to create on the server
     - completion:  Callback function which is invoked once the POST request is fulfilled
     */
    public static func notificationPostRequest(withNotification notification: Notification,
                                               completion: @escaping (Notification) -> Void) {
        
        let notificationPostEndpoint = "https://www.saintsxctf.com/api/api.php/notification"
        guard let url = URL(string: notificationPostEndpoint) else {
            os_log("Error, Cannot create URL.", log: APIClient.logTag, type: .error)
            return
        }
        
        // Convert the Notification to a JSON string
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
    
    /**
     Handle POST Requests for an Email
     - parameters:
     - mail: an object representing the email to send to an address
     - completion:  Callback function which is invoked once the POST request is fulfilled
     */
    public static func mailPostRequest(withMail mail: Mail,
                                               completion: @escaping (Mail?) -> Void) {
        
        let mailPostEndpoint = "https://www.saintsxctf.com/api/api.php/mail"
        guard let url = URL(string: mailPostEndpoint) else {
            os_log("Error, Cannot create URL.", log: APIClient.logTag, type: .error)
            return
        }
        
        // Convert the Mail to a JSON string
        let mailJSON = Mapper().toJSONString(mail, prettyPrint: false)
        
        APIRequest.post(withURL: url, andJson: mailJSON ?? "") {
            (json) -> Void in
                
            OperationQueue.main.addOperation {
                completion(mail)
            }
        }
    }
    
    // MARK: - PUT Requests
    
    /**
     Handle PUT Requests for a User
     - parameters:
     - username: the username of an existing user on the server
     - user: an object representing the updated user to reflect on the server
     - completion:  Callback function which is invoked once the PUT request is fulfilled
     */
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
    
    /**
     Handle PUT Requests for a Log
     - parameters:
     - logID: the unique logId of an existing log on the server
     - log: an object representing the updated log to reflect on the server
     - completion:  Callback function which is invoked once the PUT request is fulfilled
     */
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
    
    /**
     Handle PUT Requests for a Group
     - parameters:
     - groupname: the groupname of an existing group on the server
     - group: an object representing the updated group to reflect on the server
     - completion:  Callback function which is invoked once the PUT request is fulfilled
     */
    public static func groupPutRequest(withGroupname groupname: String, andGroup group: Group,
                                       completion: @escaping (Group?) -> Void) {
        
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
     - completion:  Callback function which is invoked once the PUT request is fulfilled
     */
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
    
    /**
     Handle PUT Requests for a Message
     - parameters:
     - messageId: the unqiue message identifier for an existing message on the server
     - message: an object representing the updated message to reflect on the server
     - completion:  Callback function which is invoked once the PUT request is fulfilled
     */
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
    
    /**
     Handle DELETE Requests for a User
     - parameters:
     - username: the username of an existing user on the server
     - completion:  Callback function which is invoked once the DELETE request is fulfilled
     */
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
    
    /**
     Handle DELETE Requests for a Log
     - parameters:
     - logID: the unique log identifier of an existing log on the server
     - completion:  Callback function which is invoked once the DELETE request is fulfilled
     */
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
    
    /**
     Handle DELETE Requests for a Comment
     - parameters:
     - commentID: the unique comment identifier for an existing comment on the server
     - completion:  Callback function which is invoked once the DELETE request is fulfilled
     */
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
    
    /**
     Handle DELETE Requests for a Message
     - parameters:
     - messageID: the unique message identifier of an existing message on the server
     - completion:  Callback function which is invoked once the DELETE request is fulfilled
     */
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
    
    /**
     Handle DELETE Requests for an Activation Code
     - parameters:
     - activationCode: the existing activation code on the server
     - completion:  Callback function which is invoked once the DELETE request is fulfilled
     */
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
    
    /**
     Handle DELETE Requests for a Notification
     - parameters:
     - notificationId: the unique notification identifier of an existing notification on the server
     - completion:  Callback function which is invoked once the DELETE request is fulfilled
     */
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
