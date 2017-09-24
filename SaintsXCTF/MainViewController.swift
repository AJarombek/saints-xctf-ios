//
//  MainViewController.swift
//  SaintsXCTF
//
//  Created by Andy Jarombek on 7/3/17.
//  Copyright © 2017 Andy Jarombek. All rights reserved.
//

import UIKit
import os.log
import PopupDialog

class MainViewController: UITableViewController, UITextViewDelegate {
    
    let logTag = OSLog(subsystem: "SaintsXCTF.App.MainViewController", category: "MainViewController")
    
    @IBOutlet weak var logTableView: UITableView!
    
    var user: User = User()
    
    let logDataSource = LogDataSource()
    let heightDict = NSMutableDictionary()
    var finished = false
    
    let paramType = "all"
    let sortParam = "all"
    let limit = 10
    var offset = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        os_log("MainViewController Loaded.", log: logTag, type: .debug)
        
        // Make sure the table view does not overlap the status bar
        let statusBarHight = UIApplication.shared.statusBarFrame.height
        let insets = UIEdgeInsets(top: statusBarHight, left: 0, bottom: 0, right: 0)

        logTableView.contentInset = insets
        logTableView.scrollIndicatorInsets = insets
        
        navigationController?.navigationBar.backgroundColor = UIColor(0x999999, a: 0.9)
        
        // Setting the row height to UITableViewAutomaticDimension tells the TableView to determine the
        // height of a cell based on its contents and constraints.
        logTableView.rowHeight = UITableViewAutomaticDimension
        
        // Add a long press gesture recognizer to the table view so that an edit and delete option
        // can pop up when pressing on a log
        let longpress = UILongPressGestureRecognizer(target: self, action: #selector(MainViewController.handleLogLongPress))
        logTableView.addGestureRecognizer(longpress)
        
        // Get the currently logged in user
        user = SignedInUser.user

        load()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // Hide the navigation bar on view appearing
        navigationController?.setNavigationBarHidden(true, animated: animated)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        // Show the navigation bar on view disappearing
        navigationController?.setNavigationBarHidden(false, animated: animated)
    }
    
    // Remove the keyboard when tapping the background
    @IBAction func backgroundTapped(_ sender: UITapGestureRecognizer) {
        view.endEditing(true)
    }
    
