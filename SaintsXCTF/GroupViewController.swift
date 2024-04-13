//
//  GroupViewController.swift
//  SaintsXCTF
//
//  Created by Andy Jarombek on 10/7/17.
//  Copyright © 2017 Andy Jarombek. All rights reserved.
//

import UIKit
import os.log

/**
 Class controlling logic for the view displaying a group.
 - Important:
 ## Extends the following class:
 - UIViewController: provides behavior shared between all classes that manage a view
 
 ## Implements the following protocols:
 - UIGestureRecognizerDelegate: methods invoked by the gesture recognizer on a view
 */
class GroupViewController: UIViewController, UIGestureRecognizerDelegate {
    
    let logTag = OSLog(subsystem: "SaintsXCTF.App.GroupViewController",
                       category: "GroupViewController")
    
    @IBOutlet weak var groupImageView: UIImageView!
    @IBOutlet weak var groupTitleView: UILabel!
    @IBOutlet weak var groupDescriptionView: UITextView!
    
    
    @IBOutlet weak var logsView: UIView!
    @IBOutlet weak var logsButton: UIButton!
    @IBOutlet weak var logsIcon: UIButton!
    @IBOutlet weak var leaderboardsView: UIView!
    @IBOutlet weak var leaderboardsButton: UIButton!
    @IBOutlet weak var leaderboardsIcon: UIButton!
    @IBOutlet weak var membersView: UIView!
    @IBOutlet weak var membersButton: UIButton!
    @IBOutlet weak var membersIcon: UIButton!
    @IBOutlet weak var adminView: UIView!
    @IBOutlet weak var adminButton: UIButton!
    @IBOutlet weak var adminIcon: UIButton!
    
    var group: Group? = nil
    var groupname = ""
    
