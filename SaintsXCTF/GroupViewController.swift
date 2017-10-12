//
//  GroupViewController.swift
//  SaintsXCTF
//
//  Created by Andy Jarombek on 10/7/17.
//  Copyright © 2017 Andy Jarombek. All rights reserved.
//

import UIKit
import os.log

class GroupViewController: UIViewController, UIGestureRecognizerDelegate {
    
    let logTag = OSLog(subsystem: "SaintsXCTF.App.GroupViewController",
                       category: "GroupViewController")
    
    @IBOutlet weak var groupImageView: UIImageView!
    @IBOutlet weak var groupTitleView: UILabel!
    @IBOutlet weak var groupDescriptionView: UITextView!
    
    
    @IBOutlet weak var logsView: UIView!
    @IBOutlet weak var logsButton: UIButton!
    @IBOutlet weak var leaderboardsView: UIView!
    @IBOutlet weak var leaderboardsButton: UIButton!
    @IBOutlet weak var messagesView: UIView!
    @IBOutlet weak var messagesButton: UIButton!
    @IBOutlet weak var membersView: UIView!
    @IBOutlet weak var membersButton: UIButton!
    @IBOutlet weak var adminView: UIView!
    @IBOutlet weak var adminButton: UIButton!
    
    var group: Group? = nil
    var groupname = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        os_log("GroupViewController Loaded.", log: logTag, type: .debug)
        
        navigationController?.navigationBar.backgroundColor = UIColor(0x999999, a: 0.9)
        
        // Set the navigation bar back button to a custom image
        navigationController?.navigationBar.backIndicatorImage = UIImage(named: "back")
        navigationController?.navigationBar.backIndicatorTransitionMaskImage = UIImage(named: "back")
        navigationController?.navigationBar.tintColor = UIColor(0x000000)
        
        navigationItem.backBarButtonItem = UIBarButtonItem(title: " ", style:
            UIBarButtonItemStyle.plain, target: nil, action: nil)
        
