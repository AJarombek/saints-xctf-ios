//
//  HexColor.swift
//  SaintsXCTF
//
//  Created by Andy Jarombek on 8/12/17.
//  Copyright © 2017 Andy Jarombek. All rights reserved.
//

import UIKit

// Build an extension on UIColor to take in hex values for colors
extension UIColor {
    
    convenience init(red: Int, green: Int, blue: Int, a: CGFloat = 1.0) {
        assert(red >= 0 && red <= 255, "Invalid Red Value")
        assert(green >= 0 && green <= 255, "Invalid Green Value")
        assert(blue >= 0 && blue <= 255, "Invalid Blue Value")
        assert(a >= 0.0 && a <= 1.0, "Invalid Alpha Value")
        
        // UIColor requires CGFloat parameters so convert the value
        // CGFloat is a machine independing floating point value 
        // (supports 32-bit and 64-bit floating point values)
        self.init(red: CGFloat(red) / 255.0, green: CGFloat(green) / 255.0,
                  blue: CGFloat(blue) / 255.0, alpha: a)
    }
    
    // Calls the first custom convenience int, but you can pass in one hex rgb value
    convenience init(_ rgb: Int, a: CGFloat = 1.0) {
        
        // Shift the bits and bitwise and to get the red green and blue
        // values from the 6 digit hex value
        self.init(
            red: (rgb >> 16) & 0xFF,
            green: (rgb >> 8) & 0xFF,
            blue: rgb & 0xFF,
            a: a
        )
    }
}
