//
//  AdminViewController.swift
//  SaintsXCTF
//
//  Created by Andy Jarombek on 10/13/17.
//  Copyright © 2017 Andy Jarombek. All rights reserved.
//

import UIKit
import os.log
import PopupDialog

class AdminViewController: UIViewController, UIPickerViewDelegate {
    
    let logTag = OSLog(subsystem: "SaintsXCTF.App.MemberViewController",
                       category: "MemberViewController")
    
    @IBOutlet weak var addUserField: UITextField!
    @IBOutlet weak var addUserAcceptButton: UIButton!
    @IBOutlet weak var addUserRejectButton: UIButton!
    @IBOutlet weak var sendRequestField: UITextField!
    @IBOutlet weak var sendRequestButton: UIButton!
    @IBOutlet weak var nameFlairField: UITextField!
    @IBOutlet weak var flairField: UITextField!
    @IBOutlet weak var giveFlairButton: UIButton!
    @IBOutlet weak var notificationField: UITextField!
    @IBOutlet weak var notificationButton: UIButton!
    @IBOutlet weak var errorField: UILabel!
    
    var passedGroup: Group? = nil
    var groupname: String = ""
    var grouptitle: String = ""
    var addUserPicker: UIPickerView!
    var flairPicker: UIPickerView!
    
    var members: [GroupMember] = [GroupMember]()
    var pendingMembers: [GroupMember] = [GroupMember]()
    var pendingNames: [String] = [String]()
    
    var acceptedMembers: [GroupMember] = [GroupMember]()
    var acceptedNames: [String] = [String]()
    
    let regexEmail = "^(([a-zA-Z0-9_.-])+@([a-zA-Z0-9_.-])+\\.([a-zA-Z])+([a-zA-Z])+)?$"
    
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
        
        addUserField.standardStyle()
        sendRequestField.standardStyle()
        nameFlairField.standardStyle()
        flairField.standardStyle()
        notificationField.standardStyle()
        
        if let group: Group = passedGroup {
            navigationItem.title = group.group_title!
            
            groupname = group.group_name!
            grouptitle = group.group_title!
            members = group.members!
            
            // Get the members that have not been accepted into the group yet
            pendingMembers = members.filter { $0.status == "pending" }
            pendingNames = pendingMembers.map { "\($0.first!) \($0.last!)" }
            
            // Get the members that have been accepted
            acceptedMembers = members.filter { $0.status == "accepted" }
            acceptedNames = acceptedMembers.map { "\($0.first!) \($0.last!)" }
            
            isPendingUsers()
        }
        
        // Create a view to hold the add user picker and the done button
        let addUserInputView = UIView(frame: CGRect(x: 0, y: 0, width: self.view.frame.width, height: 240))
        
        // Set the picker view for time filter
        addUserPicker = UIPickerView(frame: CGRect(x: 0, y: 40, width: 0, height: 0))
        addUserPicker.delegate = self
        
        addUserInputView.addSubview(addUserPicker)
        addUserField.inputView = addUserPicker
        addUserField.text = pendingNames.count > 0 ? pendingNames[0] : ""
        
        let addUserToolbar = UIToolbar().PickerToolbar(selector: #selector(self.dismissKeyboard))
        addUserField.inputAccessoryView = addUserToolbar
        
        // Hide the colored cursor when the addUserField is selected
        addUserField.tintColor = .clear
        
        // Create a view to hold the flair picker and the done button
        let flairInputView = UIView(frame: CGRect(x: 0, y: 0, width: self.view.frame.width, height: 240))
        
        // Set the picker view for flair names
        flairPicker = UIPickerView(frame: CGRect(x: 0, y: 40, width: 0, height: 0))
        flairPicker.delegate = self
        
        flairInputView.addSubview(flairPicker)
        nameFlairField.inputView = flairPicker
        nameFlairField.text = acceptedNames.count > 0 ? acceptedNames[0] : ""
        
        let flairToolbar = UIToolbar().PickerToolbar(selector: #selector(self.dismissKeyboard))
        nameFlairField.inputAccessoryView = flairToolbar
        
        // Hide the colored cursor when the nameFlairField is selected
        nameFlairField.tintColor = .clear
    }
    
    // Called when the done button on the keyboard is clicked
    func dismissKeyboard() {
        view.endEditing(true)
    }
    
    // Return the number of components in the UIPicker
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    // Return the number of rows in the given UIPicker
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if pickerView == addUserPicker {
            return pendingNames.count
        } else if pickerView == flairPicker {
            return acceptedNames.count
        } else {
            return 0
        }
    }
    
