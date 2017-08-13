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
    }
    
    // Action to take when logging in a user
    @IBAction func logInUser(_ sender: UIButton) {
        
        // First make sure the username and password fields are filled
        if let usernameString: String = username.text, let passwordString: String = password.text {
            
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
                        let defaults = UserDefaults.standard
                        
                        defaults.set(user.first, forKey: "first name")
                        defaults.set(user.last, forKey: "last name")
                        defaults.set(user.toJSONString()!, forKey: "user")
                        
                        // Redirect to the main page
                        let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
                        let mainViewController = storyBoard.instantiateViewController(withIdentifier:
                            "mainViewController") as! UITabBarController
                        self.present(mainViewController, animated: true, completion: nil)
                        
                    } else {
                        os_log("INVALID Password Entered.", log: self.logTag, type: .error)
                        self.error.text = "Invalid Username/Password Entered"
                    }
                } else {
                    os_log("Unable to Verfiy Password", log: self.logTag, type: .error)
                    self.error.text = "Invalid Username Entered"
                }
            }
        } else {
            self.error.text = "Please Enter a Username and Password"
        }
        
    }
    
    @IBAction func signUpUser(_ sender: UIButton) {}
}
