//
//  SignUpViewController.swift
//  SaintsXCTF
//
//  Created by Andy Jarombek on 7/3/17.
//  Copyright © 2017 Andy Jarombek. All rights reserved.
//

import UIKit
import Foundation
import BCryptSwift
import os.log

/**
 Class controlling logic for the view displaying a sign up form.
 - Important:
 ## Extends the following class:
 - UIViewController: provides behavior shared between all classes that manage a view
 */
class SignUpViewController: UIViewController {
    
    let logTag = OSLog(subsystem: "SaintsXCTF.App.SignUpViewController", category: "SignUpViewController")
    
    
    @IBOutlet var signUpView: UIView!
    @IBOutlet var username: UITextField!
    @IBOutlet var activationCode: UITextField!
    @IBOutlet var confirmPassword: UITextField!
    @IBOutlet var password: UITextField!
    @IBOutlet var lastName: UITextField!
    @IBOutlet var email: UITextField!
    @IBOutlet var firstName: UITextField!
    @IBOutlet var eulaSwitch: UISwitch!
    @IBOutlet var eulaLabel: UILabel!
    @IBOutlet var signUpError: UITextView!
    
    var eulaAccepted: Bool = false
    
    /**
     Invoked when the SignUpViewController loads
     */
    override func viewDidLoad() {
        super.viewDidLoad()
        signUpView.backgroundColor = UIColor(0xEEEEEE)
        signUpError.backgroundColor = UIColor(0xEEEEEE)
        
        // Give the textfields the standard app style
        username.standardStyle()
        activationCode.standardStyle()
        confirmPassword.standardStyle()
        password.standardStyle()
        lastName.standardStyle()
        email.standardStyle()
        firstName.standardStyle()
        
        eulaSwitch.setOn(false, animated: false)
        eulaSwitch.addTarget(self, action: #selector(switchChanged), for: UIControl.Event.valueChanged)
        eulaSwitch.onTintColor = UIColor(0x990000)
    }
    
    /**
     Attempt to sign up the user to use the app and website
     - parameters:
     - sender: the button that invoked this function
     */
    @IBAction func signUpUser(_ sender: UIButton) {
        
        // Make sure all of the form entries are populated
        if let usernameString = username.text?.trimmingCharacters(in: .whitespaces),
            let firstNameString = firstName.text?.trimmingCharacters(in: .whitespaces),
            let lastNameString = lastName.text?.trimmingCharacters(in: .whitespaces),
            let emailString = email.text?.trimmingCharacters(in: .whitespaces),
            let passwordString = password.text?.trimmingCharacters(in: .whitespaces),
            let confirmPasswordString = confirmPassword.text?.trimmingCharacters(in: .whitespaces),
            let activationCodeString = activationCode.text?.trimmingCharacters(in: .whitespaces) {
            
            // The Regular Expressions for Validation
            let regexUsername = "^[a-zA-Z0-9]+$"
            let regexEmail = "^(([a-zA-Z0-9_.-])+@([a-zA-Z0-9_.-])+\\.([a-zA-Z])+([a-zA-Z])+)?$"
            let regexName = "^[a-zA-Z\\-']+$"
            
            // Username Validation
            if (!usernameString.isEmpty &&
                usernameString.range(of: regexUsername, options: .regularExpression) != nil) {
                
                username.changeStyle(.valid)
            } else {
                username.changeStyle(.error)
                signUpError.text = "Invalid Username Entered"
                return
            }
            
            // First Name Validation
            if (!firstNameString.isEmpty &&
                firstNameString.range(of: regexName, options: .regularExpression) != nil) {
                
                firstName.changeStyle(.valid)
            } else {
                firstName.changeStyle(.error)
                signUpError.text = "Invalid First Name Entered"
                return
            }
            
            // Last Name Validation
            if (!lastNameString.isEmpty &&
                lastNameString.range(of: regexName, options: .regularExpression) != nil) {
                
                lastName.changeStyle(.valid)
            } else {
                lastName.changeStyle(.error)
                signUpError.text = "Invalid Last Name Entered"
                return
            }
            
            // Email Validation
            if (!emailString.isEmpty &&
                emailString.range(of: regexEmail, options: .regularExpression) != nil) {
                
                email.changeStyle(.valid)
            } else {
                email.changeStyle(.error)
                signUpError.text = "Invalid Email Entered"
                return
            }
            
            // Password Validation
            if (passwordString.count >= 6) {
                
                password.changeStyle(.valid)
            } else {
                password.changeStyle(.error)
                signUpError.text = "Invalid Password (Must Contain 6 or More Characters)"
                return
            }
            
            // Confirm Password Validation
            if (confirmPasswordString.count >= 6 && passwordString == confirmPasswordString) {
                
                confirmPassword.changeStyle(.valid)
            } else {
                confirmPassword.changeStyle(.error)
                signUpError.text = "Confirm Password Must Match Password"
                return
            }
            
            // Activation Code Validation
            if (!activationCodeString.isEmpty) {
                
                activationCode.changeStyle(.valid)
            } else {
                activationCode.changeStyle(.error)
                signUpError.text = "Activation Code Must Be Entered"
                return
            }
            
            // EULA agreement Validation
            if (!eulaAccepted) {
                signUpError.text = "EULA Must Be Accepted"
                return
            }
            
            // First we must check to see if this Username has already been taken
            APIClient.userGetRequest(withUsername: usernameString) {
                (user) -> Void in
                
                if user.username == usernameString {
                    self.signUpError.text = "Username Already Exists"
                    return
                }
                
                os_log("Username %@ is Available.  Checking Activation Code...", log: self.logTag,
                       type: .debug, user.username)
                
                // Validate the activation code
                APIClient.activationCodeGetRequest(withCode: activationCodeString) {
                    (activationcode) -> Void in
                    
                    if let _: ActivationCode = activationcode {
                        
                        os_log("Activation Code Valid.  Adding User to Database",
                               log: self.logTag, type: .debug)
                        
                        // When the activation code is valid, build up a User object for a POST request
                        let newUser = User()
                        newUser.username = usernameString
                        newUser.first = firstNameString
                        newUser.last = lastNameString
                        newUser.email = emailString
                        
                        // Hash the password using BCrypt
                        newUser.password = BCryptSwift.hashPassword(passwordString,
                                                                    withSalt: BCryptSwift.generateSalt())
                        newUser.activation_code = activationCodeString
                        
                        // Final call to add the new user
                        self.addUser(newUser, usernameString)
                        
                    } else {
                        os_log("Invalid Activation Code", log: self.logTag, type: .debug)
                        self.signUpError.text = "Invalid Activation Code"
                        self.activationCode.changeStyle(.error)
                        return
                    }
                }
            }
            
        } else {
            signUpError.text = "Must Fill In All Forms Inputs"
            return
        }
    }
    
    /**
     Add a user to the database through the API and store locally on success
     - parameters:
     - user: data about the user to be added
     - username: the username of the user to be added
     */
    func addUser(_ user: User, _ username: String) {
        APIClient.userPostRequest(withUser: user) {
            (user) -> Void in
            
            // Check that the added user exists and the username is as expected
            if let newUser: User = user, user?.username == username {
                os_log("User Successfully Created", log: self.logTag, type: .debug)
                os_log("%@", log: self.logTag, type: .debug, newUser.description)
                
                // Save the user sign in data
                SignedInUser.user = newUser
                let savedUser = SignedInUser.saveUser()
                
                if (savedUser) {
                    os_log("Saved User to Persistant Storage.", log: self.logTag, type: .debug)
                } else {
                    os_log("Failed to Saves User to Persistant Storage",
                           log: self.logTag, type: .error)
                }
                
                // Redirect to the pick group page
                let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
                let pickGroupViewController = storyBoard.instantiateViewController(withIdentifier:
                    "pickGroupViewController") as! PickGroupController
                self.present(pickGroupViewController, animated: true, completion: nil)
                
            } else {
                os_log("User Creation Failed", log: self.logTag, type: .error)
                self.signUpError.text = "Internal Error.  Try Again."
                return
            }
        }
    }
    
    /**
     Function called when the UISwitch is changed.  If it is turned on, a user accepted the EULA anc is
     permitted to sign up for the app.
     - parameters:
     - mySwitch: the UISwitch with an altered state (eulaSwitch)
     */
    @objc func switchChanged(mySwitch: UISwitch) {
        eulaAccepted = mySwitch.isOn
    }
}