    // Return the title for the row that is to be shown in the UIPicker
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        if pickerView == addUserPicker {
            return pendingNames[row]
        } else if pickerView == flairPicker {
            return acceptedNames[row]
        } else {
            return nil
        }
    }
    
    // Dislay the picked value from the UIPicker
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if pickerView == addUserPicker {
            addUserField.text = pendingNames[row]
        } else if pickerView == flairPicker {
            nameFlairField.text = acceptedNames[row]
        }
    }
    
    // Function hides accept/reject calls if there are no pending users
    func isPendingUsers() {
        
        if pendingNames.count == 0 {
            addUserAcceptButton.isHidden = true
            addUserRejectButton.isHidden = true
            addUserField.isHidden = true
        }
    }
    
    @IBAction func acceptUser(_ sender: UIButton) {
        
        // Add a loading overlay to the admin view on accept
        var overlay: UIView?
        overlay = LoadingView(frame: CGRect(x: 0, y: 0, width: view.frame.width, height: view.frame.height))
        view.addSubview(overlay!)
        
        addUserAcceptButton.isEnabled = false
        addUserRejectButton.isEnabled = false
    
        // Get the index of the added user
        let selectedIndex: Int = addUserPicker.selectedRow(inComponent: 0)
        
        // Change the users status to accepted
        let user: GroupMember = pendingMembers[selectedIndex]
        user.status = "accepted"
        
        var newMembers = members.filter { $0.username != user.username }
        newMembers.append(user)
        
        // Add the new groupmembers to the existing group and call the API
        if let group: Group = passedGroup {
            group.members = newMembers
            
            APIClient.groupPutRequest(withGroupname: groupname, andGroup: group) {
                newgroup -> Void in
                
                var title: String?
                var message: String?
                
                if newgroup != nil {
                    
                    // Remove the accepted user from the pending users list
                    self.pendingMembers.remove(at: selectedIndex)
                    
                    // Build the popup dialog to be displayed on success
                    title = "\(user.first!) \(user.last!) Accepted"
                    
                } else {
                
                    // Build the popup dialog to be displayed when the put request fails
                    title = "Member Accept Failed"
                    message = "Check Your Internet Connection"
                }
                
                // Actions to do when deleting a log
                let continueButton = DefaultButton(title: "Continue") {
                    
                    // If there are no more pending users, hide accept and reject calls
                    self.isPendingUsers()
                    
                    // Re-enable buttons and remove loading overlay
                    overlay?.removeFromSuperview()
                    self.addUserAcceptButton.isEnabled = true
                    self.addUserRejectButton.isEnabled = true
                }
                
                // Display the popup
                let popup = PopupDialog(title: title, message: message)
                popup.addButton(continueButton)
                
                self.present(popup, animated: true, completion: nil)
            }
        }
    }
    
    @IBAction func rejectUser(_ sender: UIButton) {
    
        // Add a loading overlay to the admin view on accept
        var overlay: UIView?
        overlay = LoadingView(frame: CGRect(x: 0, y: 0, width: view.frame.width, height: view.frame.height))
        view.addSubview(overlay!)
        
        addUserAcceptButton.isEnabled = false
        addUserRejectButton.isEnabled = false
        
        // Get the the rejected user
        let selectedIndex: Int = addUserPicker.selectedRow(inComponent: 0)
        let user: GroupMember = pendingMembers[selectedIndex]
        
        // Remove the rejected user from the members
        let newMembers = members.filter { $0.username != user.username }
        
        // Add the new groupmembers to the existing group and call the API
        if let group: Group = passedGroup {
            group.members = newMembers
            
            APIClient.groupPutRequest(withGroupname: groupname, andGroup: group) {
                newgroup -> Void in
                
                var title: String?
                var message: String?
                
                if newgroup != nil {
                    
                    // Remove the rejected user from the pending users list
                    self.pendingMembers.remove(at: selectedIndex)
                    
                    // Build the popup dialog to be displayed on success
                    title = "\(user.first!) \(user.last!) Rejected"
                    
                } else {
                    
                    // Build the popup dialog to be displayed when the put request fails
                    title = "Member Reject Failed"
                    message = "Check Your Internet Connection"
                }
                
                let continueButton = DefaultButton(title: "Continue") {
                    
                    // If there are no more pending users, hide accept and reject calls
                    self.isPendingUsers()
                    
                    // Re-enable buttons and remove loading overlay
                    overlay?.removeFromSuperview()
                    self.addUserAcceptButton.isEnabled = true
                    self.addUserRejectButton.isEnabled = true
                }
                
                // Display the popup
                let popup = PopupDialog(title: title, message: message)
                popup.addButton(continueButton)
                
                self.present(popup, animated: true, completion: nil)
            }
        }
    }
    
    @IBAction func sendEmail(_ sender: UIButton) {
        
        // Add a loading overlay to the admin view on accept
        var overlay: UIView?
        overlay = LoadingView(frame: CGRect(x: 0, y: 0, width: view.frame.width, height: view.frame.height))
        view.addSubview(overlay!)
        
        sendRequestButton.isEnabled = false
        
        if let emailString = sendRequestField.text {
            
            // Email Validation
            if (!emailString.isEmpty &&
                emailString.range(of: regexEmail, options: .regularExpression) != nil) {
                
                sendRequestField.changeStyle(.none)
                
                APIClient.activationCodePostRequest() {
                    code -> Void in
                    
                    if let activationCode: ActivationCode = code {
                        self.createEmail(withActivationCode: activationCode.activation_code!,
                                         andAddress: emailString, andOverlay: overlay)
                    } else {
                        
                        // Build the popup dialog to be displayed when the API call fails
                        let title = "Send Email Request Failed"
                        let message = "Check Your Internet Connection"
                        
                        let continueButton = DefaultButton(title: "Continue") {
                            
                            // Re-enable button and remove loading overlay
                            overlay?.removeFromSuperview()
                            self.sendRequestButton.isEnabled = true
                            
                            self.errorField.text = ""
                        }
                        
                        // Display the popup
                        let popup = PopupDialog(title: title, message: message)
                        popup.addButton(continueButton)
                        
                        self.present(popup, animated: true, completion: nil)
                    }
                }
                
            } else {
                sendRequestField.changeStyle(.error)
                errorField.text = "Invalid Email Entered"
                
                overlay?.removeFromSuperview()
                self.sendRequestButton.isEnabled = true
            }
        }
    }
    
    // Create an email with a certain activation code
    func createEmail(withActivationCode code: String, andAddress address: String, andOverlay overlay: UIView?) {
        let mail: Mail = Mail()
        mail.emailAddress = address
        mail.subject = "SaintsXCTF.com Invite"
        mail.body = "<html>" +
            "<head>" +
            "<title>HTML email</title>" +
            "</head>" +
            "<body>" +
            "<h3>SaintsXCTF.com Invite</h3>" +
            "<br><p>You Have Been Invited to SaintsXCTF.com!</p>" +
            "<br><br><p>Use the following confirmation code to sign up:</p><br>" +
            "<p><b>Code: </b>" + code + "</p>" +
            "</body>" +
        "</html>"
        
        APIClient.mailPostRequest(withMail: mail) {
            newMail -> Void in
            
            let title = "Sent Email Request to \(address)"
            
            self.sendRequestField.changeStyle(.none)
            
            let continueButton = DefaultButton(title: "Continue") {
                
                // Re-enable button and remove loading overlay
                overlay?.removeFromSuperview()
                self.sendRequestButton.isEnabled = true
                
                self.errorField.text = ""
            }
            
            // Display the popup
            let popup = PopupDialog(title: title, message: nil)
            popup.addButton(continueButton)
            
            self.present(popup, animated: true, completion: nil)
        }
    }
    
    @IBAction func giveFlair(_ sender: UIButton) {
    
        // Add a loading overlay to the admin view on accept
        var overlay: UIView?
        overlay = LoadingView(frame: CGRect(x: 0, y: 0, width: view.frame.width, height: view.frame.height))
        view.addSubview(overlay!)
        
        giveFlairButton.isEnabled = false
        
        // Get the the rejected user
        let selectedIndex: Int = flairPicker.selectedRow(inComponent: 0)
        let member: GroupMember = acceptedMembers[selectedIndex]
        let username: String = member.username!
        
        let flair: String = (flairField.text?.trimmingCharacters(in: .whitespaces))!
        
        // Call the API to get the selected user if the flair is not empty
        if !flair.isEmpty {
            
            APIClient.userGetRequest(withUsername: username) {
                user -> Void in
                
                // Now give this user the flair and send the change request to the API
                user.give_flair = flair
                
                APIClient.userPutRequest(withUsername: user.username!, andUser: user) {
                    newuser -> Void in
                    
                    var title: String?
                    var message: String?
                    
                    if let _: User = newuser {
                        
                        // Build the popup dialog to be displayed on success
                        title = "Gave Flair to \(user.first!) \(user.last!)"
                    } else {
                        
                        // Build the popup dialog to be displayed when the post request fails
                        title = "Give Flair Failed"
                        message = "Check Your Internet Connection"
                    }
                    
                    let continueButton = DefaultButton(title: "Continue") {
                        
                        self.errorField.text = ""
                        self.flairField.changeStyle(.none)
                        
                        // Re-enable button and remove loading overlay
                        overlay?.removeFromSuperview()
                        self.giveFlairButton.isEnabled = true
                    }
                    
                    // Display the popup
                    let popup = PopupDialog(title: title, message: message)
                    popup.addButton(continueButton)
                    
                    self.present(popup, animated: true, completion: nil)
                }
            }
            
        } else {
            
            // Show error message if no flair is entered
            flairField.changeStyle(.error)
            errorField.text = "No Flair Entered"
            
            overlay?.removeFromSuperview()
            giveFlairButton.isEnabled = true
        }
    }
    
    @IBAction func sendNotification(_ sender: UIButton) {
        
        // Add a loading overlay to the admin view on accept
        var overlay: UIView?
        overlay = LoadingView(frame: CGRect(x: 0, y: 0, width: view.frame.width, height: view.frame.height))
        view.addSubview(overlay!)
        
        notificationButton.isEnabled = false
        
        let content: String = (notificationField.text?.trimmingCharacters(in: .whitespaces))!
        
        // If notification content exists, send it to the rest of the group members
        if !content.isEmpty {
            
            // Get the currently signed in user
            let user: User = SignedInUser.user
            
            // Send the notification to all accepted members except for the current user
            let otherMembers = acceptedMembers.filter { $0.username! != user.username! }
            
            otherMembers.forEach {
                member -> Void in
                
                let name = "\(member.first!) \(member.last!)"
                os_log("Sending Notification to User %@", log: self.logTag, type: .debug, name)
                
                // Build the notification message
                let notification = Notification()
                notification.username = member.username
                notification.link = "https://www.saintsxctf.com/group.php?name=\(groupname)"
                notification.notification_description = "A Message From \(grouptitle): \(content)"
                notification.viewed = "N"
                
                // Send the notification
                APIClient.notificationPostRequest(withNotification: notification) {
                    (newnotification) -> Void in
                    
                    os_log("New Notification Sent: %@", log: self.logTag, type: .debug, newnotification.description)
                }
            }
            
            let title = "Sent Notifications"
            
            let continueButton = DefaultButton(title: "Continue") {
                
                // Re-enable button and remove loading overlay
                overlay?.removeFromSuperview()
                self.notificationButton.isEnabled = true
                
                self.errorField.text = ""
                self.notificationField.changeStyle(.none)
            }
            
            // Display the popup
            let popup = PopupDialog(title: title, message: nil)
            popup.addButton(continueButton)
            
            self.present(popup, animated: true, completion: nil)
            
        } else {
            
            // Show error message if no notification content is entered
            notificationField.changeStyle(.error)
            errorField.text = "No Notification Entered"
            
            overlay?.removeFromSuperview()
            notificationButton.isEnabled = true
        }
    }
}
