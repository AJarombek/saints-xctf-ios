//
//  FnResult.swift
//  SaintsXCTF
//
//  Created by Andrew Jarombek on 4/25/21.
//  Copyright © 2021 Andy Jarombek. All rights reserved.
//

import Foundation
import ObjectMapper

class FnResult: Mappable, CustomStringConvertible {
    var result: Bool!
    
    init() {
        result = false
    }
    
    required init?(map: Map) {}
    
    var description: String {
        return "FnResult: (\(result!))"
    }
    
    func mapping(map: Map) {
        result <- map["result"]
    }
}
