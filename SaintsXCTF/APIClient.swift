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
    public static func logGetRequest(withLogID logID: Int,
                                     completion: @escaping (Log) -> Void) {
        
        // Create the URL
        let logGetEndpoint = "https://www.saintsxctf.com/api/api.php/log/\(logID)"
        guard let url = URL(string: logGetEndpoint) else {
            print("\(logTag) Error, Cannot create URL")
            return
        }
        
        // Generate the request with a completion function to parse JSON
        APIRequest.get(withURL: url) {
            (json) -> Void in
            
            if let log: Log = Mapper<Log>().map(JSONString: json) {
                print("\(logTag) \(log)")
                
                OperationQueue.main.addOperation {
                    completion(log)
                }
            } else {
                print("\(logTag) Log Conversion Failed.")
            }
        }
    }
    
    // Handle GET Requests for all Logs
    public static func logsGetRequest(completion: @escaping ([Log]) -> Void) {
        
        let logsGetEndpoint = "https://www.saintsxctf.com/api/api.php/logs"
        guard let url = URL(string: logsGetEndpoint) else {
            print("\(logTag) Error, Cannot create URL")
            return
        }
        
        APIRequest.get(withURL: url) {
            (json) -> Void in
            
            if let logs: Array<Log> = Mapper<Log>().mapArray(JSONString: json) {
                print("\(logTag) \(logs)")
                
                OperationQueue.main.addOperation {
                    completion(logs)
                }
            } else {
                print("\(logTag) Log Conversion Failed.")
            }
        }
    }
    
    // Handle GET Requests for a Group
    public static func groupGetRequest(withGroupname groupname: String,
                                       completion: @escaping (Group) -> Void) {
        
        // Create the URL
        let groupGetEndpoint = "https://www.saintsxctf.com/api/api.php/group/\(groupname)"
        guard let url = URL(string: groupGetEndpoint) else {
            print("\(logTag) Error, Cannot create URL")
            return
        }
        
        APIRequest.get(withURL: url) {
            (json) -> Void in
            
            if let group: Group = Mapper<Group>().map(JSONString: json) {
                print("\(logTag) \(group)")
                
                OperationQueue.main.addOperation {
                    completion(group)
                }
            } else {
                print("\(logTag) Group Conversion Failed.")
            }
        }
    }
    
    // Handle GET Requests for all Groups
    public static func groupsGetRequest(completion: @escaping ([Group]) -> Void) {
        
        let groupsGetEndpoint = "https://www.saintsxctf.com/api/api.php/groups"
        guard let url = URL(string: groupsGetEndpoint) else {
            print("\(logTag) Error, Cannot create URL")
            return
        }
        
        APIRequest.get(withURL: url) {
            (json) -> Void in
            
            if let groups: Array<Group> = Mapper<Group>().mapArray(JSONString: json) {
                print("\(logTag) \(groups)")
                
                OperationQueue.main.addOperation {
                    completion(groups)
                }
            } else {
                print("\(logTag) Groups Conversion Failed.")
            }
        }
    }
    
    // Handle GET Requests for a Comment
    public static func commentGetRequest(withCommentId commentId: Int,
                                         completion: @escaping (Comment) -> Void) {
        
        // Create the URL
        let commentGetEndpoint = "https://www.saintsxctf.com/api/api.php/comment/\(commentId)"
        guard let url = URL(string: commentGetEndpoint) else {
            print("\(logTag) Error, Cannot create URL")
            return
        }
        
        APIRequest.get(withURL: url) {
            (json) -> Void in
            
            if let comment: Comment = Mapper<Comment>().map(JSONString: json) {
                print("\(logTag) \(comment)")
                
                OperationQueue.main.addOperation {
                    completion(comment)
                }
            } else {
                print("\(logTag) Comment Conversion Failed.")
            }
        }
    }
    
    // Handle GET Requests for all Comments
    public static func commentsGetRequest(completion: @escaping ([Comment]) -> Void) {
        
        let commentsGetEndpoint = "https://www.saintsxctf.com/api/api.php/comments"
        guard let url = URL(string: commentsGetEndpoint) else {
            print("\(logTag) Error, Cannot create URL")
            return
        }
        
        APIRequest.get(withURL: url) {
            (json) -> Void in
            
            if let comments: Array<Comment> = Mapper<Comment>().mapArray(JSONString: json) {
                print("\(logTag) \(comments)")
                
                OperationQueue.main.addOperation {
                    completion(comments)
                }
            } else {
                print("\(logTag) Comments Conversion Failed.")
            }
        }
    }
    
    // Handle GET Requests for a Message
    public static func messageGetRequest(withMessageId messageId: Int,
                                         completion: @escaping (Message) -> Void) {
        
        // Create the URL
        let messageGetEndpoint = "https://www.saintsxctf.com/api/api.php/message/\(messageId)"
        guard let url = URL(string: messageGetEndpoint) else {
            print("\(logTag) Error, Cannot create URL")
            return
        }
        
        APIRequest.get(withURL: url) {
            (json) -> Void in
            
            if let message: Message = Mapper<Message>().map(JSONString: json) {
                print("\(logTag) \(message)")
                
                OperationQueue.main.addOperation {
                    completion(message)
                }
            } else {
                print("\(logTag) Message Conversion Failed.")
            }
        }
    }
    
    // Handle GET Requests for all Messages
    public static func messagesGetRequest(completion: @escaping ([Message]) -> Void) {
        
        let messagesGetEndpoint = "https://www.saintsxctf.com/api/api.php/messages"
        guard let url = URL(string: messagesGetEndpoint) else {
            print("\(logTag) Error, Cannot create URL")
            return
        }
        
        APIRequest.get(withURL: url) {
            (json) -> Void in
            
            if let messages: Array<Message> = Mapper<Message>().mapArray(JSONString: json) {
                print("\(logTag) \(messages)")
                
                OperationQueue.main.addOperation {
                    completion(messages)
                }
            } else {
                print("\(logTag) Messages Conversion Failed.")
            }
        }
    }
    
    // Handle GET Requests for an Activation Code
    public static func activationCodeGetRequest(withCode code: String,
                                                completion: @escaping (ActivationCode) -> Void) {
        
        // Create the URL
        let activationCodeGetEndpoint = "https://www.saintsxctf.com/api/api.php/activationcode/\(code)"
        guard let url = URL(string: activationCodeGetEndpoint) else {
            print("\(logTag) Error, Cannot create URL")
            return
        }
        
        APIRequest.get(withURL: url) {
            (json) -> Void in
            
            if let activationcode: ActivationCode = Mapper<ActivationCode>().map(JSONString: json) {
                print("\(logTag) \(activationcode)")
                
                OperationQueue.main.addOperation {
                    completion(activationcode)
                }
            } else {
                print("\(logTag) Activation Code Conversion Failed.")
            }
        }
    }
    
    // Handle GET Requests for a Notification
    public static func notificationGetRequest(withNotificationId notificationId: Int,
                                              completion: @escaping (Notification) -> Void) {
        
        // Create the URL
        let notificationGetEndpoint = "https://www.saintsxctf.com/api/api.php/notification/\(notificationId)"
        guard let url = URL(string: notificationGetEndpoint) else {
            print("\(logTag) Error, Cannot create URL")
            return
        }
        
        APIRequest.get(withURL: url) {
            (json) -> Void in
            
            if let notification: Notification = Mapper<Notification>().map(JSONString: json) {
                print("\(logTag) \(notification)")
                
                OperationQueue.main.addOperation {
                    completion(notification)
                }
            } else {
                print("\(logTag) Notification Conversion Failed.")
            }
        }
    }
    
    // Handle GET Requests for all Notifications
    public static func notificationsGetRequest(completion: @escaping ([Notification]) -> Void) {
        
        let notificationsGetEndpoint = "https://www.saintsxctf.com/api/api.php/notifications"
        guard let url = URL(string: notificationsGetEndpoint) else {
            print("\(logTag) Error, Cannot create URL")
            return
        }
        
        APIRequest.get(withURL: url) {
            (json) -> Void in
            
            if let notifications: Array<Notification> = Mapper<Notification>().mapArray(JSONString: json) {
                print("\(logTag) \(notifications)")
                
                OperationQueue.main.addOperation {
                    completion(notifications)
                }
            } else {
                print("\(logTag) Notifications Conversion Failed.")
            }
        }
    }
    
    // Handle GET Requests for a Log Feed
    public static func logfeedGetRequest(withParamType paramType: String, sortParam: String,
                                         limit: Int, offset: Int, completion: @escaping ([Log]) -> Void) {
        
        let logfeedGetEndpoint = "https://www.saintsxctf.com/api/api.php/logfeed/"
            + "\(paramType)/\(sortParam)/\(limit)/\(offset)"
        guard let url = URL(string: logfeedGetEndpoint) else {
            print("\(logTag) Error, Cannot create URL")
            return
        }
        
        APIRequest.get(withURL: url) {
            (json) -> Void in
            
            if let logfeed: Array<Log> = Mapper<Log>().mapArray(JSONString: json) {
                print("\(logTag) \(logfeed)")
                
                OperationQueue.main.addOperation {
                    completion(logfeed)
                }
            } else {
                print("\(logTag) Log Feed Conversion Failed.")
            }
        }
    }
    
    // Handle GET Requests for a Message Feed
    public static func messagefeedGetRequest(withParamType paramType: String, sortParam: String,
                                             limit: Int, offset: Int, completion: @escaping ([Message]) -> Void) {
        
        let messagefeedGetEndpoint = "https://www.saintsxctf.com/api/api.php/messagefeed/"
            + "\(paramType)/\(sortParam)/\(limit)/\(offset)"
        guard let url = URL(string: messagefeedGetEndpoint) else {
            print("\(logTag) Error, Cannot create URL")
            return
        }
        
        APIRequest.get(withURL: url) {
            (json) -> Void in
            
            if let messagefeed: Array<Message> = Mapper<Message>().mapArray(JSONString: json) {
                print("\(logTag) \(messagefeed)")
                
                OperationQueue.main.addOperation {
                    completion(messagefeed)
                }
            } else {
                print("\(logTag) Message Feed Conversion Failed.")
            }
        }
    }
    
    // Handle GET Requests for a Range View
    public static func rangeViewGetRequest(withParamType paramType: String, sortParam: String,
                                           start: Int, end: Int, completion: @escaping ([RangeView]) -> Void) {
        
        let rangeviewGetEndpoint = "https://www.saintsxctf.com/api/api.php/rangeview/"
            + "\(paramType)/\(sortParam)/\(start)/\(end)"
        guard let url = URL(string: rangeviewGetEndpoint) else {
            print("\(logTag) Error, Cannot create URL")
            return
        }
        
        APIRequest.get(withURL: url) {
            (json) -> Void in
            
            if let rangeview: Array<RangeView> = Mapper<RangeView>().mapArray(JSONString: json) {
                print("\(logTag) \(rangeview)")
                
                OperationQueue.main.addOperation {
                    completion(rangeview)
                }
            } else {
                print("\(logTag) Range View Conversion Failed.")
            }
        }
    }
    
    // MARK: - POST Requests
    
    // Handle POST Request for a User
    public static func userPostRequest(withUser user: User, completion: @escaping (User) -> Void) {
        
        let usersPostEndpoint = "https://www.saintsxctf.com/api/api.php/users"
        guard let url = URL(string: usersPostEndpoint) else {
            print("\(logTag) Error, Cannot create URL")
            return
        }
        
        APIRequest.post(withURL: url, andObject: user) {
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
    
    // Handle POST Request for a Log
    public static func logPostRequest(withLog log: Log, completion: @escaping (Log) -> Void) {
        
        let logPostEndpoint = "https://www.saintsxctf.com/api/api.php/log"
        guard let url = URL(string: logPostEndpoint) else {
            print("\(logTag) Error, Cannot create URL")
            return
        }
        
        APIRequest.post(withURL: url, andObject: log) {
            (json) -> Void in
            
            if let log: Log = Mapper<Log>().map(JSONString: json) {
                print("\(logTag) \(log)")
                
                OperationQueue.main.addOperation {
                    completion(log)
                }
            } else {
                print("\(logTag) Log Conversion Failed.")
            }
        }
    }
    
    // Handle POST Request for a Comment
    public static func commentPostRequest(withComment comment: Comment,
                                          completion: @escaping (Comment) -> Void) {
        
        let commentPostEndpoint = "https://www.saintsxctf.com/api/api.php/comment"
        guard let url = URL(string: commentPostEndpoint) else {
            print("\(logTag) Error, Cannot create URL")
            return
        }
        
        APIRequest.post(withURL: url, andObject: comment) {
            (json) -> Void in
            
            if let comment: Comment = Mapper<Comment>().map(JSONString: json) {
                print("\(logTag) \(comment)")
                
                OperationQueue.main.addOperation {
                    completion(comment)
                }
            } else {
                print("\(logTag) Comment Conversion Failed.")
            }
        }
    }
    
    // Handle POST Request for a Message
    public static func messagePostRequest(withMessage message: Message,
                                          completion: @escaping (Message) -> Void) {
        
        let messagePostEndpoint = "https://www.saintsxctf.com/api/api.php/message"
        guard let url = URL(string: messagePostEndpoint) else {
            print("\(logTag) Error, Cannot create URL")
            return
        }
        
        APIRequest.post(withURL: url, andObject: message) {
            (json) -> Void in
            
            if let message: Message = Mapper<Message>().map(JSONString: json) {
                print("\(logTag) \(message)")
                
                OperationQueue.main.addOperation {
                    completion(message)
                }
            } else {
                print("\(logTag) Message Conversion Failed.")
            }
        }
    }
    
    // Handle POST Request for an Activation Code
    public static func activationCodePostRequest(withActivationCode activationCode: ActivationCode,
                                                 completion: @escaping (ActivationCode) -> Void) {
        
        let activationCodePostEndpoint = "https://www.saintsxctf.com/api/api.php/activationcode"
        guard let url = URL(string: activationCodePostEndpoint) else {
            print("\(logTag) Error, Cannot create URL")
            return
        }
        
        APIRequest.post(withURL: url, andObject: activationCode) {
            (json) -> Void in
            
            if let activationcode: ActivationCode = Mapper<ActivationCode>().map(JSONString: json) {
                print("\(logTag) \(activationcode)")
                
                OperationQueue.main.addOperation {
                    completion(activationcode)
                }
            } else {
                print("\(logTag) Activation Code Conversion Failed.")
            }
        }
    }
    
    // Handle POST Request for a Notification
    public static func notificationPostRequest(withNotification notification: Notification,
                                               completion: @escaping (Notification) -> Void) {
        
        let notificationPostEndpoint = "https://www.saintsxctf.com/api/api.php/notification"
        guard let url = URL(string: notificationPostEndpoint) else {
            print("\(logTag) Error, Cannot create URL")
            return
        }
        
        APIRequest.post(withURL: url, andObject: notification) {
            (json) -> Void in
            
            if let notification: Notification = Mapper<Notification>().map(JSONString: json) {
                print("\(logTag) \(notification)")
                
                OperationQueue.main.addOperation {
                    completion(notification)
                }
            } else {
                print("\(logTag) Notifications Conversion Failed.")
            }
        }
    }
    
    // MARK: - PUT Requests
    
    // Handle PUT Request for a User
    public static func userPutRequest(withUsername username: String, andUser user: User,
                                      completion: @escaping (User) -> Void) {
        
        let usersPutEndpoint = "https://www.saintsxctf.com/api/api.php/user/\(username)"
        guard let url = URL(string: usersPutEndpoint) else {
            print("\(logTag) Error, Cannot create URL")
            return
        }
        
        APIRequest.put(withURL: url, andObject: user) {
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
    
    // Handle PUT Request for a Log
    public static func logPutRequest(withLogID logID: Int, andLog log: Log,
                                     completion: @escaping (Log) -> Void) {
        
        let logPutEndpoint = "https://www.saintsxctf.com/api/api.php/log/\(logID)"
        guard let url = URL(string: logPutEndpoint) else {
            print("\(logTag) Error, Cannot create URL")
            return
        }
        
        APIRequest.put(withURL: url, andObject: log) {
            (json) -> Void in
            
            if let log: Log = Mapper<Log>().map(JSONString: json) {
                print("\(logTag) \(log)")
                
                OperationQueue.main.addOperation {
                    completion(log)
                }
            } else {
                print("\(logTag) Log Conversion Failed.")
            }
        }
    }
    
    // Handle PUT Request for a Group
    public static func groupPutRequest(withGroupname groupname: String, andGroup group: Group,
                                       completion: @escaping (Group) -> Void) {
        
        let groupPutEndpoint = "https://www.saintsxctf.com/api/api.php/group/\(groupname)"
        guard let url = URL(string: groupPutEndpoint) else {
            print("\(logTag) Error, Cannot create URL")
            return
        }
        
        APIRequest.put(withURL: url, andObject: group) {
            (json) -> Void in
            
            if let group: Group = Mapper<Group>().map(JSONString: json) {
                print("\(logTag) \(group)")
                
                OperationQueue.main.addOperation {
                    completion(group)
                }
            } else {
                print("\(logTag) Group Conversion Failed.")
            }
        }
    }
    
    // Handle PUT Request for a Comment
    public static func commentPutRequest(withCommentId commentId: Int, andComment comment: Comment,
                                         completion: @escaping (Comment) -> Void) {
        
        let commentPutEndpoint = "https://www.saintsxctf.com/api/api.php/comment/\(commentId)"
        guard let url = URL(string: commentPutEndpoint) else {
            print("\(logTag) Error, Cannot create URL")
            return
        }
        
        APIRequest.put(withURL: url, andObject: comment) {
            (json) -> Void in
            
            if let comment: Comment = Mapper<Comment>().map(JSONString: json) {
                print("\(logTag) \(comment)")
                
                OperationQueue.main.addOperation {
                    completion(comment)
                }
            } else {
                print("\(logTag) Comment Conversion Failed.")
            }
        }
    }
    
    // Handle PUT Request for a Message
    public static func messagePutRequest(withMessageId messageId: Int, andMessage message: Message,
                                         completion: @escaping (Message) -> Void) {
        
        let messagePutEndpoint = "https://www.saintsxctf.com/api/api.php/message/\(messageId)"
        guard let url = URL(string: messagePutEndpoint) else {
            print("\(logTag) Error, Cannot create URL")
            return
        }
        
        APIRequest.put(withURL: url, andObject: message) {
            (json) -> Void in
            
            if let message: Message = Mapper<Message>().map(JSONString: json) {
                print("\(logTag) \(message)")
                
                OperationQueue.main.addOperation {
                    completion(message)
                }
            } else {
                print("\(logTag) Message Conversion Failed.")
            }
        }
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
