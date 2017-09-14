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
                    self.log?.comments.append(newcomment)
                    self.commentVC?.comments?.append(newcomment)
                    self.commentVC?.log = self.log
                    self.commentVC?.commentTableView.reloadData()
                }
                
            } else {
                os_log("Error: Empty Comment Supplied", log: logTag, type: .error)
            }
            
        } else {
            os_log("Error: Comment Content or Log are Invalid", log: logTag, type: .error)
        }
    }
}
