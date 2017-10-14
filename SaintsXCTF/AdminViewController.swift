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
    
    var passedGroup: Group? = nil
    var groupname: String = ""
    var addUserPicker: UIPickerView!
    var flairPicker: UIPickerView!
    
    var members: [GroupMember] = [GroupMember]()
    var pendingMembers: [GroupMember] = [GroupMember]()
    var pendingNames: [String] = [String]()
    
    var acceptedMembers: [GroupMember] = [GroupMember]()
    var acceptedNames: [String] = [String]()
    
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
        
        // Set up the done button for the keyboard
        setDoneKeyboard()
    }
    
    // Create the done button for the keyboard
    func setDoneKeyboard() {
        let keyboardToolbar = UIToolbar()
        keyboardToolbar.sizeToFit()
        let flexBarButton = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        let doneBarButton = UIBarButtonItem(barButtonSystemItem: .done, target: self,
                                            action: #selector(self.dismissKeyboard))
        keyboardToolbar.items = [flexBarButton, doneBarButton]
        
        // Connect the done button to all the text fields keyboards
        addUserField.inputAccessoryView = keyboardToolbar
        sendRequestField.inputAccessoryView = keyboardToolbar
        nameFlairField.inputAccessoryView = keyboardToolbar
        flairField.inputAccessoryView = keyboardToolbar
        notificationField.inputAccessoryView = keyboardToolbar
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
    
    @IBAction func sendEmail(_ sender: UIButton) {
    
    }
    
    @IBAction func giveFlair(_ sender: UIButton) {
    
    }
    
    @IBAction func sendNotification(_ sender: UIButton) {
        
    }
}
