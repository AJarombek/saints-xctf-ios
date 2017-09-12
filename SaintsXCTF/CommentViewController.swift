//
//  CommentViewController.swift
//  SaintsXCTF
//
//  Created by Andy Jarombek on 8/31/17.
//  Copyright © 2017 Andy Jarombek. All rights reserved.
//

import UIKit
import os.log

class CommentViewController: UITableViewController {
    
    @IBOutlet weak var commentTableView: UITableView!
    
    let logTag = OSLog(subsystem: "SaintsXCTF.App.CommentViewController", category: "CommentViewController")
    
    var log: Log!
    var comments: [Comment]?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Make sure the table view does not overlap the status bar
        let statusBarHight = UIApplication.shared.statusBarFrame.height
        let insets = UIEdgeInsets(top: statusBarHight, left: 0, bottom: 0, right: 0)
        
        commentTableView.contentInset = insets
        commentTableView.scrollIndicatorInsets = insets
        
        // Setting the row height to UITableViewAutomaticDimension tells the TableView to determine the
        // height of a cell based on its contents and constraints.
        commentTableView.rowHeight = UITableViewAutomaticDimension
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        os_log("CommentViewController Appeared.", log: logTag, type: .debug)
        
        comments = log?.comments
        os_log("Log Comments: %@", log: logTag, type: .debug, comments ?? "")
    }
    
    // Returns the number of rows that the tableview should display
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if let commentcount: Int = comments?.count {
            return commentcount + 1
        } else {
            return 1
        }
    }
    
    // Ask the datasource for a cell to insert at a certain location in the table view
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if indexPath.row == 0 {
            
            os_log("Generating New Comment Cell at Index %@", log: logTag, type: .debug, String(indexPath.row))
            
            return tableView.dequeueReusableCell(withIdentifier: "NewCommentCell", for: indexPath)
                    as! NewCommentTableViewCell
            
        } else {
            
            os_log("Generating Comment Cell at Index %@", log: logTag, type: .debug, String(indexPath.row))
        
            let cell = tableView.dequeueReusableCell(withIdentifier: "CommentCell", for: indexPath)
                    as! CommentTableViewCell
        
            if let comment = comments?[indexPath.row - 1] {
            
                /*
                 // Convert the string to a date
                 let dateFormatter = DateFormatter()
                 dateFormatter.dateFormat = "yyyy-MM-dd HH:mm"
                 
                 // Then format the date for viewing
                 let formattedDate = dateFormatter.date(from: log.date)
                 dateFormatter.dateFormat = "MMM dd, yyyy"
                 cell.dateLabel?.text = dateFormatter.string(from: formattedDate!)
                 
                 cell.nameLabel?.text = log.name!*/
            
                cell.contentLabel.text = comment.content!
                cell.dateLabel.text = comment.time!
                cell.nameLabel.text = "\(comment.first!) \(comment.last!)"
            
            } else {
                os_log("Comment Failed to Load.", log: logTag, type: .debug)
            }
        
            return cell
        }
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    }
}
