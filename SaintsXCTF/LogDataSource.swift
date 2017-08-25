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
        let identifier = "UICollectionViewCell"
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: identifier, for: indexPath)
        return cell
    }
    
    // Load a defined number of logs into the datasource using the logfeed endpoint
    func load(withParamType paramType: String, sortParam: String, limit: Int, andOffset offset: Int) {
        
        APIClient.logfeedGetRequest(withParamType: paramType, sortParam: sortParam,
                                    limit: limit, offset: offset) {
            (logArray) -> Void in
        }
    }
}
