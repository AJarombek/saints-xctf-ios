//
//  Environment.swift
//  SaintsXCTF
//
//  Created by Andrew Jarombek on 4/24/21.
//  Copyright © 2021 Andy Jarombek. All rights reserved.
//

import Foundation

enum Environment {
    case local
    case localEmail
    case localUITestStub
    case development
    case production
}

class NetworkEnvironment {
    var environment: Environment {
        get {
            if ProcessInfo.processInfo.arguments.contains("UI_STUB_TESTING") {
                return .localUITestStub
            } else if ProcessInfo.processInfo.arguments.contains("UI_TESTING") {
                return .local
            } else {
                return .development
            }
        }
    }
}