        // Get the group from the API with given groupname 
        APIClient.groupGetRequest(withGroupname: groupname) {
            (group) -> Void in
            
            // Put the group title in the navigation bar
            self.group = group
            self.navigationItem.title = group.group_title!
            
            // Set the group title and description
            self.groupTitleView.text = group.group_title!
            
            let members: [GroupMember] = group.members!
            let memberCount: Int = members.count
            let description = group.group_description ?? ""
            
            self.groupDescriptionView.text = "Members: \(memberCount)\n\n\(description)"
            
            // Set the group picture
            if let groupPicBase64 = group.grouppic {
                
                // Part of the base 64 encoding is html specific, remove this piece
                let index = groupPicBase64.index(groupPicBase64.startIndex, offsetBy: 23)
                let base64 = groupPicBase64.substring(from: index)
                
                // Now decode the base 64 encoded string and convert it to an image
                let groupPicData: Data = Data(base64Encoded: base64, options: .ignoreUnknownCharacters)!
                let groupPic: UIImage = UIImage(data: groupPicData)!
                
                // Display the group picture image
                self.groupImageView.image = groupPic
            }
            
            // Set click listener to the logs view to open up the group logs page
            let click = UITapGestureRecognizer(target: self, action: #selector(self.viewLogs(_:)))
            click.delegate = self
            self.logsView.addGestureRecognizer(click)
            
            let buttonclick = UITapGestureRecognizer(target: self, action: #selector(self.viewLogs(_:)))
            buttonclick.delegate = self
            self.logsButton.addGestureRecognizer(buttonclick)
            
            // Set click listener to the leaderboards view to open up the group leaderboards page
            let leaderboardclick = UITapGestureRecognizer(target: self,
                                                          action: #selector(self.viewLeaderboards(_:)))
            leaderboardclick.delegate = self
            self.leaderboardsView.addGestureRecognizer(leaderboardclick)
            
            let leaderboardbuttonclick = UITapGestureRecognizer(target: self,
                                                                action: #selector(self.viewLeaderboards(_:)))
            leaderboardbuttonclick.delegate = self
            self.leaderboardsButton.addGestureRecognizer(leaderboardbuttonclick)
            
            // Set click listener to the messages view to open up the group messages page
            let messagesclick = UITapGestureRecognizer(target: self, action: #selector(self.viewMessages(_:)))
            messagesclick.delegate = self
            self.messagesView.addGestureRecognizer(messagesclick)
            
            let messagesbuttonclick = UITapGestureRecognizer(target: self, action: #selector(self.viewMessages(_:)))
            messagesbuttonclick.delegate = self
            self.messagesButton.addGestureRecognizer(messagesbuttonclick)
            
            // Set click listener to the members view to open up the group members page
            let membersclick = UITapGestureRecognizer(target: self, action: #selector(self.viewMembers(_:)))
            membersclick.delegate = self
            self.membersView.addGestureRecognizer(membersclick)
            
            let membersbuttonclick = UITapGestureRecognizer(target: self, action: #selector(self.viewMembers(_:)))
            membersbuttonclick.delegate = self
            self.membersButton.addGestureRecognizer(membersbuttonclick)
            
            // Set click listener to the logs view to open up the group logs page
            let adminclick = UITapGestureRecognizer(target: self, action: #selector(self.viewAdmin(_:)))
            adminclick.delegate = self
            self.adminView.addGestureRecognizer(adminclick)
            
            let adminbuttonclick = UITapGestureRecognizer(target: self, action: #selector(self.viewAdmin(_:)))
            adminbuttonclick.delegate = self
            self.adminButton.addGestureRecognizer(adminbuttonclick)
        }
        
        // Create top borders for all the profile selections
        let topBorder = CALayer()
        topBorder.frame = CGRect.init(x: -20, y: 0, width: view.frame.width + 20, height: 1)
        topBorder.backgroundColor = UIColor(0xBBBBBB).cgColor
        
        let leaderboardsTopBorder = CALayer()
        leaderboardsTopBorder.frame = CGRect.init(x: -20, y: 0, width: view.frame.width + 20, height: 1)
        leaderboardsTopBorder.backgroundColor = UIColor(0xBBBBBB).cgColor
        
        let messagesTopBorder = CALayer()
        messagesTopBorder.frame = CGRect.init(x: -20, y: 0, width: view.frame.width + 20, height: 1)
        messagesTopBorder.backgroundColor = UIColor(0xBBBBBB).cgColor
        
        let membersTopBorder = CALayer()
        membersTopBorder.frame = CGRect.init(x: -20, y: 0, width: view.frame.width + 20, height: 1)
        membersTopBorder.backgroundColor = UIColor(0xBBBBBB).cgColor
        
        let adminTopBorder = CALayer()
        adminTopBorder.frame = CGRect.init(x: -20, y: 0, width: view.frame.width + 20, height: 1)
        adminTopBorder.backgroundColor = UIColor(0xBBBBBB).cgColor
        
        // Weekly bottom border for other profiles that dont show the edit view
        let adminBottomBorder = CALayer()
        adminBottomBorder.frame = CGRect.init(x: -20, y: adminView.frame.height + 1,
                                               width: view.frame.width + 20, height: 1)
        adminBottomBorder.backgroundColor = UIColor(0xBBBBBB).cgColor
        
        logsView.layer.addSublayer(topBorder)
        leaderboardsView.layer.addSublayer(leaderboardsTopBorder)
        messagesView.layer.addSublayer(messagesTopBorder)
        membersView.layer.addSublayer(membersTopBorder)
        adminView.layer.addSublayer(adminTopBorder)
        adminView.layer.addSublayer(adminBottomBorder)
    }
    
    func viewLogs(_ sender: UIView) {
        os_log("View Group Logs", log: logTag, type: .debug)
        
        let mainViewController = storyboard?.instantiateViewController(withIdentifier:
            "showLogView") as! MainViewController
        
        // Pass the parameter types and group to the main view controller
        mainViewController.paramType = "group"
        mainViewController.sortParam = group?.group_name ?? ""
        mainViewController.showNavBar = true
        mainViewController.groupPassed = group ?? nil
        
        navigationController?.pushViewController(mainViewController, animated: true)
    }
    
    func viewLeaderboards(_ sender: UIView) {
        os_log("View Group Leaderboards", log: logTag, type: .debug)
        
        let leaderboardViewController = storyboard?.instantiateViewController(withIdentifier:
            "leaderboardViewController") as! LeaderboardViewController
        
        // Pass the group to the leaderboard view controller
        leaderboardViewController.passedGroup = group ?? nil
        
        navigationController?.pushViewController(leaderboardViewController, animated: true)
    }
    
    func viewMessages(_ sender: UIView) {
        os_log("View Group Messages", log: logTag, type: .debug)
        
        let messageViewController = storyboard?.instantiateViewController(withIdentifier:
            "messageViewController") as! MessageViewController
        
        // Pass the group to the message view controller
        messageViewController.passedGroup = group ?? nil
        
        navigationController?.pushViewController(messageViewController, animated: true)
    }
    
    func viewMembers(_ sender: UIView) {
        os_log("View Group Members", log: logTag, type: .debug)
    }
    
    func viewAdmin(_ sender: UIView) {
        os_log("View Group Admin Page", log: logTag, type: .debug)
    }
}
