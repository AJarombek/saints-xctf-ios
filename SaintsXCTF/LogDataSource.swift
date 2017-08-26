//
//  LogDataSource.swift
//  SaintsXCTF
//
//  Created by Andy Jarombek on 8/24/17.
//  Copyright © 2017 Andy Jarombek. All rights reserved.
//

import UIKit
import os.log

class LogDataSource {
    
    static let logTag = OSLog(subsystem: "SaintsXCTF.App.LogDataSource", category: "LogDataSource")
    
    private var logs = [Log]()
    
    func count() -> Int {
        return logs.count
    }
    
    func get(_ index: Int) -> Log {
        return logs[index]
    }
    
    // Load a defined number of logs into the datasource using the logfeed endpoint
    // Return true if there are no more logs to load, otherwise false
    func load(withParamType paramType: String, sortParam: String, limit: Int, andOffset offset: Int,
              completion: @escaping (Bool) -> Void) {
        
        APIClient.logfeedGetRequest(withParamType: paramType, sortParam: sortParam,
                                    limit: limit, offset: offset) {
            (logArray) -> Void in
                            
            var done = false
            let size = logArray.count
                                        
            if (size > 0) {
                
                // In swift you can combine two arrays with the + operator
                self.logs += logArray
                
                if (size != limit) {
                    done = true
                }
            }
                                        
            OperationQueue.main.addOperation {
                completion(done)
            }
        }
    }
}
