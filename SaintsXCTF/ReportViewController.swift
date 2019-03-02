//
//  ReportViewController.swift
//  SaintsXCTF
//
//  Created by Andy Jarombek on 3/2/19.
//  Copyright © 2019 Andy Jarombek. All rights reserved.
//

import UIKit
import os.log

/**
 Controller for filing reports to the application administrator.
 - Important:
 ## Extends the following class:
 - UIViewController: provides behavior shared between all classes that manage a view
 */
class ReportViewController: UIViewController {
    
    let logTag = OSLog(subsystem: "SaintsXCTF.App.ReportViewController",
                       category: "ReportViewController")
    
    @IBOutlet weak var reportTextView: UITextView!
    @IBOutlet weak var submitButton: UIButton!
    
    var user: User = User()
    
    /**
     Invoked when the ReportViewController loads
     */
    override func viewDidLoad() {
        super.viewDidLoad()
        os_log("ReportViewController Loaded.", log: logTag, type: .debug)
        
        // Set the navigation bar back button to a custom image
        navigationController?.navigationBar.backIndicatorImage = UIImage(named: "back")
        navigationController?.navigationBar.backIndicatorTransitionMaskImage = UIImage(named: "back")
        navigationController?.navigationBar.tintColor = UIColor(0xFFFFFF)
        navigationItem.title = "File Report"
        
        navigationItem.backBarButtonItem = UIBarButtonItem(title: " ", style:
            UIBarButtonItem.Style.plain, target: nil, action: nil)
        
        reportTextView.standardStyle()
        submitButton.setTitleColor(UIColor(0x990000), for: .normal)
    }
}
