//
//  MemberViewController.swift
//  SaintsXCTF
//
//  Created by Andy Jarombek on 10/12/17.
//  Copyright © 2017 Andy Jarombek. All rights reserved.
//

import UIKit
import os.log

class MemberViewController: UITableViewController {
    
    let logTag = OSLog(subsystem: "SaintsXCTF.App.MemberViewController",
                       category: "MemberViewController")
    
    @IBOutlet var memberTableView: UITableView!
    
    var passedGroup: Group? = nil
    var members: [GroupMember] = [GroupMember]()
    let heightDict = NSMutableDictionary()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        os_log("MainViewController Loaded.", log: logTag, type: .debug)
        
        navigationController?.navigationBar.backgroundColor = UIColor(0x999999, a: 0.9)
        
        // Set the navigation bar back button to a custom image
        navigationController?.navigationBar.backIndicatorImage = UIImage(named: "back")
        navigationController?.navigationBar.backIndicatorTransitionMaskImage = UIImage(named: "back")
        navigationController?.navigationBar.tintColor = UIColor(0x000000)
        
        navigationItem.backBarButtonItem = UIBarButtonItem(title: " ", style:
            UIBarButtonItemStyle.plain, target: nil, action: nil)
        
        // Setting the row height to UITableViewAutomaticDimension tells the TableView to determine the
        // height of a cell based on its contents and constraints.
        memberTableView.rowHeight = UITableViewAutomaticDimension
        
        if let group: Group = passedGroup {
            navigationItem.title = group.group_title!
            
            // Build the members array
            members = group.members!
            
            // Filter the members array so only accepted members show up
            members = members.filter { $0.status ?? "" == "accepted" }
            
            self.memberTableView.reloadData()
        }
    }
    
    // Returns the number of rows that the tableview should display
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return members.count
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
    }
    
    // Ask the datasource for a cell to insert at a certain location in the table view
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
            as! MemberTableViewCell
        let member: GroupMember = members[indexPath.row]
        
        cell.nameLabel.text = "\(member.first!) \(member.last!)"
        
        // Format the member join date
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        
        let formattedDate = dateFormatter.date(from: member.member_since)!
        dateFormatter.dateFormat = "MMM dd, yyyy"
        
        cell.memberSinceLabel.text = dateFormatter.string(from: formattedDate)
        
        cell.setStyle()
        
        return cell
    }
}
