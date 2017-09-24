//
//  LogTableViewCell.swift
//  SaintsXCTF
//
//  Created by Andy Jarombek on 8/26/17.
//  Copyright © 2017 Andy Jarombek. All rights reserved.
//

import UIKit
import os.log
import PopupDialog

class LogTableViewCell: UITableViewCell {
    
    let logTag = OSLog(subsystem: "SaintsXCTF.App.LogTableViewCell", category: "LogTableViewCell")
    var mainViewController: MainViewController? = nil
    var log: Log? = nil
    var index: Int? = nil
    
    @IBOutlet weak var userLabel: UITextView!
    @IBOutlet weak var dateLabel: UITextView!
    @IBOutlet weak var nameLabel: UITextView!
    @IBOutlet weak var typeLabel: UITextView!
    @IBOutlet weak var descriptionLabel: UITextView!
    @IBOutlet weak var commentsButton: UIButton!
    @IBOutlet weak var deleteButton: UIButton!
    @IBOutlet weak var editButton: UIButton!
    
    // Add padding to the cell
    override var frame: CGRect {
        get {
            return super.frame
        }
        set {
            var frame = newValue
            frame.origin.x += 2
            frame.size.width -= 4
            
            frame.origin.y += 2
            frame.size.height -= 4
            
            super.frame = frame
        }
    }
    
    // Called when the cell is about to be reused.  Reset all of the text fields
    override func prepareForReuse() {
        super.prepareForReuse()
        
        userLabel.text = ""
        dateLabel.text = ""
        nameLabel.text = ""
        typeLabel.text = ""
        descriptionLabel.text = ""
    }
    
    // Set the style of the cell with a background color determined by the log feel
    func setStyle(withFeel feel: Int) {
        self.layer.borderWidth = 2
        self.layer.borderColor = UIColor(0xAAAAAA).cgColor
        self.layer.cornerRadius = 1
        self.backgroundColor = UIColor(Constants.getFeelColor(feel - 1))
    }
    
    func editLog(sender: LogTableViewCell) {
        os_log("Pressed Edit", log: logTag, type: .debug)
    }
    
    func deleteLog(sender: UIButton) {
        os_log("Pressed Delete", log: logTag, type: .debug)
        
        // Build the popup dialog to be displayed
        let title = "Delete Log"
        let message = "Are you sure you would like to permanently delete this log?"
        
        // Actions to do when cancelling the delete log operation
        let cancelButton = CancelButton(title: "Cancel") {
            os_log("Cancelled Deleting Log.", log: self.logTag, type: .debug)
        }
        
        // Actions to do when deleting a log
        let deleteButton = DefaultButton(title: "Delete") {
            os_log("Confirm Deleting Log: %@", log: self.logTag, type: .debug, self.log?.description ?? "")
            
            if let log_id: String = self.log?.log_id {
                APIClient.logDeleteRequest(withLogID: Int(log_id)!) {
                    (result) -> Void in
                    
                    if result {
                        if let i = self.index {
                            self.mainViewController?.removeDeletedLog(at: i)
                            os_log("Successfully Deleted Log: ", log: self.logTag, type: .error)
                        } else {
                            os_log("Failed to Delete Log: Invalid Index", log: self.logTag, type: .error)
                        }
                    } else {
                        os_log("Failed to Delete Log: API Call Failed", log: self.logTag, type: .error)
                    }
                }
            }
        }
        
        let popup = PopupDialog(title: title, message: message)
        popup.addButtons([cancelButton, deleteButton])
        
        mainViewController?.present(popup, animated: true, completion: nil)
    }
}
