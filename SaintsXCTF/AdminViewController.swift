//
//  AdminViewController.swift
//  SaintsXCTF
//
//  Created by Andy Jarombek on 10/13/17.
//  Copyright © 2017 Andy Jarombek. All rights reserved.
//

import UIKit
import os.log

class AdminViewController: UIViewController {
    
    let logTag = OSLog(subsystem: "SaintsXCTF.App.MemberViewController",
                       category: "MemberViewController")
    
    @IBOutlet weak var addUserField: UITextField!
    @IBOutlet weak var addUserAcceptButton: UIButton!
    @IBOutlet weak var addUserRejectButton: UIButton!
    @IBOutlet weak var sendRequestField: UITextField!
    @IBOutlet weak var sendRequestButton: UIButton!
    @IBOutlet weak var nameFlairField: UITextField!
    @IBOutlet weak var flairField: UITextField!
    @IBOutlet weak var giveFlairButton: UIButton!
    @IBOutlet weak var notificationField: UITextField!
    @IBOutlet weak var notificationButton: UIButton!
    
    var passedGroup: Group? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        os_log("MainViewController Loaded.", log: logTag, type: .debug)
        
        navigationController?.navigationBar.backgroundColor = UIColor(0x999999, a: 0.9)
        
        // Set the navigation bar back button to a custom image
        navigationController?.navigationBar.backIndicatorImage = UIImage(named: "back")
        navigationController?.navigationBar.backIndicatorTransitionMaskImage = UIImage(named: "back")
        navigationController?.navigationBar.tintColor = UIColor(0x000000)
        
        navigationItem.backBarButtonItem = UIBarButtonItem(title: " ", style:
            UIBarButtonItemStyle.plain, target: nil, action: nil)
        
        addUserField.standardStyle()
        sendRequestField.standardStyle()
        nameFlairField.standardStyle()
        flairField.standardStyle()
        notificationField.standardStyle()
        
        if let group: Group = passedGroup {
            navigationItem.title = group.group_title!
        }
    }
}
