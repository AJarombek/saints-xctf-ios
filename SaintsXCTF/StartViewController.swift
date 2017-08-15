//
//  StartViewController.swift
//  SaintsXCTF
//
//  Created by Andy Jarombek on 8/14/17.
//  Copyright © 2017 Andy Jarombek. All rights reserved.
//

import UIKit
import os.log

class StartViewController: UIViewController {
    
    let logTag = OSLog(subsystem: "SaintsXCTF.App.StartViewController", category: "StartViewController")
    
    override func viewDidLoad() {
        super.viewDidLoad()
        os_log("StartViewController Loaded.", log: logTag, type: .debug)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        
        // Execute after a two second delay
        DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(2), execute: {
            _ = SignedInUser()
            let user = SignedInUser.user
            
            if (user.username != "") {
                os_log("Restoring user '%@' session.", log: self.logTag, type: .debug, user.username)
                
                // Redirect to the signed in home page
                let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
                let mainViewController = storyBoard.instantiateViewController(withIdentifier:
                    "mainViewController") as! UITabBarController
                self.present(mainViewController, animated: true, completion: nil)
            } else {
                os_log("No user session existing.", log: self.logTag, type: .debug)
                
                // Redirect to the signed out home page
                let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
                let homeViewController = storyBoard.instantiateViewController(withIdentifier:
                    "homeViewController") as! HomeViewController
                self.present(homeViewController, animated: true, completion: nil)
            }
        })
    }
    
    // Remove the keyboard when tapping the background
    @IBAction func backgroundTapped(_ sender: UITapGestureRecognizer) {
        view.endEditing(true)
    }
}
