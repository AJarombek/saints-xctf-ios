//
//  StringExt.swift
//  SaintsXCTF
//
//  Created by Andy Jarombek on 9/23/17.
//  Copyright © 2017 Andy Jarombek. All rights reserved.
//

import Foundation

extension String {
    
    // Capitalize the first letter of a string
    func capitalizingFirstLetter() -> String {
        let first = String(characters.prefix(1)).capitalized
        let rest = String(characters.dropFirst())
        return first + rest
    }
    
    // Use the mutating keyword since we are changing the values of the String itself
    mutating func capitalizeFirstLetter() {
        self = self.capitalizingFirstLetter()
    }
    
    func safelyLimitedTo(length n: Int)->String {
        let c = self.characters
        if (c.count <= n) { return self }
        return String( Array(c).prefix(upTo: n) )
    }
}
