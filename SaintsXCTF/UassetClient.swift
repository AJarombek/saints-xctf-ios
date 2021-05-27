//
//  UassetClient.swift
//  SaintsXCTF
//
//  Created by Andrew Jarombek on 4/27/21.
//  Copyright © 2021 Andy Jarombek. All rights reserved.
//

import Foundation

class UassetClient {
    public static var baseUrl: String {
        switch NetworkEnvironment.environment {
        case .local, .localEmail, .localUITestStub, .development:
            return "https://uasset.saintsxctf.com/dev"
        case .production:
            return "https://uasset.saintsxctf.com/prod"
        }
    }
}
