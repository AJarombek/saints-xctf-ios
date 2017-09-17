//
//  LogViewController.swift
//  SaintsXCTF
//
//  Created by Andy Jarombek on 8/12/17.
//  Copyright © 2017 Andy Jarombek. All rights reserved.
//

import UIKit
import os.log

class LogViewController: UIViewController {
    
    @IBOutlet weak var nameField: UITextField!
    @IBOutlet weak var locationField: UITextField!
    @IBOutlet weak var dateField: UITextField!
    @IBOutlet weak var typeField: UITextField!
    @IBOutlet weak var distanceField: UITextField!
    @IBOutlet weak var metricField: UITextField!
    @IBOutlet weak var minutesField: UITextField!
    @IBOutlet weak var secondsField: UITextField!
    @IBOutlet weak var feelStepper: UIStepper!
    @IBOutlet weak var descriptionField: UITextView!
    @IBOutlet weak var errorField: UITextView!
    @IBOutlet weak var submitButton: UIButton!
    @IBOutlet weak var cancelButton: UIButton!
    
    let distanceRegex = "^[0-9]{0,3}(\\.[0-9]{1,2})?$"
    let minuteRegex = "^[0-9]{1,5}$"
    let secondRegex = "^[0-9]{1,2}$"
    let userTagRegex = "@[a-zA-Z0-9]+"
    
    let currentDate = "08/16/2017"
    
    let logTag = OSLog(subsystem: "SaintsXCTF.App.LogViewController", category: "LogViewController")
    
    override func viewDidLoad() {
        super.viewDidLoad()
        os_log("LogViewController Loaded.", log: logTag, type: .debug)
    }
    
    // Remove the keyboard when tapping the background
    @IBAction func backgroundTapped(_ sender: UITapGestureRecognizer) {
        view.endEditing(true)
    }
    
    @IBAction func submitLog(_ sender: UIButton) {
        
    }
    
    // When the user clicks cancel, reset all the fields to their default values
    @IBAction func cancelLog(_ sender: UIButton) {
        nameField.text = ""
        locationField.text = ""
        dateField.text = ""
        typeField.text = "Run"
        distanceField.text = ""
        metricField.text = "Miles"
        minutesField.text = ""
        secondsField.text = ""
        descriptionField.text = ""
        errorField.text = ""
    }
}
