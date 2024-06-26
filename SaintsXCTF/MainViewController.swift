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

/**
 Controller for the newest exercise logs in the application.
 - Important:
 ## Extends the following class:
 - UITableViewController: view controller for managing a table view
 
 ## Implements the following protocols:
 - UITextViewDelegate: methods that change the behavior of a text view being edited
 */
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
    
    /**
     Programatically set the style of the tab bar controller
     - parameters:
     - itemAppearance: The appearance of different tab bar item layouts
     - style: Whether the user is configured to use dark mode
     */
    @available(iOS 13.0, *)
    private func setTabBarItemColors(_ itemAppearance: UITabBarItemAppearance, style: UIUserInterfaceStyle) {
        if style == .dark {
            itemAppearance.normal.iconColor = .lightGray
            itemAppearance.normal.titleTextAttributes = [.foregroundColor: UIColor.lightGray]
        } else {
            itemAppearance.normal.iconColor = .darkGray
            itemAppearance.normal.titleTextAttributes = [.foregroundColor: UIColor.darkGray]
        }
        
        itemAppearance.selected.iconColor = UIColor(0x990000)
        itemAppearance.selected.titleTextAttributes = [.foregroundColor: UIColor(0x990000)]
    }
    
    /**
     Invoked when the MainViewController loads
     */
    override func viewDidLoad() {
        super.viewDidLoad()
        os_log("MainViewController Loaded.", log: logTag, type: .debug)
        
        let appearance = UITabBarAppearance()
        setTabBarItemColors(appearance.stackedLayoutAppearance, style: self.traitCollection.userInterfaceStyle)
        setTabBarItemColors(appearance.inlineLayoutAppearance, style: self.traitCollection.userInterfaceStyle)
        setTabBarItemColors(appearance.compactInlineLayoutAppearance, style: self.traitCollection.userInterfaceStyle)
        self.tabBarController?.tabBar.standardAppearance = appearance
        
        navigationController?.navigationBar.backgroundColor = UIColor(0x990000, a: 0.9)
        
        // Setting the row height to UITableViewAutomaticDimension tells the TableView to determine the
        // height of a cell based on its contents and constraints.
        logTableView.rowHeight = UITableView.automaticDimension
        
        // Add a long press gesture recognizer to the table view so that an edit and delete option
        // can pop up when pressing on a log
        let longpress = UILongPressGestureRecognizer(target: self, action: #selector(MainViewController.handleLogLongPress))
        logTableView.addGestureRecognizer(longpress)
        
        // Set the refresh control for the table view for pull down refresh
        logTableView.refreshControl = refreshcontrol
        
        logTableView.accessibilityIdentifier = "LogTableView"
        
        refreshcontrol.addTarget(self, action: #selector(reloadLogs(_:)), for: .valueChanged)
        refreshcontrol.attributedTitle = NSAttributedString(string: "Reloading Logs ...", attributes: [:])
        
        // Get the currently logge@objc d in user
        user = SignedInUser.user

        load()
    }
    
    /**
     Invoked when the MainViewController is about to appear
     - parameters:
     - animated: Whether or not the view appears with an animation
     */
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
            
            navigationItem.backBarButtonItem = UIBarButtonItem(title: " ", style: UIBarButtonItem.Style.plain,
                                                               target: nil, action: nil)
        }
    }
    
    /**
     Invoked when the MainViewController is about to disappear
     - parameters:
     - animated: Whether or not the view disappears with an animation
     */
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        // Show the navigation bar on view disappearing
        navigationController?.setNavigationBarHidden(false, animated: animated)
    }
    
    /**
     Invoked when the logs on the screen should be reloaded from the server
     - parameters:
     - sender: the view that invoked this function
     */
    @objc func reloadLogs(_ sender: UIView) {
        offset = 0
        logDataSource.clearLogs()
        logTableView.reloadData()
        load()
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
        return logDataSource.count()
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
     Called when a cell at a certain index is about to be displayed
     - parameters:
     - tableView: the table view requesting information
     - cell: the cell about to be displayed
     - indexPath: The index of the cell in the table view
     */
    override func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell,
                            forRowAt indexPath: IndexPath) {
        
        let log: LogData? = logDataSource.get(indexPath.row)
        let cell = cell as! LogTableViewCell
        
        cell.accessibilityIdentifier = "LogCell\(indexPath.row)"
        
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
                cell.editButton.imageEdgeInsets = UIEdgeInsets.init(top: 20, left: 20, bottom: 20, right: 20)
                cell.deleteButton.imageEdgeInsets = UIEdgeInsets.init(top: 20, left: 20, bottom: 20, right: 20)
                
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
            cell.commentsButton.setTitleColor(UIColor(0x333333), for: UIControl.State.normal)
            
            cell.userLabel?.linkTextAttributes = convertToOptionalNSAttributedStringKeyDictionary([
                NSAttributedString.Key.foregroundColor.rawValue:UIColor(0x000000)
            ])
            cell.userLabel?.attributedText = logData.userLabelText!
            cell.userLabel?.delegate = self
            
            cell.dateLabel?.text = logData.date!
            
            // Set the logs name
            cell.nameLabel?.text = logData.name!
            
            // Set the logs type
            cell.typeLabel?.text = logData.type ?? "RUN"
            
            // Add a tag to the comments button of the current index path.
            // This will be used with the segue to call the commentsView
            cell.commentsButton.tag = indexPath.row
            
            if let _: NSMutableAttributedString = logData.descriptionTags {
                // Set the properties of the link text
                cell.descriptionLabel?.linkTextAttributes = convertToOptionalNSAttributedStringKeyDictionary([
                    NSAttributedString.Key.foregroundColor.rawValue:UIColor(0x555555),
                    NSAttributedString.Key.font.rawValue:UIFont(name: "HelveticaNeue-Bold", size: 12)!
                ])
                
                // Allows the shouldInteractWith URL function to execute on click
                cell.descriptionLabel?.delegate = self
                cell.descriptionLabel?.sizeToFit()
            }
        }
        
        // Cache the height of the cell
        let height = NSNumber(value: Float(cell.frame.size.height))
        heightDict.setObject(height, forKey: indexPath as NSCopying)
        
        // When we are four logs from the bottom, load more
        if indexPath.row == logDataSource.count() - 4 {
            load()
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
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "LogCell", for: indexPath) as! LogTableViewCell
        
        let log: LogData? = logDataSource.get(indexPath.row)
        
        if let logData: LogData = log {
            
            if let desc: String = logData.description {
                cell.descriptionLabel.text = desc
                
            } else if let attDesc: NSMutableAttributedString = logData.descriptionTags {
                cell.descriptionLabel.attributedText = attDesc
            }
        }
        
        return cell
    }
    
    /**
     This function is called when a tagged user is clicked in a comment
     - parameters:
     - textView: the table view requesting information
     - URL: the URL clicked upon (a tagged users username)
     - characterRange: the character range of the URL
     - interaction: the type of interaction which occured with the URL
     - returns: false because we dont want the default result of URL interaction to occur
     */
    func textView(_ textView: UITextView, shouldInteractWith URL: URL, in characterRange: NSRange,
                  interaction: UITextItemInteraction) -> Bool {
        os_log("%@", log: logTag, type: .debug, URL.absoluteString)
        
        let start = URL.absoluteString.index(URL.absoluteString.startIndex, offsetBy: 1)
        let end = URL.absoluteString.endIndex
        
        APIClient.userGetRequest(withUsername: String(URL.absoluteString[start..<end]), fromController: self) {
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
    
    /**
     Pass data to the CommentViewController when the segue is executed
     - parameters:
     - segue: segue object containing information about the controllers involved with the segue
     - sender: the object that initiated the segue
     */
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
    
    /**
     Load more logs into the data source
     */
    func load() {
        logDataSource.load(
            withParamType: paramType,
            sortParam: sortParam,
            limit: limit,
            andOffset: offset,
            fromController: self
        ) {
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
    
    /**
     Function that handles the long press recognizer
     - parameters:
     - sender: long press recognizer object
     */
    @objc func handleLogLongPress(sender: UILongPressGestureRecognizer) {
        if sender.state == UIGestureRecognizer.State.began {
            
            // Get the index path of the log where the user pressed
            let touchpoint = sender.location(in: logTableView)
            if let indexPath = logTableView.indexPathForRow(at: touchpoint) {
                
                let log: Log = (logDataSource.get(indexPath.row)?.log!)!
                os_log("Log Long Pressed: %@", log: logTag, type: .debug, log.description)
            }
        }
    }
    
    /**
     Remove a cell at a specific index
     - parameters:
     - index: the index in the table view to delete a row
     */
    func removeDeletedLog(at index: Int) {
        logDataSource.delete(index)
        offset -= 1
        logTableView.reloadData()
    }
    
    /**
     Call the LogViewController and edit the existing log
     - parameters:
     - index: the index in the table view to edit
     - log: the log object to edit
     */
    func editExistingLog(at index: Int, log: Log) {
        let editExerciseLogViewController = storyboard?.instantiateViewController(
            withIdentifier: "editExerciseLogViewController"
        ) as! EditExerciseLogViewController
        
        // Pass the log to the view controller
        editExerciseLogViewController.log = log
        navigationController?.pushViewController(editExerciseLogViewController, animated: true)
    }
}

// Helper function inserted by Swift 4.2 migrator.
fileprivate func convertToOptionalNSAttributedStringKeyDictionary(_ input: [String: Any]?) -> [NSAttributedString.Key: Any]? {
	guard let input = input else { return nil }
	return Dictionary(uniqueKeysWithValues: input.map { key, value in (NSAttributedString.Key(rawValue: key), value)})
}
