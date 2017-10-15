//
//  DetailsViewController.swift
//  SaintsXCTF
//
//  Created by Andy Jarombek on 9/26/17.
//  Copyright © 2017 Andy Jarombek. All rights reserved.
//

import UIKit
import os.log
import PopupDialog

class DetailsViewController: UIViewController, UITextViewDelegate, UITextFieldDelegate {
    
    let logTag = OSLog(subsystem: "SaintsXCTF.App.DetailsViewController",
                       category: "DetailsViewController")
    
    @IBOutlet weak var firstNameField: UITextField!
    @IBOutlet weak var lastNameField: UITextField!
    @IBOutlet weak var emailField: UITextField!
    @IBOutlet weak var classYearField: UITextField!
    @IBOutlet weak var locationField: UITextField!
    @IBOutlet weak var favoriteEventField: UITextField!
    @IBOutlet weak var descriptionView: UITextView!
    @IBOutlet weak var saveButton: UIButton!
    @IBOutlet weak var cancelButton: UIButton!
    @IBOutlet weak var errorView: UITextView!
    
    var user: User = User()
    
    // The Regular Expressions for Validation
    let regexEmail = "^(([a-zA-Z0-9_.-])+@([a-zA-Z0-9_.-])+\\.([a-zA-Z])+([a-zA-Z])+)?$"
    let regexName = "^[a-zA-Z\\-']+$"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        os_log("DetailsViewController Loaded.", log: logTag, type: .debug)
        
        // Set the navigation bar back button to a custom image
        navigationController?.navigationBar.backIndicatorImage = UIImage(named: "back")
        navigationController?.navigationBar.backIndicatorTransitionMaskImage = UIImage(named: "back")
        navigationController?.navigationBar.tintColor = UIColor(0x000000)
        navigationItem.title = "Edit Profile Details"
        
        navigationItem.backBarButtonItem = UIBarButtonItem(title: " ", style:
            UIBarButtonItemStyle.plain, target: nil, action: nil)
        
        // Set the styles for all the text fields
        firstNameField.standardStyle()
        lastNameField.standardStyle()
        emailField.standardStyle()
        classYearField.standardStyle()
        locationField.standardStyle()
        favoriteEventField.standardStyle()
        descriptionView.standardStyle()
        
        // Set the fields to the users values
        firstNameField.text = user.first ?? ""
        lastNameField.text = user.last ?? ""
        emailField.text = user.email ?? ""
        classYearField.text = user.class_year ?? ""
        locationField.text = user.location ?? ""
        favoriteEventField.text = user.favorite_event ?? ""
        descriptionView.text = user.user_description ?? ""
        
