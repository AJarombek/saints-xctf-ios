//
//  LogDataSource.swift
//  SaintsXCTF
//
//  Created by Andy Jarombek on 8/24/17.
//  Copyright © 2017 Andy Jarombek. All rights reserved.
//

import UIKit
import os.log

/**
 A collection of exercise logs that are used in a table view
 */
class LogDataSource {
    
    static let logTag = OSLog(subsystem: "SaintsXCTF.App.LogDataSource", category: "LogDataSource")
    
    private var logs = [LogData]()
    
    /**
     Get the number of items in the datasource
     - returns: number of log items
     */
    func count() -> Int {
        return logs.count
    }
    
    /**
     Get an item from the datasource at a specific index
     - parameters:
     - index: the integer index of the log within the datasource
     - returns: a log item if the index is valid, otherwise `nil`
     */
    func get(_ index: Int) -> LogData? {
        if index < logs.count {
            return logs[index]
        } else {
            return nil
        }
    }
    
    /**
     Remove from the datasource at specific index
     - parameters:
     - index: the integer index of the log within the datasource
     */
    func delete(_ index: Int) {
        logs.remove(at: index)
    }
    
    /**
     Remove all logs from the datasource
     */
    func clearLogs() {
        logs.removeAll()
    }
    
    /**
     Function to remove excess zeros from the time
     - parameters:
     - time: a string representing the time a workout took to complete
     - returns: a shortened version of the time argument
     */
    func shortenTime(withTime time: String) -> String {
        var start = 0
        
        for i in 0 ..< time.count {
            let index = time.index(time.startIndex, offsetBy: i)
            if time[index] != "0" && time[index] != ":" {
                start = i
                break
            }
        }
        
        let startIndex =  time.index(time.startIndex, offsetBy: start)
        let endIndex = time.endIndex
        
        return String(time[startIndex..<endIndex])
    }
    
    /**
     Load a defined number of logs into the datasource using the logfeed endpoint
     Return `true` if there are no more logs to load, otherwise `false`
     - parameters:
     - paramType: how to filter the logs.  Sometimes we need all logs, or just a groups logs, or a single users logs
     - sortParam: the group or user whose logs are needed
     - limit: the max number of logs to retrieve
     - offset: the offset from the most recent logs
     - controller: UI Controller that the API request originates from
     - completion: a callback function called when the logs are returned from the API
     */
    func load(
        withParamType paramType: String,
        sortParam: String,
        limit: Int,
        andOffset offset: Int,
        fromController controller: UIViewController?,
        completion: @escaping (Bool) -> Void
    ) {
        
        APIClient.logfeedGetRequest(
            withParamType: paramType,
            sortParam: sortParam,
            limit: limit,
            offset: offset,
            fromController: controller
        ) {
            (logArray) -> Void in
                            
            var done = false
            let size = logArray.count
                                        
            if (size > 0) {
                
                // Build up the logData to add to the data source
                var data: [LogData] = [LogData]()
                
                DispatchQueue.global().async {
                    
                    logArray.forEach {
                        log -> Void in
                        
                        let logData: LogData = LogData()
                        logData.log = log
                        logData.username = log.username!
                        logData.feel = Int(log.feel!)
                        
                        // Set the user name as clickable text in the log
                        let usertitle: String = "\(log.first!) \(log.last!)"
                        let range: NSRange = NSRange(location: 0, length: usertitle.count)
                        
                        let mutableName = NSMutableAttributedString(string: usertitle, attributes: [:])
                        mutableName.addAttribute(NSAttributedString.Key.link, value: "@\(log.username!)",
                                                 range: range)
                        mutableName.addAttribute(NSAttributedString.Key.font, value: UIFont.systemFont(ofSize: 16.0, weight: UIFont.Weight.bold), range: range)
                        logData.userLabelText = mutableName
                        
                        // Convert the string to a date
                        let dateFormatter = DateFormatter()
                        dateFormatter.dateFormat = "yyyy-MM-dd"
                        
                        // Then format the date for viewing
                        let formattedDate = dateFormatter.date(from: log.date)
                        dateFormatter.dateFormat = "MMM dd, yyyy"
                        logData.date = dateFormatter.string(from: formattedDate!)
                        
                        // Set the logs name
                        logData.name = log.name!
                        
                        // Set the logs type
                        logData.type = log.type?.uppercased()
                        
                        // Set the logs location
                        var locationTxt = ""
                        
                        if let location: String = log.location, location != "" {
                            locationTxt = "Location: \(location)\n"
                        }
                        
                        // Set the logs distance
                        var distanceTxt = ""
                        
                        if let distance: Double = log.distance, let metric: String = log.metric {
                            
                            if distance != 0 {
                                distanceTxt = "\(distance) \(metric)\n"
                            }
                        }
                        
                        // Set the logs time
                        var timeTxt = ""
                        
                        if let time: String = log.time, let pace: String = log.pace {
                            if time != "0:00:00" {
                                timeTxt = self.shortenTime(withTime: time)
                                
                                if pace == "0:00:00" {
                                    timeTxt += " (0:00/mi)\n"
                                } else {
                                    timeTxt += " (\(self.shortenTime(withTime: pace))/mi)\n"
                                }
                            }
                        }
                        
                        // Combine the location, distance, and time
                        let logInfo = "\(locationTxt)\(distanceTxt)\(timeTxt)\n"
                        
                        // Set the logs description
                        if let description: String = log.log_description {
                            
                            // Find all the tagged users in the comment
                            let tagRegex = "@[a-zA-Z0-9]+"
                            let matches = Utils.matchesInfo(for: tagRegex, in: description)
                            
                            // Go through each tag and add a link when clicked
                            if matches.substrings.count > 0 {
                                let logInfoMutableContent = NSMutableAttributedString(string: logInfo, attributes: [:])
                                
                                // Create a combined mutable attribute string for all the log info + description
                                let combinedMutableContent = NSMutableAttributedString()
                                combinedMutableContent.append(logInfoMutableContent)
                                
                                // Create a MutableAttributedString for each tag
                                // Add a new line at the end of the description so none of the text gets cut off
                                let mutableContent = NSMutableAttributedString(string: "\(description)\n", attributes: [:])
                                
                                for i in 0...matches.substrings.count - 1 {
                                    let start = matches.startIndices[i]
                                    let length = matches.stringLengths[i]
                                    
                                    mutableContent.addAttribute(NSAttributedString.Key.link, value: matches.substrings[i],
                                                                range: NSRange(location: start, length: length))
                                }
                                
                                // Add the description to the rest of the mutable content
                                combinedMutableContent.append(mutableContent)
                                
                                // Set the description as the combined location, time, pace, distance, and description
                                logData.descriptionTags = combinedMutableContent
                                
                            } else {
                                logData.description = "\(logInfo)\(description)\n"
                            }
                        } else {
                            logData.description = logInfo
                        }
                        
                        data.append(logData)
                    }
                    
                    // In swift you can combine two arrays with the + operator
                    self.logs += data
                    
                    OperationQueue.main.addOperation {
                        completion(done)
                    }
                }
                
                if (size != limit) {
                    done = true
                }
            }
        }
    }
}
