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

/**
 Class controlling logic for the view displayed when a user isnt signed in or signed up.
 - Important:
 ## Extends the following class:
 - UIViewController: provides behavior shared between all classes that manage a view
 */
class HomeViewController: UIViewController {
    
    let logTag = OSLog(subsystem: "SaintsXCTF.App.HomeViewController", category: "HomeViewController")
    
    /**
     Remove the keyboard when tapping the background
     - parameters:
     - sender: the gesture which caused this function to be called
     */
    @IBAction func backgroundTapped(_ sender: UITapGestureRecognizer) {
        view.endEditing(true)
    }
    
    @IBOutlet var backgroundImage: UIImageView!
    @IBOutlet var logIn: UIButton!
    @IBOutlet var signUp: UIButton!
    @IBOutlet var username: UITextField!
    @IBOutlet var password: UITextField!
    @IBOutlet var error: UITextView!
    
    var overlay: UIView?
    
    /**
     Invoked when the HomeViewController loads
     */
    override func viewDidLoad() {
        super.viewDidLoad()
        self.backgroundImage.image = #imageLiteral(resourceName: "Background")
        
        username.standardStyle()
        password.standardStyle()
    }
    
    /**
     Action to take when logging in a user
     - parameters:
     - sender: the button click which caused this function to be called (logIn)
     */
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
                
                // Add a loading overlay to the home page
                overlay = LoadingView(frame: CGRect(x: 0, y: 0, width: view.frame.width, height: view.frame.height))
                view.addSubview(overlay!)
                
                // Disable the login and signup buttons
                logIn.isEnabled = false
                signUp.isEnabled = false
            
                os_log("Logging In User %@.", log: logTag, type: .debug, usernameString)
                
                AuthClient.tokenPostRequest(withUsername: usernameString, password: passwordString, completion: {
                    (authResult: AuthResult) -> Void in
                    
                    if (authResult.result.isEmpty) {
                        os_log("No Auth Token Returned.", log: self.logTag, type: .error)
                        self.error.text = "Invalid Username/Password Entered"
                        self.username.changeStyle(.warning)
                        self.password.changeStyle(.warning)
                        self.removeOverlay()
                    } else {
                        UserJWT.jwt = authResult.result
                        _ = UserJWT.saveJWT()
                        self.saveUserDetails(username: usernameString, password: passwordString)
                    }
                })
            }
        } else {
            self.error.text = "Please Enter a Username and Password"
            self.username.changeStyle(.error)
            self.password.changeStyle(.error)
        }
        
    }
    
    func saveUserDetails(username: String, password: String) {
        // Second request the user from the API and specify a callback closure
        APIClient.userGetRequest(withUsername: username, fromController: self) {
            (user: User) -> Void in
        
            // Check to see if the user object properly has a username field
            if let _: String = user.username {
                // Save the user sign in data
                SignedInUser.user = user
                let savedUser = SignedInUser.saveUser()
                
                if (savedUser) {
                    os_log("Saved User to Persistant Storage.", log: self.logTag, type: .debug)
                } else {
                    os_log(
                        "Failed to Saves User to Persistant Storage",
                        log: self.logTag,
                        type: .error
                    )
                }
            
                // Redirect to the main page
                let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
                let mainViewController = storyBoard.instantiateViewController(withIdentifier:
                    "mainViewController") as! UITabBarController
                self.present(mainViewController, animated: true, completion: nil)
            } else {
                os_log("Unable to Retrieve User Details", log: self.logTag, type: .error)
                self.error.text = "Invalid Username Entered"
                self.username.changeStyle(.error)
                self.removeOverlay()
            }
        }
    }
    
    /**
     Action to take when signing up a user (isnt used currently, SignUpViewController handles this logic)
     - parameters:
     - sender: the button click which caused this function to be called (signUp)
     */
    @IBAction func signUpUser(_ sender: UIButton) {}
    
    /**
     Re-enable buttons and remove loading overlay
     */
    func removeOverlay() {
        self.overlay?.removeFromSuperview()
        self.signUp.isEnabled = true
        self.logIn.isEnabled = true
    }
}
