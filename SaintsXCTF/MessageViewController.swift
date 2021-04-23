//
//  MessageViewController.swift
//  SaintsXCTF
//
//  Created by Andy Jarombek on 10/11/17.
//  Copyright © 2017 Andy Jarombek. All rights reserved.
//

import UIKit
import os.log

/**
 Controller for the group messages.
 - Important:
 ## Extends the following class:
 - UITableViewController: view controller for managing a table view
 */
class MessageViewController: UITableViewController {
    
    @IBOutlet weak var messageTableView: UITableView!
    
    let logTag = OSLog(subsystem: "SaintsXCTF.App.MessageViewController", category: "MessageViewController")
    
    let heightDict = NSMutableDictionary()
    var passedGroup: Group? = nil
    var groupname = ""
    
    var messages: [Message] = [Message]()
    
    /**
     Invoked when the MessageViewController loads
     */
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationController?.navigationBar.backgroundColor = UIColor(0x990000, a: 0.9)
        
        // Set the navigation bar back button to a custom image
        navigationController?.navigationBar.backIndicatorImage = UIImage(named: "back")
        navigationController?.navigationBar.backIndicatorTransitionMaskImage = UIImage(named: "back")
        navigationController?.navigationBar.tintColor = UIColor(0xFFFFFF)
        
        navigationItem.backBarButtonItem = UIBarButtonItem(title: " ", style:
            UIBarButtonItem.Style.plain, target: nil, action: nil)
        
        // Setting the row height to UITableViewAutomaticDimension tells the TableView to determine the
        // height of a cell based on its contents and constraints.
        messageTableView.rowHeight = UITableView.automaticDimension
        
        if let group: Group = passedGroup {
            navigationItem.title = group.group_title!
            
            groupname = passedGroup?.group_name ?? ""
            
            // Make a request to the API to get the messages for this group
            APIClient.messagefeedGetRequest(
                withParamType: "group",
                sortParam: groupname,
                limit: 50,
                offset: 0,
                fromController: self
            ) {
                (messagefeed) -> Void in
                
                self.messages = messagefeed
                self.messageTableView.reloadData()
            }
        }
    }
    
    /**
     Returns the number of rows that the tableview should display
     - parameters:
     - tableView: the table view in which rows will be displayed
     - section: the number of rows in this particular table view section.  This table view only uses
     a single section.
     - returns: The number of rows in the tableview
     */
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return messages.count + 1
    }
    
    /**
     Called when a cell at a certain index is about to be displayed
     - parameters:
     - tableView: the table view requesting information
     - cell: the cell about to be displayed
     - indexPath: The index of the cell in the table view
     */
    override func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell,
                            forRowAt indexPath: IndexPath) {
        
        // Cache the height of the cell
        let height = NSNumber(value: Float(cell.frame.size.height))
        heightDict.setObject(height, forKey: indexPath as NSCopying)
    }
    
    /**
     Either set the height to the cached value or let the automaticdimension determine the height
     - parameters:
     - tableView: the table view requesting information
     - indexPath: the index of a row in the table view
     - returns: The height of a row in the tableview
     */
    override func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        if let height = heightDict.object(forKey: indexPath) as? NSNumber {
            return CGFloat(height.floatValue)
        } else {
            return UITableView.automaticDimension
        }
    }
    
    /**
     Ask the datasource for a cell to insert at a certain location in the table view
     The less work that is done in this function, the smoother the scrolling is
     - parameters:
     - tableView: the table view requesting information
     - indexPath: the index of a row in the table view
     - returns: The table view cell to be added
     */
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if indexPath.row == 0 {
            
            os_log("Generating New Message Cell at Index %@", log: logTag, type: .debug, String(indexPath.row))
            
            let cell = tableView.dequeueReusableCell(withIdentifier: "NewMessageCell", for: indexPath)
                as! NewMessageTableViewCell
            
            // Set up the done button for the keyboard
            setDoneKeyboard(cell: cell)
            
            // Pass the group and the viewcontroller to the new message cell
            cell.group = passedGroup
            cell.messageVC = self
            return cell
            
        } else {
            
            os_log("Generating Message Cell at Index %@", log: logTag, type: .debug, String(indexPath.row))
            
            let cell = tableView.dequeueReusableCell(withIdentifier: "MessageCell", for: indexPath)
                as! MessageTableViewCell
            
            let message: Message = messages[indexPath.row - 1]
                
            cell.layer.borderWidth = 2
            cell.layer.borderColor = UIColor(0xAAAAAA).cgColor
            cell.layer.cornerRadius = 1
            cell.backgroundColor = UIColor(Constants.getFeelColor(5))
            
            // Convert the string to a date
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
            
            // Then format the date for viewing
            let formattedDate = dateFormatter.date(from: message.time)
            dateFormatter.amSymbol = "AM"
            dateFormatter.pmSymbol = "PM"
            dateFormatter.dateFormat = "MMM dd, yyyy h:mm a"
            cell.dateLabel.text = dateFormatter.string(from: formattedDate!)

            cell.contentLabel.text = message.content ?? ""
            
            cell.nameLabel.text = "\(message.first!) \(message.last!)"
            
            return cell
        }
    }
    
    /**
     Create the done button for the keyboard in a given new message cell
     - parameters:
     - cell: the cell for inserting a new message to a group
     */
    func setDoneKeyboard(cell: NewMessageTableViewCell) {
        let keyboardToolbar = UIToolbar()
        keyboardToolbar.sizeToFit()
        let flexBarButton = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        let doneBarButton = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(self.dismissKeyboard))
        keyboardToolbar.items = [flexBarButton, doneBarButton]
        
        // Connect the done button to all the text fields keyboards
        cell.messageField.inputAccessoryView = keyboardToolbar
    }
    
    /**
     Called when the done button on the keyboard is clicked
     */
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
}
