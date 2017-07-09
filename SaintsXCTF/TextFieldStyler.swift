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

// Build an extension on the UITextField class to change the border style
extension UITextField {
    
    func changeStyle(_ style: Style) {
        
        // Change border based on the style argument
        if style == .valid {
            let validColor = UIColor.green.cgColor
            self.layer.borderColor = validColor
            
            
        } else if style == .warning {
            let warningColor = UIColor.orange.cgColor
            self.layer.borderColor = warningColor
            
        
        } else if style == .error {
            let errorColor = UIColor.red.cgColor
            self.layer.borderColor = errorColor
            
        } else if style == .none {
            self.layer.borderWidth = 0
        }
        
        self.layer.borderWidth = 1
    }
}
