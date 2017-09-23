//
//  PickGroupController.swift
//  SaintsXCTF
//
//  Created by Andy Jarombek on 8/12/17.
//  Copyright © 2017 Andy Jarombek. All rights reserved.
//

import UIKit
import os.log

class PickGroupController: UIViewController {
    
    let logTag = OSLog(subsystem: "SaintsXCTF.App.PickGroupViewController",
                       category: "PickGroupViewController")
    
    
    @IBOutlet weak var alumniButton: UIButton!
    @IBOutlet weak var womenstfButton: UIButton!
    @IBOutlet weak var menstfButton: UIButton!
    @IBOutlet weak var womensxcButton: UIButton!
    @IBOutlet weak var mensxcButton: UIButton!
    
    var mensxc = false, wmensxc = false, menstf = false,
        wmenstf = false, alumni = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        os_log("PickGroupViewController Loaded.", log: OSLog.default, type: .debug)
        
        // Programatically set the radiuses of all the buttons
        mensxcButton.layer.cornerRadius = 4
        womensxcButton.layer.cornerRadius = 4
        menstfButton.layer.cornerRadius = 4
        womenstfButton.layer.cornerRadius = 4
        alumniButton.layer.cornerRadius = 4
        
        mensxcButton.backgroundColor = UIColor(0xEEEEEE)
        womensxcButton.backgroundColor = UIColor(0xEEEEEE)
        menstfButton.backgroundColor = UIColor(0xEEEEEE)
        womenstfButton.backgroundColor = UIColor(0xEEEEEE)
        alumniButton.backgroundColor = UIColor(0xEEEEEE)
    }
    
    // Remove the keyboard when tapping the background
    @IBAction func backgroundTapped(_ sender: UITapGestureRecognizer) {
        view.endEditing(true)
    }
    
    // Functions for clicking group buttons.
    // Joined -> Change to Grey Background, Disable Conflicting Groups
    // Unjoined -> Change to White Background, Check for Resolved Conflicts
    
    @IBAction func mensxcSelected(_ sender: UIButton) {
        mensxc = !mensxc
        
        if (mensxc) {
            mensxcButton.backgroundColor = UIColor(0xCCCCCC)
            womensxcButton.isEnabled = false
            womenstfButton.isEnabled = false
        } else {
            mensxcButton.backgroundColor = UIColor(0xEEEEEE)
            if (!menstf) {
                womensxcButton.isEnabled = true
                womenstfButton.isEnabled = true
            }
        }
    }
    
    @IBAction func womensxcSelected(_ sender: UIButton) {
        wmensxc = !wmensxc
        
        if (wmensxc) {
            womensxcButton.backgroundColor = UIColor(0xCCCCCC)
            mensxcButton.isEnabled = false
            menstfButton.isEnabled = false
        } else {
            womensxcButton.backgroundColor = UIColor(0xEEEEEE)
            if (!wmenstf) {
                mensxcButton.isEnabled = true
                menstfButton.isEnabled = true
            }
        }
    }
    
    @IBAction func womenstfSelected(_ sender: UIButton) {
        wmenstf = !wmenstf
        
        if (wmenstf) {
            womenstfButton.backgroundColor = UIColor(0xCCCCCC)
            mensxcButton.isEnabled = false
            menstfButton.isEnabled = false
        } else {
            womenstfButton.backgroundColor = UIColor(0xEEEEEE)
            if (!wmensxc) {
                mensxcButton.isEnabled = true
                menstfButton.isEnabled = true
            }
        }
    }
    
    @IBAction func menstfSelected(_ sender: UIButton) {
        menstf = !menstf
        
        if (menstf) {
            menstfButton.backgroundColor = UIColor(0xCCCCCC)
            womensxcButton.isEnabled = false
            womenstfButton.isEnabled = false
        } else {
            menstfButton.backgroundColor = UIColor(0xEEEEEE)
            if (!mensxc) {
                womenstfButton.isEnabled = true
                womensxcButton.isEnabled = true
            }
        }
    }
    
    @IBAction func alumniSelected(_ sender: UIButton) {
        alumni = !alumni
        
        if (alumni) {
            alumniButton.backgroundColor = UIColor(0xCCCCCC)
        } else {
            alumniButton.backgroundColor = UIColor(0xEEEEEE)
        }
    }
    
    @IBAction func pickGroups(_ sender: UIButton) {
        _ = SignedInUser()
        let user = SignedInUser.user
        let username = user.username!
        
        // In swift classes are pass by reference, so changing the altered user in addGroups
        // points back to this user object
        addGroups(user)
        
        APIClient.userPutRequest(withUsername: username, andUser: user) {
            (user) -> Void in
                
            os_log("Users picked groups: %@", log: self.logTag, type: .debug, user.groups)
            
            // Save the user picked groups data
            SignedInUser.user = user
            let savedUser = SignedInUser.saveUser()
            
            if (savedUser) {
                os_log("Saved Updated User to Persistant Storage.", log: self.logTag, type: .debug)
            } else {
                os_log("Failed to Save Updated User to Persistant Storage",
                       log: self.logTag, type: .error)
            }
            
            // Redirect to the main page
            let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
            let mainViewController = storyBoard.instantiateViewController(withIdentifier:
                "mainViewController") as! UITabBarController
            self.present(mainViewController, animated: true, completion: nil)
            
            // Send a notification to the picked group admins
            user.groups.forEach {
                groupinfo in
                
                if let groupname: String = groupinfo.group_name {
                    
                    // Find the admins for this group and send a notification to each of them
                    self.findGroupAdmins(withGroupname: groupname, forUser: user)
                }
            }
        }
    }
    
    // Find the admins for a given group and create a notification for them
    func findGroupAdmins(withGroupname groupname: String, forUser user: User) {
        APIClient.groupGetRequest(withGroupname: groupname) {
            (group) -> Void in
            
            let members: [GroupMember] = group.members!
            
            members.forEach {
                member in
                
                if member.user == "admin" {
                    let name = "\(member.first!) \(member.last!)"
                    os_log("Sending Notification to Admin %@", log: self.logTag, type: .debug, name)
                    
                    let notification = Notification()
                    notification.username = member.username
                    notification.link = "https://www.saintsxctf.com/group.php?name=\(group.group_name!)"
                    notification.notification_description = "\(user.first!) \(user.last) Has Requested to " +
                                                            "Join \(group.group_title!)"
                    notification.viewed = "N"
                    
                    self.sendAdminNotification(notification)
                }
            }
        }
    }
    
    // Send a create notification request to the API
    func sendAdminNotification(_ notification: Notification) {
        
        APIClient.notificationPostRequest(withNotification: notification) {
            (newnotification) -> Void in
            
            os_log("New Notification Sent: %@", log: self.logTag, type: .debug, newnotification.description)
        }
    }
    
    func addGroups(_ user: User) {
        if (mensxc) {
            let mensxcInfo = GroupInfo()
            mensxcInfo.group_name = "mensxc"
            mensxcInfo.group_title = "Men's Cross Country"
            mensxcInfo.status = "pending"
            mensxcInfo.user = "user"
            
            user.groups.append(mensxcInfo)
        }
        
        if (wmensxc) {
            let wmensxcInfo = GroupInfo()
            wmensxcInfo.group_name = "wmensxc"
            wmensxcInfo.group_title = "Women's Cross Country"
            wmensxcInfo.status = "pending"
            wmensxcInfo.user = "user"
            
            user.groups.append(wmensxcInfo)
        }
        
        if (menstf) {
            let menstfInfo = GroupInfo()
            menstfInfo.group_name = "mensxf"
            menstfInfo.group_title = "Men's Track & Field"
            menstfInfo.status = "pending"
            menstfInfo.user = "user"
            
            user.groups.append(menstfInfo)
        }
        
        if (wmenstf) {
            let wmenstfInfo = GroupInfo()
            wmenstfInfo.group_name = "wmenstf"
            wmenstfInfo.group_title = "Women's Track & Field"
            wmenstfInfo.status = "pending"
            wmenstfInfo.user = "user"
            
            user.groups.append(wmenstfInfo)
        }
        
        if (alumni) {
            let alumniInfo = GroupInfo()
            alumniInfo.group_name = "alumni"
            alumniInfo.group_title = "Alumni"
            alumniInfo.status = "pending"
            alumniInfo.user = "user"
            
            user.groups.append(alumniInfo)
        }
    }
}
