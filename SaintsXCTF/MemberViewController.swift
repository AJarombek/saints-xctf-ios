//
//  MemberViewController.swift
//  SaintsXCTF
//
//  Created by Andy Jarombek on 10/12/17.
//  Copyright © 2017 Andy Jarombek. All rights reserved.
//

import UIKit
import os.log

/**
 Controller for listing all the group members.
 - Important:
 ## Extends the following class:
 - UITableViewController: view controller for managing a table view
 
 ## Implements the following protocols:
 - UIGestureRecognizerDelegate: provides helper methods for handling gestures (clicks,swipes,etc.)
 */
class MemberViewController: UITableViewController, UIGestureRecognizerDelegate {
    
    let logTag = OSLog(subsystem: "SaintsXCTF.App.MemberViewController",
                       category: "MemberViewController")
    
    @IBOutlet var memberTableView: UITableView!
    
    var passedGroup: Group? = nil
    var members: [GroupMember] = [GroupMember]()
    let heightDict = NSMutableDictionary()
    
    /**
     Invoked when the MemberViewController loads
     */
    override func viewDidLoad() {
        super.viewDidLoad()
        os_log("MainViewController Loaded.", log: logTag, type: .debug)
        
        navigationController?.navigationBar.backgroundColor = UIColor(0x990000, a: 0.9)
        
        // Set the navigation bar back button to a custom image
        navigationController?.navigationBar.backIndicatorImage = UIImage(named: "back")
        navigationController?.navigationBar.backIndicatorTransitionMaskImage = UIImage(named: "back")
        navigationController?.navigationBar.tintColor = UIColor(0xFFFFFF)
        
        navigationItem.backBarButtonItem = UIBarButtonItem(title: " ", style:
            UIBarButtonItem.Style.plain, target: nil, action: nil)
        
        // Setting the row height to UITableViewAutomaticDimension tells the TableView to determine the
        // height of a cell based on its contents and constraints.
        memberTableView.rowHeight = UITableView.automaticDimension
        
        if let group: Group = passedGroup {
            navigationItem.title = group.group_title!
            
            // Build the members array
            members = group.members!
            
            // Filter the members array so only accepted members show up
            members = members.filter { $0.status ?? "" == "accepted" }
            
            self.memberTableView.reloadData()
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
        return members.count
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
        
        // Cache the height of the cell
        let height = NSNumber(value: Float(cell.frame.size.height))
        heightDict.setObject(height, forKey: indexPath as NSCopying)
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
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "MemberCell", for: indexPath)
            as! MemberTableViewCell
        let member: GroupMember = members[indexPath.row]
        
        cell.nameLabel.text = "\(member.first!) \(member.last!)"
        
        // Format the member join date
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "E, dd MMM yyyy HH:mm:ss zzz"
        
        let formattedDate = dateFormatter.date(from: member.member_since)!
        dateFormatter.dateFormat = "MMM dd, yyyy"
        
        cell.memberSinceLabel.text = dateFormatter.string(from: formattedDate)
        
        cell.setStyle()
        
        cell.tag = indexPath.row
        
        // Set click listener to the cell to open up the profile page
        let clickview = UITapGestureRecognizer(target: self, action: #selector(self.viewProfile(_:)))
        clickview.delegate = self
        cell.addGestureRecognizer(clickview)
        
        return cell
    }
    
    /**
     Called when the name label is clicked to load a users profile
     - parameters:
     - sender: the gesture that invokes this function (a click on a table view cell representing a group member)
     */
    @objc func viewProfile(_ sender: UITapGestureRecognizer) {
        if let cell = sender.view as? MemberTableViewCell {
            
            os_log("View Group Messages", log: logTag, type: .debug)
            
            let member = members[cell.tag]
            let username: String = member.username!
            
            os_log("Load Users Profile: %@", log: logTag, type: .debug, username)
            
            APIClient.userGetRequest(withUsername: username, fromController: self) {
                (user) -> Void in
                
                let profileViewController = self.storyboard?.instantiateViewController(withIdentifier:
                    "profileViewController") as! ProfileViewController
                
                // Pass the user to the profile view controller
                profileViewController.user = user
                profileViewController.showNavBar = true
                self.navigationController?.pushViewController(profileViewController, animated: true)
            }
        }
    }
}
