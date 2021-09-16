//
//  LogStubs.swift
//  SaintsXCTFUITests
//
//  Created by Andrew Jarombek on 9/15/21.
//  Copyright © 2021 Andy Jarombek. All rights reserved.
//

import Foundation

struct LogStubs {
    let created = """
        {
            "added": true,
            "log": {},
            "self": "/v2/logs"
        }
    """
    
    var createdData: Data {
        get {
            return created.data(using: .utf8)!
        }
    }
}
