//
//  SignOutViewController.swift
//  SaintsXCTF
//
//  Created by Andy Jarombek on 8/12/17.
//  Copyright © 2017 Andy Jarombek. All rights reserved.
//

import UIKit
import os.log

/**
 Class controlling logic for the view displaying a sign out switch.
 - Important:
 ## Extends the following class:
 - UIViewController: provides behavior shared between all classes that manage a view
 */
class SignOutController: UIViewController {
    
    let logTag = OSLog(subsystem: "SaintsXCTF.App.LogViewController", category: "LogViewController")
    
    @IBOutlet weak var signOutSwitch: UISwitch!
    
    /**
     Invoked when the SignOutController loads
     */
    override func viewDidLoad() {
        super.viewDidLoad()
        os_log("LogViewController Loaded.", log: logTag, type: .debug)
        
        signOutSwitch.setOn(false, animated: false)
        signOutSwitch.addTarget(self, action: #selector(switchChanged),
                                for: UIControl.Event.valueChanged)
        signOutSwitch.onTintColor = UIColor(0x990000)
    }
    
    /**
     Function called when the UISwitch is changed.  If it is turned on, sign out the user.
     - parameters:
     - mySwitch: the UISwitch with an altered state (signOutSwitch)
     */
    @objc func switchChanged(mySwitch: UISwitch) {
        let on: Bool = mySwitch.isOn
        
        if (on) {
            let removed = SignedInUser.removeUser()
            
            if (removed) {
                os_log("Successfully Signed Out User.", log: logTag, type: .debug)
            }
            
            let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
            let startViewController = storyBoard.instantiateViewController(withIdentifier:
                "startViewController") as! StartViewController
            self.present(startViewController, animated: true, completion: nil)
        }
    }
}