    /**
     Invoked when the GroupViewController loads
     */
    override func viewDidLoad() {
        super.viewDidLoad()
        os_log("GroupViewController Loaded.", log: logTag, type: .debug)
        
        navigationController?.navigationBar.backgroundColor = UIColor(0x990000, a: 0.9)
        
        // Set the navigation bar back button to a custom image
        navigationController?.navigationBar.backIndicatorImage = UIImage(named: "back")
        navigationController?.navigationBar.backIndicatorTransitionMaskImage = UIImage(named: "back")
        navigationController?.navigationBar.tintColor = UIColor(0xFFFFFF)
        
        navigationItem.backBarButtonItem = UIBarButtonItem(title: " ", style:
            UIBarButtonItem.Style.plain, target: nil, action: nil)
        
        if self.traitCollection.userInterfaceStyle == .dark {
            logsButton.tintColor = .white
            leaderboardsButton.tintColor = .white
            membersButton.tintColor = .white
            adminButton.tintColor = .white
            
            logsIcon.tintColor = UIColor(0xE60000)
            leaderboardsIcon.tintColor = UIColor(0xE60000)
            membersIcon.tintColor = UIColor(0xE60000)
            adminIcon.tintColor = UIColor(0xE60000)
        } else {
            logsButton.tintColor = .darkGray
            leaderboardsButton.tintColor = .darkGray
            membersButton.tintColor = .darkGray
            adminButton.tintColor = .darkGray
            
            logsIcon.tintColor = UIColor(0x990000)
            leaderboardsIcon.tintColor = UIColor(0x990000)
            membersIcon.tintColor = UIColor(0x990000)
            adminIcon.tintColor = UIColor(0x990000)
        }
        
        // Hide all the views until we know which ones to show
        logsView.isHidden = true
        leaderboardsView.isHidden = true
        membersView.isHidden = true
        adminView.isHidden = true
        
        // Get the group from the API with given groupname 
        APIClient.groupGetRequest(withGroupname: groupname, inTeam: "saintsxctf", fromController: self) {
            (group) -> Void in
            
            // Put the group title in the navigation bar
            self.group = group
            self.navigationItem.title = group.group_title!
            
            // Set the group title and description
            self.groupTitleView.text = group.group_title!
            
            self.loadGroupMembers()
            
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
            
            // Set click listener to the members view to open up the group members page
            let membersclick = UITapGestureRecognizer(target: self, action: #selector(self.viewMembers(_:)))
            membersclick.delegate = self
            self.membersView.addGestureRecognizer(membersclick)
            
            let membersbuttonclick = UITapGestureRecognizer(target: self, action: #selector(self.viewMembers(_:)))
            membersbuttonclick.delegate = self
            self.membersButton.addGestureRecognizer(membersbuttonclick)
            
            // Set click listener to the admin view to open up the group logs page
            // let adminclick = UITapGestureRecognizer(target: self, action: #selector(self.viewAdmin(_:)))
            // adminclick.delegate = self
            // self.adminView.addGestureRecognizer(adminclick)
            
            // let adminbuttonclick = UITapGestureRecognizer(target: self, action: #selector(self.viewAdmin(_:)))
            // adminbuttonclick.delegate = self
            // self.adminButton.addGestureRecognizer(adminbuttonclick)
        }
        
        // Create top borders for all the group selections
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
        
        // let adminTopBorder = CALayer()
        // adminTopBorder.frame = CGRect.init(x: -20, y: 0, width: view.frame.width + 20, height: 1)
        // adminTopBorder.backgroundColor = UIColor(0xBBBBBB).cgColor
        
        let membersBottomBorder = CALayer()
        membersBottomBorder.frame = CGRect.init(x: -20, y: membersView.frame.height + 1,
                                               width: view.frame.width + 20, height: 1)
        membersBottomBorder.backgroundColor = UIColor(0xBBBBBB).cgColor
        
        logsView.layer.addSublayer(topBorder)
        leaderboardsView.layer.addSublayer(leaderboardsTopBorder)
        membersView.layer.addSublayer(membersTopBorder)
        // adminView.layer.addSublayer(adminTopBorder)
        membersView.layer.addSublayer(membersBottomBorder)
    }
    
    func loadGroupMembers() {
        APIClient.groupMembersGetRequest(withGroupname: groupname, inTeam: "saintsxctf", fromController: self) {
            (groupMembers: [GroupMember]?) -> Void in
            
            var members: [GroupMember] = groupMembers ?? []
            self.group!.members = members
            
            // Filter the members array so only accepted members show up
            members = members.filter { $0.status ?? "" == "accepted" }
            
            let memberCount: Int = members.count
            let description = self.group!.group_description ?? ""
            
            self.groupDescriptionView.text = "Members: \(memberCount)\n\n\(description)"
            
            // Set the group picture
            if let groupPictureName = self.group!.grouppic_name {
                
                let url = URL(string: "\(UassetClient.baseUrl)/group/\(self.groupname)/\(groupPictureName)")
                
                DispatchQueue.global().async {
                    let data = try? Data(contentsOf: url!)
                    
                    if data != nil {
                        DispatchQueue.main.async {
                            // Display the group picture image
                            self.groupImageView.image = UIImage(data: data!)
                        }
                    }
                }
            }
            
            // Get the member info for the currently signed in user
            let user: User = SignedInUser.user
            let member: [GroupMember] = members.filter { $0.username! == user.username! }
            
            // Unhide the always visible buttons
            self.logsView.isHidden = false
            self.leaderboardsView.isHidden = false
            self.membersView.isHidden = false
            
            // Hide message button if the signed in user is not an accepted member,
            // Hide admin button if the signed in user is not an admin
            if member.count == 0 || member[0].status! != "accepted" {
                
                let membersBottomBorder = CALayer()
                membersBottomBorder.frame = CGRect.init(x: -20, y: self.membersView.frame.height + 1,
                                                        width: self.view.frame.width + 20, height: 1)
                membersBottomBorder.backgroundColor = UIColor(0xBBBBBB).cgColor
                
                self.membersView.layer.addSublayer(membersBottomBorder)
                
            } else if member[0].user! != "admin" {
                self.membersView.isHidden = false
                
                let membersBottomBorder = CALayer()
                membersBottomBorder.frame = CGRect.init(
                    x: -20,
                    y: self.membersView.frame.height + 1,
                    width: self.view.frame.width + 20,
                    height: 1
                )
                membersBottomBorder.backgroundColor = UIColor(0xBBBBBB).cgColor
                
                self.membersView.layer.addSublayer(membersBottomBorder)
                
            } else {
                // Temporarily hide the admin view
                // self.adminView.isHidden = false
            }
        }
    }
    
    /**
     Navigate to the Logs page for the group
     - parameters:
     - sender: the view that invoked this function (logsView)
     */
    @objc func viewLogs(_ sender: UIView) {
        os_log("View Group Logs", log: logTag, type: .debug)
        
        let mainViewController = storyboard?.instantiateViewController(withIdentifier:
            "showLogView") as! MainViewController
        
        // Pass the parameter types and group to the main view controller
        mainViewController.paramType = "group"
        mainViewController.sortParam = "\(group?.id ?? 0)"
        mainViewController.showNavBar = true
        mainViewController.groupPassed = group ?? nil
        
        navigationController?.pushViewController(mainViewController, animated: true)
    }
    
    /**
     Navigate to the Leaderboards page for the group
     - parameters:
     - sender: the view that invoked this function (leaderboardsView)
     */
    @objc func viewLeaderboards(_ sender: UIView) {
        os_log("View Group Leaderboards", log: logTag, type: .debug)
        
        let leaderboardViewController = storyboard?.instantiateViewController(withIdentifier:
            "leaderboardViewController") as! LeaderboardViewController
        
        // Pass the group to the leaderboard view controller
        leaderboardViewController.passedGroup = group ?? nil
        
        navigationController?.pushViewController(leaderboardViewController, animated: true)
    }
    
    /**
     Navigate to the Members page for the group
     - parameters:
     - sender: the view that invoked this function (membersView)
     */
    @objc func viewMembers(_ sender: UIView) {
        os_log("View Group Members", log: logTag, type: .debug)
        
        let memberViewController = storyboard?.instantiateViewController(withIdentifier:
            "memberViewController") as! MemberViewController
        
        // Pass the group to the member view controller
        memberViewController.passedGroup = group ?? nil
        
        navigationController?.pushViewController(memberViewController, animated: true)
    }
    
    /**
     Navigate to the Admin page for the group
     - parameters:
     - sender: the view that invoked this function (adminView)
     */
    @objc func viewAdmin(_ sender: UIView) {
        os_log("View Group Admin Page", log: logTag, type: .debug)
        
        let adminViewController = storyboard?.instantiateViewController(withIdentifier:
            "adminViewController") as! AdminViewController
        
        // Pass the group to the admin view controller
        adminViewController.passedGroup = group ?? nil
        
        navigationController?.pushViewController(adminViewController, animated: true)
    }
}
