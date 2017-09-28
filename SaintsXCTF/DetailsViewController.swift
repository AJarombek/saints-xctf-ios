//
//  DetailsViewController.swift
//  SaintsXCTF
//
//  Created by Andy Jarombek on 9/26/17.
//  Copyright © 2017 Andy Jarombek. All rights reserved.
//

import UIKit
import os.log

class DetailsViewController: UIViewController {
    
    let logTag = OSLog(subsystem: "SaintsXCTF.App.DetailsViewController",
                       category: "DetailsViewController")
    
    @IBOutlet weak var firstNameField: UITextField!
    @IBOutlet weak var lastNameField: UITextField!
    @IBOutlet weak var emailField: UITextField!
    @IBOutlet weak var classYearField: UITextField!
    @IBOutlet weak var locationField: UITextField!
    @IBOutlet weak var favoriteEventField: UITextField!
    @IBOutlet weak var descriptionView: UITextView!
    @IBOutlet weak var saveButton: UIButton!
    @IBOutlet weak var cancelButton: UIButton!
    @IBOutlet weak var errorView: UITextView!
    
    var user: User = User()
    
    // The Regular Expressions for Validation
    let regexEmail = "^(([a-zA-Z0-9_.-])+@([a-zA-Z0-9_.-])+\\.([a-zA-Z])+([a-zA-Z])+)?$"
    let regexName = "^[a-zA-Z\\-']+$"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        os_log("DetailsViewController Loaded.", log: logTag, type: .debug)
        
        // Set the navigation bar back button to a custom image
        navigationController?.navigationBar.backIndicatorImage = UIImage(named: "back")
        navigationController?.navigationBar.backIndicatorTransitionMaskImage = UIImage(named: "back")
        navigationController?.navigationBar.tintColor = UIColor(0x000000)
        navigationItem.title = "Edit Profile Details"
        
        navigationItem.backBarButtonItem = UIBarButtonItem(title: " ", style:
            UIBarButtonItemStyle.plain, target: nil, action: nil)
        
        // Set the styles for all the text fields
        firstNameField.standardStyle()
        lastNameField.standardStyle()
        emailField.standardStyle()
        classYearField.standardStyle()
        locationField.standardStyle()
        favoriteEventField.standardStyle()
        descriptionView.standardStyle()
        
        // Set the fields to the users values
        firstNameField.text = user.first ?? ""
        lastNameField.text = user.last ?? ""
        emailField.text = user.email ?? ""
        classYearField.text = user.class_year ?? ""
        locationField.text = user.location ?? ""
        favoriteEventField.text = user.favorite_event ?? ""
        descriptionView.text = user.user_description ?? ""
    }
    
    func validateDetails() -> Bool {
        return true
    }
    
    @IBAction func saveDetails(_ sender: UIButton) {
        os_log("Saving User Profile Details.", log: logTag, type: .debug)
        
        if validateDetails() {
            
        } else {
            
        }
    }
    
    @IBAction func cancelDetails(_ sender: UIButton) {
        os_log("Cancel User Profile Details.", log: logTag, type: .debug)
    }
}
