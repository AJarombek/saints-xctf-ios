//
//  LogDataSource.swift
//  SaintsXCTF
//
//  Created by Andy Jarombek on 8/24/17.
//  Copyright © 2017 Andy Jarombek. All rights reserved.
//

import UIKit
import os.log

class LogDataSource: NSObject, UICollectionViewDataSource {
    
    static let logTag = OSLog(subsystem: "SaintsXCTF.App.LogDataSource", category: "LogDataSource")
    
    private var logs = [Log]()
    
    func collectionView(_ collectionView: UICollectionView,
                        numberOfItemsInSection section: Int) -> Int {
        return logs.count
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let identifier = "LogCollectionViewCell"
        
        // Get a reusable cell object found by the identifier
        let cell: LogCollectionViewCell = collectionView.dequeueReusableCell(
                    withReuseIdentifier: identifier, for: indexPath) as! LogCollectionViewCell
        
        return cell
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
