//
//  PickGroupController.swift
//  SaintsXCTF
//
//  Created by Andy Jarombek on 8/12/17.
//  Copyright © 2017 Andy Jarombek. All rights reserved.
//

import UIKit
import os.log

/**
 Class controlling logic for users picking a group to join.
 - Important:
 ## Extends the following class:
 - UIViewController: provides behavior shared between all classes that manage a view
 */
class PickGroupController: UIViewController {
    
    let logTag = OSLog(subsystem: "SaintsXCTF.App.PickGroupViewController",
                       category: "PickGroupViewController")
    
    var user: User? = nil
    
    @IBOutlet weak var alumniButton: UIButton!
    @IBOutlet weak var womenstfButton: UIButton!
    @IBOutlet weak var menstfButton: UIButton!
    @IBOutlet weak var womensxcButton: UIButton!
    @IBOutlet weak var mensxcButton: UIButton!
    
    @IBOutlet weak var submitButton: UIButton!
    
    var mensxc = false, wmensxc = false, menstf = false,
        wmenstf = false, alumni = false
    var mensxcAccepted = false, wmensxcAccepted = false,
        menstfAccepted = false, wmenstfAccepted = false,
        alumniAccepted = false
    
    /**
     Invoked when the PickGroupViewController loads
     */
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
        
