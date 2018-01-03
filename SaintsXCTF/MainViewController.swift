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
    
    let refreshcontrol = UIRefreshControl()
    
    var user: User = User()
    
    var logDataSource = LogDataSource()
    let heightDict = NSMutableDictionary()
    var finished = false
    
    var showNavBar = false
    var userPassed: User = User()
    var groupPassed: Group? = nil
    
    var paramType = "all"
    var sortParam = "all"
    let limit = 25
    var offset = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        os_log("MainViewController Loaded.", log: logTag, type: .debug)
        
        navigationController?.navigationBar.backgroundColor = UIColor(0x990000, a: 0.9)
        
        // Setting the row height to UITableViewAutomaticDimension tells the TableView to determine the
        // height of a cell based on its contents and constraints.
        logTableView.rowHeight = UITableViewAutomaticDimension
        
        // Add a long press gesture recognizer to the table view so that an edit and delete option
        // can pop up when pressing on a log
        let longpress = UILongPressGestureRecognizer(target: self, action: #selector(MainViewController.handleLogLongPress))
        logTableView.addGestureRecognizer(longpress)
        
        // Set the refresh control for the table view for pull down refresh
        logTableView.refreshControl = refreshcontrol
        
        refreshcontrol.addTarget(self, action: #selector(reloadLogs(_:)), for: .valueChanged)
        refreshcontrol.attributedTitle = NSAttributedString(string: "Reloading Logs ...", attributes: [:])
        
        // Get the currently logged in user
        user = SignedInUser.user

        load()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // Hide the navigation bar on view appearing
        if !showNavBar {
            navigationController?.setNavigationBarHidden(true, animated: animated)
            navigationController?.navigationBar.tintColor = UIColor(0xFFFFFF)
            
            // Make sure the table view does not overlap the status bar
            let statusBarHight = UIApplication.shared.statusBarFrame.height
            let insets = UIEdgeInsets(top: statusBarHight, left: 0, bottom: 0, right: 0)
            
            logTableView.contentInset = insets
            logTableView.scrollIndicatorInsets = insets
            
        } else {
            // Set the navigation bar back button to a custom image
            navigationController?.navigationBar.backIndicatorImage = UIImage(named: "back")
            navigationController?.navigationBar.backIndicatorTransitionMaskImage = UIImage(named: "back")
            navigationController?.navigationBar.tintColor = UIColor(0xFFFFFF)
            
            // The navigation bar title should be either the users name or the group title
            if let group: Group = groupPassed {
                navigationItem.title = group.group_title!
            } else {
                navigationItem.title = "\(userPassed.first ?? "") \(userPassed.last ?? "")"
            }
            
            navigationItem.backBarButtonItem = UIBarButtonItem(title: " ", style: UIBarButtonItemStyle.plain,
                                                               target: nil, action: nil)
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        // Show the navigation bar on view disappearing
        navigationController?.setNavigationBarHidden(false, animated: animated)
    }
    
    func reloadLogs(_ sender: UIView) {
        offset = 0
        logDataSource.clearLogs()
        logTableView.reloadData()
        load()
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
        let log: LogData? = logDataSource.get(indexPath.row)
        
        if let logData: LogData = log {
            
            // Create a reference to the view controller in the cell
            cell.mainViewController = self
            cell.log = logData.log!
            cell.index = indexPath.row

            let username = user.username ?? ""
            
            // Show the edit and delete buttons if the log username matches the signed in username
            if username == logData.username! {
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
            
            cell.setStyle(withFeel: logData.feel!)

            // Create a top border for the comments button
            let topline = UIView(frame: CGRect(x: -10, y: -5, width: cell.commentsButton.frame.size.width + 50, height: 1))
            topline.layer.backgroundColor = UIColor(0xAAAAAA).cgColor
            
            // Customize the comments button display
            cell.commentsButton.backgroundColor = UIColor(0x000000, a: 0.0)
            cell.commentsButton.addSubview(topline)
            cell.commentsButton.setTitleColor(UIColor(0x333333), for: UIControlState.normal)
            
            cell.userLabel?.linkTextAttributes = [NSForegroundColorAttributeName:UIColor(0x000000)]
            cell.userLabel?.attributedText = logData.userLabelText!
            cell.userLabel?.delegate = self

            cell.dateLabel?.text = logData.date!
            
            // Set the logs name
            cell.nameLabel?.text = logData.name!
            
            // Set the logs type
            cell.typeLabel?.text = logData.type ?? "RUN"
            
            if let desc: String = logData.description {
                cell.descriptionLabel.text = desc
                
            } else if let attDesc: NSMutableAttributedString = logData.descriptionTags {
                cell.descriptionLabel.attributedText = attDesc
                
                // Set the properties of the link text
                cell.descriptionLabel?.linkTextAttributes = [NSForegroundColorAttributeName:UIColor(0x555555),
                                                             NSFontAttributeName:UIFont(name: "HelveticaNeue-Bold", size: 12)!]
                
                // Allows the shouldInteractWith URL function to execute on click
                cell.descriptionLabel?.delegate = self
                cell.descriptionLabel?.sizeToFit()
            }
            
            // Add a tag to the comments button of the current index path.
            // This will be used with the segue to call the commentsView
            cell.commentsButton.tag = indexPath.row
        }
        
        return cell
    }
    
    // This function is called when a tagged user is clicked in a comment
    func textView(_ textView: UITextView, shouldInteractWith URL: URL, in characterRange: NSRange,
                  interaction: UITextItemInteraction) -> Bool {
        os_log("%@", log: logTag, type: .debug, URL.absoluteString)
        
        let index = URL.absoluteString.index(URL.absoluteString.startIndex, offsetBy: 1)
        APIClient.userGetRequest(withUsername: URL.absoluteString.substring(from: index)) {
            (user) -> Void in
            
            if (user.username! != "") {
            
                let profileViewController = self.storyboard?.instantiateViewController(withIdentifier:
                                        "profileViewController") as! ProfileViewController
            
                // Pass the user to the profile view controller
                profileViewController.user = user
                profileViewController.showNavBar = true
                self.navigationController?.pushViewController(profileViewController, animated: true)
            }
        }
        
        return false
    }
    
    // Pass data to the CommentViewController when the segue is executed
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        // We want to send the CommentViewController the log that was selected
        if let destination = segue.destination as? CommentViewController {
            
            if let button: UIButton = sender as! UIButton? {
                
                let row = button.tag
                let logData = logDataSource.get(row)
                destination.log = logData?.log!
            }
        }
    }
    
    // Load more logs into the data source
    func load() {
        logDataSource.load(withParamType: paramType, sortParam: sortParam, limit: limit, andOffset: offset) {
            (done) -> Void in
            
            self.logTableView.reloadData()
            self.refreshcontrol.endRefreshing()
            
            // If there are no more logs to load, remove the activity indicator and
            // stop trying to load more logs
            if (done) {
                self.finished = done
            }
        }
        offset += limit
    }
    
    // Function that handles the long press recognizer
    func handleLogLongPress(sender: UILongPressGestureRecognizer) {
        if sender.state == UIGestureRecognizerState.began {
            
            // Get the index path of the log where the user pressed
            let touchpoint = sender.location(in: logTableView)
            if let indexPath = logTableView.indexPathForRow(at: touchpoint) {
                
                let log: Log = (logDataSource.get(indexPath.row)?.log!)!
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
    
    // Call the LogViewController and edit the existing log
    func editExistingLog(at index: Int, log: Log) {
        let logViewController = storyboard?.instantiateViewController(withIdentifier: "logViewController")
                                    as! LogViewController
        
        // Pass both the log and the index to the log view controller
        logViewController.editingLog = true
        logViewController.logPassed = log
        logViewController.indexPassed = index
        navigationController?.pushViewController(logViewController, animated: true)
    }
}
