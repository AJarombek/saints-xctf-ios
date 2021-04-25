//
//  AdminViewController.swift
//  SaintsXCTF
//
//  Created by Andy Jarombek on 10/13/17.
//  Copyright © 2017 Andy Jarombek. All rights reserved.
//
import UIKit
import os.log
import PopupDialog

/**
 Controller providing administrative operations for a group.
 - Important:
 ## Extends the following class:
 - UIViewController: provides behavior shared between all classes that manage a view
 
 ## Implements the following protocols:
 - UIPickerViewDelegate: provides helper methods for configuraing a picker views functionality
 */
class AdminViewController: UIViewController, UIPickerViewDelegate {
    
    let logTag = OSLog(subsystem: "SaintsXCTF.App.AdminViewController", category: "AdminViewController")
    
    var passedGroup: Group? = nil
    
    /**
     Invoked when the AdminViewController loads
     */
    override func viewDidLoad() {
        super.viewDidLoad()
        os_log("AdminViewController Loaded.", log: logTag, type: .debug)
        
        navigationController?.navigationBar.backgroundColor = UIColor(0x990000, a: 0.9)
        
        // Set the navigation bar back button to a custom image
        navigationController?.navigationBar.backIndicatorImage = UIImage(named: "back")
        navigationController?.navigationBar.backIndicatorTransitionMaskImage = UIImage(named: "back")
        navigationController?.navigationBar.tintColor = UIColor(0xFFFFFF)
        
        navigationItem.backBarButtonItem = UIBarButtonItem(
            title: " ",
            style: UIBarButtonItem.Style.plain,
            target: nil,
            action: nil
        )
    }
}
