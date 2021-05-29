//
//  SignedUpViewController.swift
//  SaintsXCTF
//
//  Created by Andrew Jarombek on 5/28/21.
//  Copyright © 2021 Andy Jarombek. All rights reserved.
//

import UIKit
import Foundation
import os.log

/**
 Class controlling logic for the view after a successful user sign up.
 - Important:
 ## Extends the following class:
 - UIViewController: provides behavior shared between all classes that manage a view
 */
class SignedUpViewController: UIViewController {
    
    let logTag = OSLog(subsystem: "SaintsXCTF.App.SignedUpViewController", category: "SignedUpViewController")
    
    @IBOutlet var logIn: UIButton!
    
    var user: User? = nil
}
