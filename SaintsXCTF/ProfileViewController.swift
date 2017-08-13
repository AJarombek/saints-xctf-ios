//
//  ProfileViewController.swift
//  SaintsXCTF
//
//  Created by Andy Jarombek on 8/12/17.
//  Copyright © 2017 Andy Jarombek. All rights reserved.
//

import UIKit
import os.log

class ProfileViewController: UIViewController {
    
    let logTag = OSLog(subsystem: "SaintsXCTF.App.ProfileViewController", category: "ProfileViewController")
    
    override func viewDidLoad() {
        super.viewDidLoad()
        os_log("ProfileViewController Loaded.", log: logTag, type: .debug)
    }
    
    // Remove the keyboard when tapping the background
    @IBAction func backgroundTapped(_ sender: UITapGestureRecognizer) {
        view.endEditing(true)
    }
}