        // Set up the done button for the keyboard
        setDoneKeyboard()
    }
    
    // Validate the mandatory fields (first name, last name, email)
    func validateDetails() -> Bool {
        
        if let firstNameString = firstNameField.text,
            let lastNameString = lastNameField.text,
            let emailString = emailField.text,
            let classYearString = classYearField.text,
            let locationString = locationField.text,
            let favoriteEventString = favoriteEventField.text,
            let descriptionString = descriptionView.text {
            
            // First Name Validation
            if (!firstNameString.isEmpty &&
                firstNameString.range(of: regexName, options: .regularExpression) != nil) {
                
                user.first = firstNameString
                firstNameField.changeStyle(.none)
            } else {
                firstNameField.changeStyle(.error)
                errorView.text = "Invalid First Name Entered"
                return false
            }
            
            // Last Name Validation
            if (!lastNameString.isEmpty &&
                lastNameString.range(of: regexName, options: .regularExpression) != nil) {
                
                user.last = lastNameString
                lastNameField.changeStyle(.none)
            } else {
                lastNameField.changeStyle(.error)
                errorView.text = "Invalid Last Name Entered"
                return false
            }
            
            // Email Validation
            if (!emailString.isEmpty &&
                emailString.range(of: regexEmail, options: .regularExpression) != nil) {
                
                user.email = emailString
                emailField.changeStyle(.none)
            } else {
                emailField.changeStyle(.error)
                errorView.text = "Invalid Email Entered"
                return false
            }
            
            user.class_year = classYearString
            user.location = locationString
            user.favorite_event = favoriteEventString
            user.user_description = descriptionString
            
        } else {
            os_log("Error Getting Values from Fields.", log: logTag, type: .error)
            errorView.text = "Internal Error.  Try Again"
            return false
        }
        
        return true
    }
    
    // Create the done button for the keyboard
    func setDoneKeyboard() {
        let keyboardToolbar = UIToolbar()
        keyboardToolbar.sizeToFit()
        let flexBarButton = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        let doneBarButton = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(self.dismissKeyboard))
        keyboardToolbar.items = [flexBarButton, doneBarButton]
        
        // Connect the done button to all the text fields keyboards
        firstNameField.inputAccessoryView = keyboardToolbar
        lastNameField.inputAccessoryView = keyboardToolbar
        emailField.inputAccessoryView = keyboardToolbar
        classYearField.inputAccessoryView = keyboardToolbar
        locationField.inputAccessoryView = keyboardToolbar
        favoriteEventField.inputAccessoryView = keyboardToolbar
        descriptionView.inputAccessoryView = keyboardToolbar
    }
    
    // Called when the done button on the keyboard is clicked
    func dismissKeyboard() {
        view.endEditing(true)
    }
    
    // Save the profile details and send the update to the API
    @IBAction func saveDetails(_ sender: UIButton) {
        os_log("Saving User Profile Details.", log: logTag, type: .debug)
        
        if validateDetails() {
            os_log("Valid Profile Details Entered: Sending updates to API", log: logTag, type: .debug)
            
            // Add a loading overlay to the profile details on save
            var overlay: UIView?
            overlay = LoadingView(frame: CGRect(x: 0, y: 0, width: view.frame.width, height: view.frame.height))
            view.addSubview(overlay!)
            
            // Temporarily disable the save and cancel buttons
            saveButton.isEnabled = false
            cancelButton.isEnabled = false
            
            // If the details are valid, send them to the API
            APIClient.userPutRequest(withUsername: user.username, andUser: user) {
                (nu) -> Void in
                
                if let newuser: User = nu {
                    
                    // Update the signed in users details
                    SignedInUser.user = newuser
                    
                    // Build the popup dialog to be displayed
                    let title = "Profile Details Changed"
                    
                    // Actions to do when deleting a log
                    let continueButton = DefaultButton(title: "Continue") {
                        os_log("Continue to Edit Profile Page", log: self.logTag, type: .debug)
                        
                        // Re-enable buttons and remove loading overlay
                        overlay?.removeFromSuperview()
                        self.saveButton.isEnabled = true
                        self.cancelButton.isEnabled = true
                        
                        // Go back in the view controller hierarchy
                        self.navigationController?.popViewController(animated: true)
                    }
                    
                    // Display the popup before redirecting to edit profile page
                    let popup = PopupDialog(title: title, message: nil)
                    popup.addButton(continueButton)
                    
                    self.present(popup, animated: true, completion: nil)
                }
            }
            
        } else {
            os_log("Invalid Profile Details Entered.", log: logTag, type: .debug)
        }
    }
    
    // Cancel the profile details and return to the edit profile page
    @IBAction func cancelDetails(_ sender: UIButton) {
        os_log("Cancel User Profile Details.", log: logTag, type: .debug)
        self.navigationController?.popViewController(animated: true)
    }
    
    // Set a limit on the description input
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange,
                  replacementText text: String) -> Bool {
        let str = textView.text + text
        
        if str.characters.count <= 255 {
            return true
        }
        textView.text = str.substring(to: str.index(str.startIndex, offsetBy: 255))
        return false
    }
}
