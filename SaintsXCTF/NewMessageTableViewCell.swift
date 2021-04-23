//
//  NewMessageTableViewCell.swift
//  SaintsXCTF
//
//  Created by Andy Jarombek on 10/11/17.
//  Copyright © 2017 Andy Jarombek. All rights reserved.
//

import UIKit
import os.log

/**
 Class representing a cell in the messages table view.  Provides an input text field to create a new message
 for group members to see.
 - Important:
 ## Extends the following class:
 - UITableViewCell: provides methods for managing a table view cell
 */
class NewMessageTableViewCell: UITableViewCell {
    
    let logTag = OSLog(subsystem: "SaintsXCTF.App.NewMessageTableViewCell", category: "NewMessageTableViewCell")
    
    @IBOutlet weak var messageField: UITextField!
    var group: Group?
    var messageVC: MessageViewController?
    
    /**
     Function runs when the return button is clicked.  Creates the new message.
     - parameters:
     - sender: the action that triggers this method (return button click)
     */
    @IBAction func commentPrimaryActionTriggered(_ sender: Any) {
        os_log("Adding Message to %@", log: logTag, type: .debug, group?.description ?? "nil")
        
        let message = Message()
        
        // Make sure that the message content exists and group is valid
        if let messageContent: String = messageField.text?.trimmingCharacters(in: .whitespaces),
            let groupInput: Group = group {
            
            if messageContent != "" {
                
                let user: User = SignedInUser.user
                
                // Build the new message
                message.content = messageContent
                message.group_name = groupInput.group_name
                message.username = user.username
                message.first = user.first
                message.last = user.last
                
                // Send a request to the API to create a new message on this group
                APIClient.messagePostRequest(withMessage: message, fromController: self.parentContainerViewController()) {
                    (newmessage) -> Void in
                    
                    os_log("New Message Created: %@", log: self.logTag, type: .debug, newmessage.description)
                    
                    // Append the message to the view controller and reload the cells in the message table view
                    self.messageVC?.messages.insert(newmessage, at: 0)
                    self.messageVC?.messageTableView.reloadData()
                    
                    // Reset the message text field
                    self.messageField.text = ""
                    
                    let grouptitle: String = self.group?.group_title ?? ""
                    let groupname: String = self.group?.group_name ?? ""
                    let first = newmessage.first ?? ""
                    let last = newmessage.last ?? ""
                    let members: [GroupMember] = self.group?.members ?? [GroupMember]()
                    
                    // Send a notification to each of the members of the group
                    members.forEach {
                        member -> Void in
                        
                        // Build the notification
                        let notification = Notification()
                        notification.username = member.username!
                        notification.link = "https://www.saintsxctf.com/group.php?name=\(groupname)"
                        notification.notification_description = "\(first) \(last) Sent a Message in \(grouptitle)."
                        notification.viewed = "N"
                        
                        self.messageNotification(notification)
                    }
                }
                
            } else {
                os_log("Error: Empty Message Supplied", log: logTag, type: .error)
            }
            
        } else {
            os_log("Error: Message Content or Group are Invalid", log: logTag, type: .error)
        }
    }
    
    /**
     Make an API Request to create a new message notification.
     - parameters:
     - notification: a notification object to send to a group member
     */
    func messageNotification(_ notification: Notification) {
        
        APIClient.notificationPostRequest(withNotification: notification, fromController: self.parentContainerViewController()) {
            (newnotification) -> Void in
            
            os_log("New Notification Sent: %@", log: self.logTag, type: .debug, newnotification.description)
        }
    }
}
