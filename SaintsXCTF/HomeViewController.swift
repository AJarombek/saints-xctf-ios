//
//  HomeViewController.swift
//  SaintsXCTF
//
//  Created by Andy Jarombek on 3/28/17.
//  Copyright © 2017 Andy Jarombek. All rights reserved.
//

import UIKit
import BCryptSwift
import os.log

class HomeViewController: UIViewController {
    
    let logTag = OSLog(subsystem: "SaintsXCTF.App.HomeViewController", category: "HomeViewController")
    
    // Remove the keyboard when tapping the background
    @IBAction func backgroundTapped(_ sender: UITapGestureRecognizer) {
        view.endEditing(true)
    }
    
    @IBOutlet var backgroundImage: UIImageView!
    @IBOutlet var logIn: UIButton!
    @IBOutlet var signUp: UIButton!
    @IBOutlet var username: UITextField!
    @IBOutlet var password: UITextField!
    @IBOutlet var error: UITextView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.backgroundImage.image = #imageLiteral(resourceName: "Background")
        
        username.standardStyle()
        password.standardStyle()
        
        // Set up the done button for the keyboard
        setDoneKeyboard()
    }
    
    // Create the done button for the keyboard
    func setDoneKeyboard() {
        let keyboardToolbar = UIToolbar()
        keyboardToolbar.sizeToFit()
        let flexBarButton = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        let doneBarButton = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(self.dismissKeyboard))
        keyboardToolbar.items = [flexBarButton, doneBarButton]
        
        // Connect the done button to all the text fields keyboards
        username.inputAccessoryView = keyboardToolbar
        password.inputAccessoryView = keyboardToolbar
    }
    
    // Called when the done button on the keyboard is clicked
    func dismissKeyboard() {
        view.endEditing(true)
    }
    
    // Action to take when logging in a user
    @IBAction func logInUser(_ sender: UIButton) {
        
        // Reset styling and errors
        self.error.text = ""
        self.username.standardStyle()
        self.password.standardStyle()
        
        // First make sure the username and password fields are filled
        if let usernameString: String = username.text, let passwordString: String = password.text {
            
            // Make sure both fields arent empty
            if (usernameString == "") {
                self.error.text = "Please Enter a Username"
                self.username.changeStyle(.error)
            } else if (passwordString == "") {
                self.error.text = "Please Enter a Password"
                self.password.changeStyle(.error)
            } else {
            
                os_log("Logging In User %@.", log: logTag, type: .debug, usernameString)
            
                // Second request the user from the API and specify a callback closure
                APIClient.userGetRequest(withUsername: usernameString) {
                    (user) -> Void in
                
                    // Check to see if the password entered and the users hash match
                    if let hash: String = user.password,
                        let verified: Bool = BCryptSwift.verifyPassword(passwordString, matchesHash: hash) {
                    
                        if verified {
                            os_log("Valid Password Entered!", log: self.logTag, type: .debug)
                        
                            // Save the user sign in data
                            SignedInUser.user = user
                            let savedUser = SignedInUser.saveUser()
                            
                            if (savedUser) {
                                os_log("Saved User to Persistant Storage.", log: self.logTag, type: .debug)
                            } else {
                                os_log("Failed to Saves User to Persistant Storage",
                                       log: self.logTag, type: .error)
                            }
                        
                            // Redirect to the main page
                            let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
                            let mainViewController = storyBoard.instantiateViewController(withIdentifier:
                                "mainViewController") as! UITabBarController
                            self.present(mainViewController, animated: true, completion: nil)
                        
                        } else {
                            os_log("INVALID Password Entered.", log: self.logTag, type: .error)
                            self.error.text = "Invalid Username/Password Entered"
                            self.username.changeStyle(.warning)
                            self.password.changeStyle(.warning)
                        }
                    } else {
                        os_log("Unable to Verify Password", log: self.logTag, type: .error)
                        self.error.text = "Invalid Username Entered"
                        self.username.changeStyle(.error)
                    }
                }
            }
        } else {
            self.error.text = "Please Enter a Username and Password"
            self.username.changeStyle(.error)
            self.password.changeStyle(.error)
        }
        
    }
    
    @IBAction func signUpUser(_ sender: UIButton) {}
}
