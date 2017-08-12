//
//  SignOutViewController.swift
//  SaintsXCTF
//
//  Created by Andy Jarombek on 8/12/17.
//  Copyright © 2017 Andy Jarombek. All rights reserved.
//

import UIKit

class SignOutController: UIViewController {
    
    let logTag = "SignOutViewController: "
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("\(logTag) SignOutViewController Loaded.")
    }
    
    // Remove the keyboard when tapping the background
    @IBAction func backgroundTapped(_ sender: UITapGestureRecognizer) {
        view.endEditing(true)
    }
}
