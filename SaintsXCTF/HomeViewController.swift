//
//  HomeViewController.swift
//  SaintsXCTF
//
//  Created by Andy Jarombek on 3/28/17.
//  Copyright © 2017 Andy Jarombek. All rights reserved.
//

import UIKit

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
    
    @IBAction func logInUser(_ sender: UIButton) {
        print("\(logTag) Logging In User \(username).")
        
        if let usernameString: String = username.text {
            var user: User? = APIClient.userGetRequest(withUsername: usernameString)
        }
        
    }
    
    @IBAction func signUpUser(_ sender: UIButton) {
        
    }
}
