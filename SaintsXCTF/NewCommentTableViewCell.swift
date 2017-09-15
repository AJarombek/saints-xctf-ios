//
//  NewCommentTableViewCell.swift
//  SaintsXCTF
//
//  Created by Andy Jarombek on 8/31/17.
//  Copyright © 2017 Andy Jarombek. All rights reserved.
//

import UIKit
import os.log

class NewCommentTableViewCell: UITableViewCell {
    
    let logTag = OSLog(subsystem: "SaintsXCTF.App.NewCommentTableViewCell", category: "NewCommentTableViewCell")
    
    @IBOutlet weak var commentField: UITextField!
    var log: Log?
    var commentVC: CommentViewController?
    
    // Function runs when the return button is clicked
    @IBAction func commentPrimaryActionTriggered(_ sender: Any) {
        os_log("Adding Comment to %@", log: logTag, type: .debug, log?.description ?? "nil")
        
        let comment = Comment()
        
        // Make sure that the comment content exists and log is valid
        if let commentContent: String = commentField.text?.trimmingCharacters(in: .whitespaces),
            let commentLog: Log = log {
            
            if commentContent != "" {
                
                let user: User = SignedInUser.user
                
                // Build the new comment
                comment.content = commentContent
                comment.log_id = commentLog.log_id
                comment.username = user.username
                comment.first = user.first
                comment.last = user.last
                
                // Send a request to the API to create a new comment on this log
                APIClient.commentPostRequest(withComment: comment) {
                    (newcomment) -> Void in
                    
                    os_log("New Comment Created: %@", log: self.logTag, type: .debug, newcomment.description)
                    
                    // Append the comment to the log, comments object, update the log in the view controller
                    // And reload the cells in the comment table view
                    self.log?.comments.insert(newcomment, at: 0)
                    self.commentVC?.comments?.insert(newcomment, at: 0)
                    self.commentVC?.log = self.log
                    self.commentVC?.commentTableView.reloadData()
                    
                    // Reset the comment text field
                    self.commentField.text = ""
                    
                    // If the commenter isnt also the log owner, send the owner a notification
                    let logUsername: String = self.log?.username ?? ""
                    
                    if newcomment.username != logUsername {
                        
                        let logId = self.log?.log_id ?? ""
                        let first = newcomment.first ?? ""
                        let last = newcomment.last ?? ""
                        
                        // Build the notification
                        let notification = Notification()
                        notification.username = logUsername
                        notification.link = "https://www.saintsxctf.com/log.php?logno=\(logId)"
                        notification.notification_description = "\(first) \(last) Commented on Your Log."
                        notification.viewed = "N"
                        
                        self.commentNotification(notification)
                    }
                }
                
            } else {
                os_log("Error: Empty Comment Supplied", log: logTag, type: .error)
            }
            
        } else {
            os_log("Error: Comment Content or Log are Invalid", log: logTag, type: .error)
        }
    }
    
    // Make an API Request to create a new notification
    func commentNotification(_ notification: Notification) {
        
        APIClient.notificationPostRequest(withNotification: notification) {
            (newnotification) -> Void in
            
            os_log("New Notification Sent: %@", log: self.logTag, type: .debug, newnotification.description)
        }
    }
}
