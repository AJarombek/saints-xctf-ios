//
//  GroupListViewController.swift
//  SaintsXCTF
//
//  Created by Andy Jarombek on 8/12/17.
//  Copyright © 2017 Andy Jarombek. All rights reserved.
//

import UIKit
import os.log

class GroupListViewController: UIViewController {
    
    let logTag = OSLog(subsystem: "SaintsXCTF.App.GroupListViewController",
                       category: "GroupListViewController")
    
    override func viewDidLoad() {
        super.viewDidLoad()
        os_log("GroupListViewController Loaded.", log: OSLog.default, type: .debug)
    }
}
