//
//  TextViewExt.swift
//  SaintsXCTF
//
//  Created by Andy Jarombek on 9/27/17.
//  Copyright © 2017 Andy Jarombek. All rights reserved.
//

import UIKit

extension UITextView {
    
    // Set a text field to the standard style used across the app
    func standardStyle() {
        self.layer.borderWidth = 2
        self.layer.borderColor = UIColor(0xCCCCCC).cgColor
        self.layer.cornerRadius = 1
        self.backgroundColor = UIColor.white
    }
}
