//
//  MainViewController.swift
//  SaintsXCTF
//
//  Created by Andy Jarombek on 7/3/17.
//  Copyright © 2017 Andy Jarombek. All rights reserved.
//

import UIKit
import os.log

class MainViewController: UIViewController {
    
    let logTag = OSLog(subsystem: "SaintsXCTF.App.MainViewController", category: "MainViewController")
    
    override func viewDidLoad() {
        super.viewDidLoad()
        os_log("MainViewController Loaded.", log: logTag, type: .debug)
    }
    
    // Remove the keyboard when tapping the background
    @IBAction func backgroundTapped(_ sender: UITapGestureRecognizer) {
        view.endEditing(true)
    }
}
