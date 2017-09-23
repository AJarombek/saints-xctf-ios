//
//  ActivationCode.swift
//  SaintsXCTF
//
//  Created by Andy Jarombek on 6/11/17.
//  Copyright © 2017 Andy Jarombek. All rights reserved.
//

import Foundation
import ObjectMapper

class ActivationCode: Mappable, CustomStringConvertible {
    
    var activation_code: String!
    
    required init?(map: Map) {
        // pass
    }
    
    // This class uses the CustomStringConvertible protocol.
    // The description will be printed whenever we try to print a Notification object
    var description: String {
        return "Activation Code: (\(activation_code))"
    }
    
    func mapping(map: Map) {
        activation_code <- map["activation_code"]
    }
}
