//
//  CommentViewController.swift
//  SaintsXCTF
//
//  Created by Andy Jarombek on 8/31/17.
//  Copyright © 2017 Andy Jarombek. All rights reserved.
//

import UIKit
import os.log

class CommentViewController: UITableViewController, UITextViewDelegate {
    
    @IBOutlet weak var commentTableView: UITableView!
    
    let logTag = OSLog(subsystem: "SaintsXCTF.App.CommentViewController", category: "CommentViewController")
    
    var log: Log!
    var comments: [Comment]?
    let heightDict = NSMutableDictionary()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Setting the row height to UITableViewAutomaticDimension tells the TableView to determine the
        // height of a cell based on its contents and constraints.
        commentTableView.rowHeight = UITableViewAutomaticDimension
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // Set the navigation bar back button to a custom image
        navigationController?.navigationBar.backIndicatorImage = UIImage(named: "back")
        navigationController?.navigationBar.backIndicatorTransitionMaskImage = UIImage(named: "back")
        navigationController?.navigationBar.tintColor = UIColor(0x000000)
        navigationItem.backBarButtonItem = UIBarButtonItem(title: " ", style: UIBarButtonItemStyle.plain, target: nil, action: nil)
        
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
    
    // Called when a cell at a certain index is about to be displayed
    override func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell,
                            forRowAt indexPath: IndexPath) {
        
        // Cache the height of the cell
        let height = NSNumber(value: Float(cell.frame.size.height))
        heightDict.setObject(height, forKey: indexPath as NSCopying)
    }
    
    // Either set the height to the cached value or let the automaticdimension determine the height
    override func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        if let height = heightDict.object(forKey: indexPath) as? NSNumber {
            return CGFloat(height.floatValue)
        } else {
            return UITableViewAutomaticDimension
        }
    }
    
    // Ask the datasource for a cell to insert at a certain location in the table view
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if indexPath.row == 0 {
            
            os_log("Generating New Comment Cell at Index %@", log: logTag, type: .debug, String(indexPath.row))
            
            let cell = tableView.dequeueReusableCell(withIdentifier: "NewCommentCell", for: indexPath)
                    as! NewCommentTableViewCell
            
            // Pass the log and the viewcontroller to the new comment cell
            cell.log = log
            cell.commentVC = self
            return cell
            
        } else {
            
            os_log("Generating Comment Cell at Index %@", log: logTag, type: .debug, String(indexPath.row))
        
            let cell = tableView.dequeueReusableCell(withIdentifier: "CommentCell", for: indexPath)
                    as! CommentTableViewCell
        
            if let comment = comments?[indexPath.row - 1] {
                
                cell.layer.borderWidth = 2
                cell.layer.borderColor = UIColor(0xAAAAAA).cgColor
                cell.layer.cornerRadius = 1
                cell.backgroundColor = UIColor(Constants.getFeelColor(6))
            
                // Convert the string to a date
                let dateFormatter = DateFormatter()
                dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
                 
                // Then format the date for viewing
                let formattedDate = dateFormatter.date(from: comment.time)
                dateFormatter.amSymbol = "AM"
                dateFormatter.pmSymbol = "PM"
                dateFormatter.dateFormat = "MMM dd, yyyy h:mm a"
                cell.dateLabel.text = dateFormatter.string(from: formattedDate!)
                
                // Find all the tagged users in the comment
                let tagRegex = "@[a-zA-Z0-9]+"
                let matches = Utils.matchesInfo(for: tagRegex, in: comment.content!)
                
                // Create a MutableAttributedString for each tag
                let mutableContent = NSMutableAttributedString(string: comment.content!,
                                                               attributes: [:])
                
                // Go through each tag and add a link when clicked
                if matches.substrings.count > 0 {
                    for i in 0...matches.substrings.count - 1 {
                        let start = matches.startIndices[i]
                        let length = matches.stringLengths[i]
                        
                        mutableContent.addAttribute(NSLinkAttributeName, value: matches.substrings[i],
                                                    range: NSRange(location: start, length: length))
                    }
                }
            
                cell.contentLabel.attributedText = mutableContent
                
                // Set the properties of the link text
                cell.contentLabel.linkTextAttributes = [NSForegroundColorAttributeName:UIColor(0x555555),
                                                    NSFontAttributeName:UIFont(name: "HelveticaNeue-Bold", size: 12)!]
                
                // Allows the shouldInteractWith URL function to execute on click
                cell.contentLabel.delegate = self
                cell.contentLabel.sizeToFit()
                
                cell.nameLabel.text = "\(comment.first!) \(comment.last!)"
            
            } else {
                os_log("Comment Failed to Load.", log: logTag, type: .error)
            }
        
            return cell
        }
    }
    
    // This function is called when a tagged user is clicked in a comment
    func textView(_ textView: UITextView, shouldInteractWith URL: URL, in characterRange: NSRange,
                  interaction: UITextItemInteraction) -> Bool {
        os_log("%@", log: logTag, type: .debug, URL.absoluteString)
        
        return false
    }
}
