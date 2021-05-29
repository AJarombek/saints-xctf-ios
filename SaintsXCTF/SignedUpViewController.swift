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
    
    /**
     Invoked when the SignedUpViewController loads
     */
    override func viewDidLoad() {
        if let userInfo: User = user {
            FnClient.emailWelcomePostRequest(email: userInfo.email!, firstName: userInfo.first, lastName: userInfo.last) {
                (result: FnResult?) -> Void in
                
                if result?.result != nil && result?.result! == true {
                    os_log("Welcome Email Successfully Sent", log: self.logTag, type: .debug)
                } else {
                    os_log("Welcome Email Failed to Send", log: self.logTag, type: .error)
                }
            }
        }
    }
}
