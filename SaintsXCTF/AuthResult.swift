//
//  AuthResult.swift
//  SaintsXCTF
//
//  Created by Andrew Jarombek on 4/20/21.
//  Copyright © 2021 Andy Jarombek. All rights reserved.
//

import Foundation
import ObjectMapper

class AuthResult: Mappable, CustomStringConvertible {
    var result: String!
    
    init() {
        result = ""
    }
    
    required init?(map: Map) {}
    
    var description: String {
        return "AuthResult: (\(result!))"
    }
    
    func mapping(map: Map) {
        result <- map["result"]
    }
}
