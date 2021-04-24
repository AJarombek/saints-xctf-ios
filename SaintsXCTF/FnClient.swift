//
//  FnClient.swift
//  SaintsXCTF
//
//  Created by Andrew Jarombek on 4/19/21.
//  Copyright © 2021 Andy Jarombek. All rights reserved.
//

import Foundation
import os.log

class FnClient {
    
    private static let logTag = OSLog(subsystem: "SaintsXCTF.APIClient.FnClient", category: "FnClient")
    
    private static var fnBaseUrl: String {
        switch NetworkEnvironment.environment {
        case .local:
            return "http://localhost:5002"
        case .development:
            return "http://dev.fn.saintsxctf.com"
        case .production:
            return "http://fn.saintsxctf.com"
        }
    }
    
    // MARK: - POST Requests
    
}
