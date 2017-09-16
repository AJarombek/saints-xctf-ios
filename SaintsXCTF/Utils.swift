//
//  Utils.swift
//  SaintsXCTF
//
//  Created by Andy Jarombek on 9/15/17.
//  Copyright © 2017 Andy Jarombek. All rights reserved.
//

import Foundation

class Utils {
    
    static let logTag = OSLog(subsystem: "SaintsXCTF.App.Utils", category: "Utils")
    
    // Find all the matching substrings of a pattern in a string
    static func matches(for regex: String, in text: String) -> [String] {
        
        do {
            // Build a regular expression with the given pattern
            let regex: NSRegularExpression = try NSRegularExpression(pattern: regex)
            let nsString: NSString = text as NSString
            
            // Populate an array with the substrings that match the pattern
            let results: [NSString] = regex.matches(in: text, range: NSRange(location: 0, length: nsString.length))
            return results.map { nsString.substring(with: $0.range) }
            
        } catch let error {
            os_log("Invalid Regex %@", log: Utils.logTag, type: .error, error.localizedDescription)
            return []
        }
    }
}