    // Returns the number of rows that the tableview should display
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return logDataSource.count()
    }
    
    // Either set the height to the cached value or let the automaticdimension determine the height
    override func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        if let height = heightDict.object(forKey: indexPath) as? NSNumber {
            return CGFloat(height.floatValue)
        } else {
            return UITableViewAutomaticDimension
        }
    }
    
    // Called when a cell at a certain index is about to be displayed
    override func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell,
                            forRowAt indexPath: IndexPath) {
        
        // Cache the height of the cell
        let height = NSNumber(value: Float(cell.frame.size.height))
        heightDict.setObject(height, forKey: indexPath as NSCopying)
        
        // When we are four logs from the bottom, load more
        if indexPath.row == logDataSource.count() - 4 {
            load()
        }
    }
    
    // Ask the datasource for a cell to insert at a certain location in the table view
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! LogTableViewCell
        let log = logDataSource.get(indexPath.row)
        
        cell.nameLabel.contentOffset = CGPoint()
        
        // Create a reference to the view controller in the cell
        cell.mainViewController = self
        cell.log = log
        cell.index = indexPath.row
        
        let username = user.username ?? ""
        
        // Show the edit and delete buttons if the log username matches the signed in username
        if username == log.username! {
            cell.editButton.isHidden = false
            cell.deleteButton.isHidden = false
            
            // Set the styles of the edit and delete buttons
            cell.editButton.backgroundColor = UIColor(0xCCCCCC, a: 0.9)
            cell.deleteButton.backgroundColor = UIColor(0xCCCCCC, a: 0.9)
            cell.editButton.imageEdgeInsets = UIEdgeInsetsMake(20, 20, 20, 20)
            cell.deleteButton.imageEdgeInsets = UIEdgeInsetsMake(20, 20, 20, 20)
            
            // Set the buttons to be round
            cell.editButton.layer.cornerRadius = 0.5 * cell.editButton.bounds.size.width
            cell.deleteButton.layer.cornerRadius = 0.5 * cell.deleteButton.bounds.size.width
            
            // Add click listeners to the buttons
            cell.editButton.addTarget(cell, action: #selector(LogTableViewCell.editLog), for: .touchUpInside)
            cell.deleteButton.addTarget(cell, action: #selector(LogTableViewCell.deleteLog), for: .touchUpInside)
            
        } else {
            cell.editButton.isHidden = true
            cell.deleteButton.isHidden = true
        }
        
        let feelInt: Int! = Int(log.feel)
        if let validFeel: Int = feelInt {
            cell.setStyle(withFeel: validFeel)
        } else {
            cell.setStyle(withFeel: 6)
        }
        
        // Create a top border for the comments button
        let topline = UIView(frame: CGRect(x: -10, y: 0, width: cell.commentsButton.frame.size.width + 10, height: 1))
        topline.layer.backgroundColor = UIColor(0xAAAAAA).cgColor
        
        // Customize the comments button display
        cell.commentsButton.backgroundColor = UIColor(0x000000, a: 0.0)
        cell.commentsButton.addSubview(topline)
        cell.commentsButton.setTitleColor(UIColor(0x333333), for: UIControlState.normal)
        
        // Set the user name as clickable text in the log
        let usertitle: String = "\(log.first!) \(log.last!)"
        let range: NSRange = NSRange(location: 0, length: usertitle.characters.count)
        
        let mutableName = NSMutableAttributedString(string: usertitle, attributes: [:])
        mutableName.addAttribute(NSLinkAttributeName, value: log.username!,
                                 range: range)
        mutableName.addAttribute(NSFontAttributeName, value: UIFont.systemFont(ofSize: 16.0, weight: UIFontWeightBold), range: range)
        cell.userLabel?.linkTextAttributes = [NSForegroundColorAttributeName:UIColor(0x000000)]
        
        cell.userLabel?.attributedText = mutableName
        cell.userLabel?.delegate = self
        
        // Convert the string to a date
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        
        // Then format the date for viewing
        let formattedDate = dateFormatter.date(from: log.date)
        dateFormatter.dateFormat = "MMM dd, yyyy"
        cell.dateLabel?.text = dateFormatter.string(from: formattedDate!)
        
        // Set the logs name
        cell.nameLabel?.text = log.name!
        
        // Set the logs type
        cell.typeLabel?.text = log.type?.uppercased()
        
        // Set the logs location
        var locationTxt = ""
        
        if let location: String = log.location {
            locationTxt = "Location: \(location)\n"
        }
        
        // Set the logs distance
        var distanceTxt = ""
        
        if let distance: String = log.distance, let metric: String = log.metric {
            
            if distance != "0" {
                distanceTxt = "\(distance) \(metric)\n"
            }
        }
        
        // Set the logs time
        var timeTxt = ""
        
        if let time: String = log.time, let pace: String = log.pace {
            if time != "00:00:00" {
                timeTxt = shortenTime(withTime: time)
                
                if pace == "00:00:00" {
                    timeTxt += " (0:00/mi)\n"
                } else {
                    timeTxt += " (\(shortenTime(withTime: pace))/mi)\n"
                }
            }
        }
        
        // Combine the location, distance, and time
        let logInfo = "\(locationTxt)\(distanceTxt)\(timeTxt)\n"
        let logInfoMutableContent = NSMutableAttributedString(string: logInfo, attributes: [:])
        
        // Create a combined mutable attribute string for all the log info + description
        let combinedMutableContent = NSMutableAttributedString()
        combinedMutableContent.append(logInfoMutableContent)
        
        // Set the logs description
        if let description: String = log.log_description {
            cell.descriptionLabel?.text = description
            
            // Find all the tagged users in the comment
            let tagRegex = "@[a-zA-Z0-9]+"
            let matches = Utils.matchesInfo(for: tagRegex, in: description)
            
            // Create a MutableAttributedString for each tag
            // Add a new line at the end of the description so none of the text gets cut off
            let mutableContent = NSMutableAttributedString(string: "\(description)\n", attributes: [:])
            
            // Go through each tag and add a link when clicked
            if matches.substrings.count > 0 {
                for i in 0...matches.substrings.count - 1 {
                    let start = matches.startIndices[i]
                    let length = matches.stringLengths[i]
                    
                    mutableContent.addAttribute(NSLinkAttributeName, value: matches.substrings[i],
                                                range: NSRange(location: start, length: length))
                }
            }
            
            // Add the description to the rest of the mutable content
            combinedMutableContent.append(mutableContent)
        }
        
        // Set the description as the combined location, time, pace, distance, and description
        cell.descriptionLabel?.attributedText = combinedMutableContent
        
        // Set the properties of the link text
        cell.descriptionLabel?.linkTextAttributes = [NSForegroundColorAttributeName:UIColor(0x555555),
                            NSFontAttributeName:UIFont(name: "HelveticaNeue-Bold", size: 12)!]
        
        // Allows the shouldInteractWith URL function to execute on click
        cell.descriptionLabel?.delegate = self
        cell.descriptionLabel?.sizeToFit()
        
        // Add a tag to the comments button of the current index path.
        // This will be used with the segue to call the commentsView
        cell.commentsButton.tag = indexPath.row
        
        return cell
    }
    
    // This function is called when a tagged user is clicked in a comment
    func textView(_ textView: UITextView, shouldInteractWith URL: URL, in characterRange: NSRange,
                  interaction: UITextItemInteraction) -> Bool {
        os_log("%@", log: logTag, type: .debug, URL.absoluteString)
        
        return false
    }
    
    // Pass data to the CommentViewController when the segue is executed
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        // We want to send the CommentViewController the log that was selected
        if let destination = segue.destination as? CommentViewController {
            
            if let button: UIButton = sender as! UIButton? {
                
                let row = button.tag
                let log = logDataSource.get(row)
                destination.log = log
            }
        }
    }
    
    // Load more logs into the data source
    func load() {
        logDataSource.load(withParamType: paramType, sortParam: sortParam, limit: limit, andOffset: offset) {
            (done) -> Void in
            
            self.logTableView.reloadData()
            
            // If there are no more logs to load, remove the activity indicator and
            // stop trying to load more logs
            if (done) {
                self.finished = done
            }
        }
        offset += limit
    }
    
    // Function to remove excess zeros from the time
    func shortenTime(withTime time: String) -> String {
        var start = 0
        
        for i in 0 ..< time.characters.count {
            let index = time.index(time.startIndex, offsetBy: i)
            if time[index] != "0" && time[index] != ":" {
                start = i
                break
            }
        }
        
        let index =  time.index(time.startIndex, offsetBy: start)
        return time.substring(from: index)
    }
    
    // Function that handles the long press recognizer
    func handleLogLongPress(sender: UILongPressGestureRecognizer) {
        if sender.state == UIGestureRecognizerState.began {
            
            // Get the index path of the log where the user pressed
            let touchpoint = sender.location(in: logTableView)
            if let indexPath = logTableView.indexPathForRow(at: touchpoint) {
                
                let log: Log = logDataSource.get(indexPath.row)
                os_log("Log Long Pressed: %@", log: logTag, type: .debug, log.description)
            }
        }
    }
    
    // Remove a cell at a specific index
    func removeDeletedLog(at index: Int) {
        logDataSource.delete(index)
        offset -= 1
        logTableView.reloadData()
    }
}
