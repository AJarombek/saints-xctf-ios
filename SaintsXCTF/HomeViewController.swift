//
//  HomeViewController.swift
//  SaintsXCTF
//
//  Created by Andy Jarombek on 3/28/17.
//  Copyright © 2017 Andy Jarombek. All rights reserved.
//

import UIKit
import BCryptSwift

class HomeViewController: UIViewController {
    
    let logTag = "HomeViewController: "
    
    // Remove the keyboard when tapping the background
    @IBAction func backgroundTapped(_ sender: UITapGestureRecognizer) {
        view.endEditing(true)
    }
    
    @IBOutlet var backgroundImage: UIImageView!
    @IBOutlet var logIn: UIButton!
    @IBOutlet var signUp: UIButton!
    @IBOutlet var username: UITextField!
    @IBOutlet var password: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.backgroundImage.image = #imageLiteral(resourceName: "Background")
    }
    
    // Action to take when logging in a user
    @IBAction func logInUser(_ sender: UIButton) {
        
        // First make sure the username and password fields are filled
        if let usernameString: String = username.text, let passwordString: String = password.text {
            
            print("\(logTag) Logging In User \(usernameString).")
            
            APIClient.userGetRequest(withUsername: usernameString) {
                (user) -> Void in
                
                if let hash: String = user.password,
                    let verified: Bool = BCryptSwift.verifyPassword(passwordString, matchesHash: hash) {
                    
                    if verified {
                        print("\(self.logTag) Valid Password Entered!")
                    } else {
                        print("\(self.logTag) INVALID Password Entered.")
                    }
                } else {
                    print("\(self.logTag) Unable to Verfiy Password")
                }
            }
        }
        
    }
    
    @IBAction func signUpUser(_ sender: UIButton) {
        
    }
}