        // See if there is a user entered.  If so, check to see if the user is a member of any groups
        if let _: User = user {
            
            if user?.groups == nil {
                APIClient.userGroupsGetRequest(withUsername: user!.username, fromController: self) {
                    (groupInfo) -> Void in
                    
                    self.user?.groups = groupInfo
                }
            } else {
                // TODO
            }
            
            let groups: [GroupInfo] = user?.groups ?? []
            
            navigationItem.title = "Edit Groups"
            
            groups.forEach {
                (group) -> Void in
                
                // Get whether the user is accepted into the group
                let accepted: Bool = group.status == "accepted"
                    
                let groupName: String = group.group_name
                
                // Select the group that the user is a member of
                switch groupName {
                case "mensxc":
                    mensxcAccepted = accepted
                    mensxcSelected()
                case "wmensxc":
                    wmensxcAccepted = accepted
                    womensxcSelected()
                case "menstf":
                    menstfAccepted = accepted
                    menstfSelected()
                case "wmenstf":
                    wmenstfAccepted = accepted
                    womenstfSelected()
                case "alumni":
                    alumniAccepted = accepted
                    alumniSelected()
                default:
                    os_log("Invalid Group Name.", log: OSLog.default, type: .error)
                }
            }
        }
    }
    
    // Functions for clicking group buttons.
    // Joined -> Change to Grey Background, Disable Conflicting Groups
    // Unjoined -> Change to White Background, Check for Resolved Conflicts
    
    /**
     Invoked when the mensxcButton is clicked, meaning the Men's Cross Country group should be joined if
     the user isn't a member.  If the user is already a member, the user should be removed from the group.
     - parameters:
     - sender: the mensxcButton
     */
    @IBAction func mensxcSelected(_ sender: UIButton) {
        mensxcSelected()
    }
    
    /**
     Add or remove the user from the Men's Cross Country group
     */
    func mensxcSelected() {
        mensxc = !mensxc
        
        if (mensxc) {
            if mensxcAccepted {
                mensxcButton.backgroundColor = UIColor(0x990000)
            } else {
                mensxcButton.backgroundColor = UIColor(0xCCCCCC)
            }
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
    
    /**
     Invoked when the womensxcButton is clicked, meaning the Womens Cross Country group should be joined if
     the user isn't a member.  If the user is already a member, the user should be removed from the group.
     - parameters:
     - sender: the womensxcButton
     */
    @IBAction func womensxcSelected(_ sender: UIButton) {
        womensxcSelected()
    }
    
    /**
     Add or remove the user from the Women's Cross Country group
     */
    func womensxcSelected() {
        wmensxc = !wmensxc
        
        if (wmensxc) {
            if wmensxcAccepted {
                womensxcButton.backgroundColor = UIColor(0x990000)
            } else {
                womensxcButton.backgroundColor = UIColor(0xCCCCCC)
            }
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
    
    /**
     Invoked when the womenstfButton is clicked, meaning the Women's Track & Field group should be joined
     if the user isn't a member.  If the user is already a member, the user should be removed from the
     group.
     - parameters:
     - sender: the womenstfButton
     */
    @IBAction func womenstfSelected(_ sender: UIButton) {
        womenstfSelected()
    }
    
    /**
     Add or remove the user from the Women's Track & Field group
     */
    func womenstfSelected() {
        wmenstf = !wmenstf
        
        if (wmenstf) {
            if wmenstfAccepted {
                womenstfButton.backgroundColor = UIColor(0x990000)
            } else {
                womenstfButton.backgroundColor = UIColor(0xCCCCCC)
            }
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
    
    /**
     Invoked when the menstfButton is clicked, meaning the Men's Track & Field group should be joined
     if the user isn't a member.  If the user is already a member, the user should be removed from the
     group.
     - parameters:
     - sender: the menstfButton
     */
    @IBAction func menstfSelected(_ sender: UIButton) {
        menstfSelected()
    }
    
    /**
     Add or remove the user from the Men's Track & Field group
     */
    func menstfSelected() {
        menstf = !menstf
        
        if (menstf) {
            if menstfAccepted {
                menstfButton.backgroundColor = UIColor(0x990000)
            } else {
                menstfButton.backgroundColor = UIColor(0xCCCCCC)
            }
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
    
    /**
     Invoked when the alumniButton is clicked, meaning the Alumni group should be joined if
     the user isn't a member.  If the user is already a member, the user should be removed from the group.
     - parameters:
     - sender: the alumniButton
     */
    @IBAction func alumniSelected(_ sender: UIButton) {
        alumniSelected()
    }
    
    /**
     Add or remove the user from the Alumni group
     */
    func alumniSelected() {
        alumni = !alumni
        
        if (alumni) {
            if alumniAccepted {
                alumniButton.backgroundColor = UIColor(0x990000)
            } else {
                alumniButton.backgroundColor = UIColor(0xCCCCCC)
            }
        } else {
            alumniButton.backgroundColor = UIColor(0xEEEEEE)
        }
    }
    
    /**
     Invoked when the submitButton is clicked, meaning the groups for this user should be finalized.
     - parameters:
     - sender: the submitButton
     */
    @IBAction func pickGroups(_ sender: UIButton) {
        _ = SignedInUser()
        let user = SignedInUser.user
        let username = user.username!
        
        // Add a loading overlay to the pick groups on save
        var overlay: UIView?
        overlay = LoadingView(frame: CGRect(x: 0, y: 0, width: view.frame.width, height: view.frame.height))
        view.addSubview(overlay!)
        
        // Temporarily disable the submit button
        submitButton.isEnabled = false
        
        // In swift classes are pass by reference, so changing the altered user in addGroups
        // points back to this user object
        addGroups(user)
        
        APIClient.userPutRequest(withUsername: username, andUser: user, fromController: self) {
            (newuser) -> Void in
            
            if let user: User = newuser {
                
                os_log("Users picked groups: %@", log: self.logTag, type: .debug, user.groups!)
                
                // Save the user picked groups data
                SignedInUser.user = user
                let savedUser = SignedInUser.saveUser()
                
                if (savedUser) {
                    os_log("Saved Updated User to Persistant Storage.", log: self.logTag, type: .debug)
                } else {
                    os_log("Failed to Save Updated User to Persistant Storage",
                           log: self.logTag, type: .error)
                }
                
                // Re-enable button and remove loading overlay
                overlay?.removeFromSuperview()
                self.submitButton.isEnabled = true
                
                // Redirect to the main page
                let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
                let mainViewController = storyBoard.instantiateViewController(withIdentifier:
                    "mainViewController") as! UITabBarController
                self.present(mainViewController, animated: true, completion: nil)
                
                // Send a notification to the picked group admins
                user.groups?.forEach {
                    groupinfo in
                    
                    if let groupname: String = groupinfo.group_name {
                        
                        // Find the admins for this group and send a notification to each of them
                        self.findGroupAdmins(withGroupname: groupname, forUser: user)
                    }
                }
            }
        }
    }
    
    /**
     Find the admins for a given group and create a notification for them.
     - parameters:
     - groupname: the name of a group to search for admins
     - user: information about the user that is requesting to join a group
     */
    func findGroupAdmins(withGroupname groupname: String, forUser user: User) {
        APIClient.groupGetRequest(withGroupname: groupname, fromController: self) {
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
                    notification.notification_description = "\(user.first!) \(user.last ?? "") Has Requested to " +
                                                            "Join \(group.group_title!)"
                    notification.viewed = "N"
                    
                    self.sendAdminNotification(notification)
                }
            }
        }
    }
    
    /**
     Send a create notification request to the API.  In this context, the notification tells an admin
     that a user is requesting to join their group.
     - parameters:
     - groupname: a notification object to send to the API
     */
    func sendAdminNotification(_ notification: Notification) {
        
        APIClient.notificationPostRequest(withNotification: notification, fromController: self) {
            (newnotification) -> Void in
            
            os_log("New Notification Sent: %@", log: self.logTag, type: .debug, newnotification.description)
        }
    }
    
    /**
     Add groups to a user object
     - parameters:
     - user: the exiting information about a user
     */
    func addGroups(_ user: User) {
        if (mensxc) {
            let mensxcInfo = GroupInfo()
            mensxcInfo.group_name = "mensxc"
            mensxcInfo.group_title = "Men's Cross Country"
            
            let mensxcStatus = mensxcAccepted ? "accepted" : "pending"
            mensxcInfo.status = mensxcStatus
            
            mensxcInfo.user = "user"
            
            user.groups?.append(mensxcInfo)
        }
        
        if (wmensxc) {
            let wmensxcInfo = GroupInfo()
            wmensxcInfo.group_name = "wmensxc"
            wmensxcInfo.group_title = "Women's Cross Country"
            
            let wmensxcStatus = wmensxcAccepted ? "accepted" : "pending"
            wmensxcInfo.status = wmensxcStatus
            
            wmensxcInfo.user = "user"
            
            user.groups?.append(wmensxcInfo)
        }
        
        if (menstf) {
            let menstfInfo = GroupInfo()
            menstfInfo.group_name = "mensxf"
            menstfInfo.group_title = "Men's Track & Field"
            
            let menstfStatus = menstfAccepted ? "accepted" : "pending"
            menstfInfo.status = menstfStatus
            
            menstfInfo.user = "user"
            
            user.groups?.append(menstfInfo)
        }
        
        if (wmenstf) {
            let wmenstfInfo = GroupInfo()
            wmenstfInfo.group_name = "wmenstf"
            wmenstfInfo.group_title = "Women's Track & Field"
            
            let wmenstfStatus = wmenstfAccepted ? "accepted" : "pending"
            wmenstfInfo.status = wmenstfStatus
            
            wmenstfInfo.user = "user"
            
            user.groups?.append(wmenstfInfo)
        }
        
        if (alumni) {
            let alumniInfo = GroupInfo()
            alumniInfo.group_name = "alumni"
            alumniInfo.group_title = "Alumni"
            
            let alumniStatus = alumniAccepted ? "accepted" : "pending"
            alumniInfo.status = alumniStatus
            
            alumniInfo.user = "user"
            
            user.groups?.append(alumniInfo)
        }
    }
}
