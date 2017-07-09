//
//  SignUpViewController.swift
//  SaintsXCTF
//
//  Created by Andy Jarombek on 7/3/17.
//  Copyright © 2017 Andy Jarombek. All rights reserved.
//

import UIKit
import Foundation

class SignUpViewController: UIViewController {
    
    let logTag = "SignUpViewController: "
    
    @IBOutlet var username: UITextField!
    @IBOutlet var activationCode: UITextField!
    @IBOutlet var confirmPassword: UITextField!
    @IBOutlet var password: UITextField!
    @IBOutlet var lastName: UITextField!
    @IBOutlet var email: UITextField!
    @IBOutlet var firstName: UITextField!
    
    // Remove the keyboard when tapping the background
    @IBAction func backgroundTapped(_ sender: UITapGestureRecognizer) {
        view.endEditing(true)
    }
    
    @IBAction func signUpUser(_ sender: UIButton) {
        
        if let usernameString = username.text?.trimmingCharacters(in: .whitespaces),
            let firstNameString = firstName.text?.trimmingCharacters(in: .whitespaces),
            let lastNameString = lastName.text?.trimmingCharacters(in: .whitespaces),
            let emailString = email.text?.trimmingCharacters(in: .whitespaces),
            let passwordString = password.text?.trimmingCharacters(in: .whitespaces),
            let confirmPasswordString = confirmPassword.text?.trimmingCharacters(in: .whitespaces),
            let activationCodeString = activationCode.text?.trimmingCharacters(in: .whitespaces) {
            
            let regexUsername = ""
            
            if (!usernameString.isEmpty ||
                usernameString.rangeOfString("", options: .regularExpressionSearch) != nil) {
                
                
            } else {
                
            }
        }
    }
}
