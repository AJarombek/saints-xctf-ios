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

/**
 Class containing utility functions for the rest of the application.
 */
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
    
    /**
     Find all the matching substrings of a pattern in a string along with information such as
     location in the original string and length of the substring
     - parameters:
     - regex: a regular expression to look for matches for in a string
     - text: a string to perform a regular expression on
     */
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
    
    /**
     Convert minutes and seconds to time
     - parameters:
     - minutes: a string containing minutes (should be in integer form)
     - seconds: a string containing seconds (should be in integer form)
     */
    static func toTime(withMinutes minutes: String, andSeconds seconds: String) -> String {
        
        // Base case: the minutes and seconds are both empty
        if minutes == "" && seconds == "" {
            return "00:00:00"
        }
        
        var secStr, minStr, hrStr: String
        var minInt, hrInt: Int
        
        // If the seconds are only of length one, pad with a zero
        if seconds.count == 1 {
            secStr = "0\(seconds)"
        } else {
            secStr = seconds
        }
        
        // If minutes are empty and seconds exist, return just the seconds
        if minutes == "" {
            return "00:00:\(secStr)"
        }
        
        // Find the hours and minutes from the minute input
        minInt = Int(minutes)!
        hrInt = minInt / 60
        minInt = minInt % 60
        hrStr = "\(hrInt)"
        minStr = "\(minInt)"
        
        // If the minutes are only of length one, pad with a zero
        if minStr.count == 1 {
            minStr = "0\(minStr)"
        }
        
        // If the hours are only of length one, pad with a zero
        if hrStr.count == 1 {
            hrStr = "0\(hrStr)"
        }
        
        return "\(hrStr):\(minStr):\(secStr)"
    }
    
    /**
     Convert a metric and distance to miles
     - parameters:
     - metric: the metric used to determine distance
     - distance: the distance in the specified metric
     */
    static func toMiles(fromMetric metric: String, withDistance distance: String) -> Double {
        
        let dist: Double = Double(distance)!
        
        switch metric {
        case "Miles":
            return dist
        case "Meters":
            return dist / 1609.344
        case "Kilometers":
            return dist * 0.621317
        default:
            os_log("ToMiles: Unexpected Metric Provided: %@", log: Utils.logTag, type: .error, metric)
            return dist
        }
    }
    
    /**
     Get the mile pace with miles, minutes, and seconds
     - parameters:
     - miles: the number of miles exercised in string format
     - minutes: the number of minutes exercised in string format
     - seconds: the number of seconds exercised in string format
     */
    static func getMilePace(withMiles miles: String, andMinutes minutes: String,
                        andSeconds seconds: String) -> String {
        
        var secStr, minStr, hrStr: String
        
        minStr = minutes
        secStr = seconds
        
        // If minutes or seconds are empty, set them
        if minutes == "" {
            if seconds == "" {
                return "00:00:00"
            }
            
            minStr = "0"
        }
        
        if seconds == "" {
            secStr = "0"
        }
        
        // Get the pace per second from the given parameters
        let s: Int = (Int(minStr)! * 60) + Int(secStr)!
        let secondPace = Double(s) / Double(miles)!
        
        // Calculate the hour, min, and sec per mile
        secStr = String(Int(secondPace) % 60)
        minStr = String(Int(secondPace / 60))
        hrStr = String(Int(minStr)! / 60)
        
        // Pad with zeros if the time has a length of one
        if secStr.count == 1 {
            secStr = "0\(secStr)"
        }
        if minStr.count == 1 {
            minStr = "0\(minStr)"
        }
        if hrStr.count == 1 {
            hrStr = "0\(hrStr)"
        }
        
        return "\(hrStr):\(minStr):\(secStr)"
    }
}
