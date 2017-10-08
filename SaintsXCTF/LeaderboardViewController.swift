//
//  LeaderboardViewController.swift
//  SaintsXCTF
//
//  Created by Andy Jarombek on 10/8/17.
//  Copyright © 2017 Andy Jarombek. All rights reserved.
//

import UIKit
import os.log

class LeaderboardViewController: UITableViewController {
    
    let logTag = OSLog(subsystem: "SaintsXCTF.App.LeaderboardViewController",
                       category: "LeaderboardViewController")
    
    @IBOutlet weak var leaderboardTableView: UITableView!
    
    var passedGroup: Group? = nil
    var leaderboardItems: [LeaderboardItem] = []
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
        
        // Set up the view for the leaderboard filters
        var overlay: UIView?
        overlay = UIView(frame: CGRect(x: 0, y: 0, width: view.frame.width, height: 150))
        overlay?.backgroundColor = UIColor(0xCCCCCC)
        navigationController?.view.insertSubview(overlay!,
                                                 belowSubview: (self.navigationController?.navigationBar)!)
        
        // Setting the row height to UITableViewAutomaticDimension tells the TableView to determine the
        // height of a cell based on its contents and constraints.
        leaderboardTableView.rowHeight = UITableViewAutomaticDimension
        
        if let group: Group = passedGroup {
            navigationItem.title = group.group_title!
            
            leaderboardItems = group.leaderboards["miles"]!
        }
    }
    
    // Returns the number of rows that the tableview should display
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return leaderboardItems.count
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
                        as! LeaderboardTableViewCell
        let leaderboardItem: LeaderboardItem = leaderboardItems[indexPath.row]
        
        cell.nameLabel.text = "\(indexPath.row + 1)) \(leaderboardItem.first!) \(leaderboardItem.last!)"
        let distanceDouble = Double(leaderboardItem.milesrun)!
        let distance = String(format: "%.2f", distanceDouble)
        cell.distanceLabel.text = "\(distance) Miles"
        
        cell.setStyle()
        
        return cell
    }
}
