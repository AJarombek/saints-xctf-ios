//
//  Utils.swift
//  SaintsXCTF
//
//  Created by Andy Jarombek on 9/15/17.
//  Copyright © 2017 Andy Jarombek. All rights reserved.
//

import Foundation
import os.log

struct StringMatches {
    var startIndices: [Int] = []
    var substrings: [String] = []
    var stringLengths: [Int] = []
}

class Utils {
    
    static let logTag = OSLog(subsystem: "SaintsXCTF.App.Utils", category: "Utils")
    
    // Find all the matching substrings of a pattern in a string
    static func matches(for regex: String, in text: String) -> [String] {
        
        do {
            // Build a regular expression with the given pattern
            let regex: NSRegularExpression = try NSRegularExpression(pattern: regex)
            let nsString: NSString = text as NSString
            
            // Populate an array with the substrings that match the pattern
            let results: [NSTextCheckingResult] = regex.matches(in: text, range:
                                                    NSRange(location: 0, length: nsString.length))
            return results.map { nsString.substring(with: $0.range) }
            
        } catch let error {
            os_log("Invalid Regex %@", log: Utils.logTag, type: .error, error.localizedDescription)
            return []
        }
    }
    
    // Find all the matching substrings of a pattern in a string and information such as 
    // location in the original string and length of the substring
    static func matchesInfo(for regex: String, in text: String) -> StringMatches {
        
        do {
            // Build a regular expression with the given pattern
            let regex: NSRegularExpression = try NSRegularExpression(pattern: regex)
            let nsString: NSString = text as NSString
            
            // Populate an array with the substrings that match the pattern
            let results: [NSTextCheckingResult] = regex.matches(in: text, range:
                                                    NSRange(location: 0, length: nsString.length))
            
            // Get info on the matching substrings including the starting positions, length, and the
            // subtring itself
            let startIndices: [Int] = results.map {
                $0.range.location
            }
            
            let substrings: [String] = results.map {
                nsString.substring(with: $0.range)
            }
            
            let stringLengths: [Int] = results.map {
                $0.range.length
            }
            
            os_log("Start Indices: %@", log: Utils.logTag, type: .debug, startIndices)
            os_log("Substrings: %@", log: Utils.logTag, type: .debug, substrings)
            os_log("String Lengths: %@", log: Utils.logTag, type: .debug, stringLengths)
            
            var matches = StringMatches()
            matches.startIndices = startIndices
            matches.substrings = substrings
            matches.stringLengths = stringLengths
            
            return matches
            
        } catch let error {
            os_log("Invalid Regex %@", log: Utils.logTag, type: .error, error.localizedDescription)
            return StringMatches()
        }
    }
}
