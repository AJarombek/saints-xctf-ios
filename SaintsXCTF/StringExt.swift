//
//  StringExt.swift
//  SaintsXCTF
//
//  Created by Andy Jarombek on 9/23/17.
//  Copyright © 2017 Andy Jarombek. All rights reserved.
//

import Foundation

/**
 Extend the functionality of the String struct
 */
extension String {
    
    /**
     Capitalize the first letter of a string
     - returns: A string with its first letter capitalized
     */
    func capitalizingFirstLetter() -> String {
        let first: String = String(self.prefix(1)).capitalized
        let rest: String = String(self.dropFirst())
        return first + rest
    }
    
    /**
     Use the mutating keyword since we are changing the values of the String itself
     */
    mutating func capitalizeFirstLetter() {
        self = self.capitalizingFirstLetter()
    }
    
    /**
     Limit a string to a certain number of characters
     - parameters:
     - n: The max length allowed for the string
     - returns: The string with any characters beyond the allowed length removed
     */
    func safelyLimitedTo(length n: Int) -> String {
        if (self.count <= n) { return self }
        return String( Array(self).prefix(upTo: n) )
    }
}
