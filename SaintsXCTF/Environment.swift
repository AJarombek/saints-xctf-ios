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
    case development
    case production
}

class NetworkEnvironment {
    static let environment: Environment = .local
}
