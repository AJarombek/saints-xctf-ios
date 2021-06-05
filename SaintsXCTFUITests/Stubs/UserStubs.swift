//
//  UserStubs.swift
//  SaintsXCTFUITests
//
//  Created by Andrew Jarombek on 6/5/21.
//  Copyright © 2021 Andy Jarombek. All rights reserved.
//

import Foundation

struct UserStubs {
    let andy = """
        
    """
    
    let andySundayWeekStart = """
        
    """
    
    var andyData: Data {
        get {
            return andy.data(using: .utf8)!
        }
    }
    
    var andySundayWeekStartData: Data {
        get {
            return andySundayWeekStart.data(using: .utf8)!
        }
    }
}
