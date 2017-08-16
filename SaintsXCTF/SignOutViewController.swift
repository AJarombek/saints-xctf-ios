//
//  SignOutViewController.swift
//  SaintsXCTF
//
//  Created by Andy Jarombek on 8/12/17.
//  Copyright © 2017 Andy Jarombek. All rights reserved.
//

import UIKit
import os.log

class SignOutController: UIViewController {
    
    let logTag = OSLog(subsystem: "SaintsXCTF.App.LogViewController", category: "LogViewController")
    
    @IBOutlet weak var signOutSwitch: UISwitch!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        os_log("LogViewController Loaded.", log: OSLog.default, type: .debug)
        
        signOutSwitch.setOn(false, animated: false)
    }
    
    // Remove the keyboard when tapping the background
    @IBAction func backgroundTapped(_ sender: UITapGestureRecognizer) {
        view.endEditing(true)
    }
}
