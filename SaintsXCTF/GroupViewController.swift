//
//  GroupViewController.swift
//  SaintsXCTF
//
//  Created by Andy Jarombek on 10/7/17.
//  Copyright © 2017 Andy Jarombek. All rights reserved.
//

import UIKit
import os.log

class GroupViewController: UIViewController {
    
    let logTag = OSLog(subsystem: "SaintsXCTF.App.GroupViewController",
                       category: "GroupViewController")
    
    let group: Group? = nil
    var groupname = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        os_log("GroupViewController Loaded.", log: OSLog.default, type: .debug)
        
        navigationController?.navigationBar.backgroundColor = UIColor(0x999999, a: 0.9)
    }
}
