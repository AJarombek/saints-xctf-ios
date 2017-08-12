//
//  LogViewController.swift
//  SaintsXCTF
//
//  Created by Andy Jarombek on 8/12/17.
//  Copyright © 2017 Andy Jarombek. All rights reserved.
//

import UIKit

class LogViewController: UIViewController {
    
    let logTag = "LogViewController: "
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("\(logTag) LogViewController Loaded.")
    }
    
    // Remove the keyboard when tapping the background
    @IBAction func backgroundTapped(_ sender: UITapGestureRecognizer) {
        view.endEditing(true)
    }
}
