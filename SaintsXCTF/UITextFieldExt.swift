//
//  TextFieldStyler.swift
//  SaintsXCTF
//
//  Created by Andy Jarombek on 7/8/17.
//  Copyright © 2017 Andy Jarombek. All rights reserved.
//

import UIKit

enum Style {
    case error, warning, valid, none
}

private var __maxLengths = [UITextField: Int]()

// Build an extension on the UITextField class for styling functions
extension UITextField {
    
    // Change border and background based on the style argument
    func changeStyle(_ style: Style) {
        
        if style == .valid {
            let validColor = UIColor(0x5cb85c).cgColor
            let validBackgroundColor = UIColor(0x5cb85c, a: 0.2)
            self.layer.borderColor = validColor
            self.backgroundColor = validBackgroundColor
            
        } else if style == .warning {
            let warningColor = UIColor(0xf0ad4e).cgColor
            let warningBackgroundColor = UIColor(0xf0ad4e, a: 0.2)
            self.layer.borderColor = warningColor
            self.backgroundColor = warningBackgroundColor
            
        
        } else if style == .error {
            let errorColor = UIColor(0xd9534f).cgColor
            let errorBackgroundColor = UIColor(0xd9534f, a: 0.2)
            self.layer.borderColor = errorColor
            self.backgroundColor = errorBackgroundColor
            
        } else if style == .none {
            self.layer.borderColor = UIColor(0xCCCCCC).cgColor
            self.backgroundColor = UIColor.white
        }
    }
    
    // Set a text field to the standard style used across the app
    func standardStyle() {
        self.layer.borderWidth = 2
        self.layer.borderColor = UIColor(0xCCCCCC).cgColor
        self.layer.cornerRadius = 1
        self.backgroundColor = UIColor.white
    }
    
    // This is to set a maximum length option in the storyboard
    @IBInspectable var maxLength: Int {
        get {
            guard let l = __maxLengths[self] else {
                return 150
            }
            return l
        }
        set {
            __maxLengths[self] = newValue
            addTarget(self, action: #selector(fix), for: .editingChanged)
        }
    }
    
    @objc func fix(textField: UITextField) {
        let t = textField.text
        textField.text = t?.safelyLimitedTo(length: maxLength)
    }
}
