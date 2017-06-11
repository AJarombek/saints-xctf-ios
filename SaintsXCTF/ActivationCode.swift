//
//  ActivationCode.swift
//  SaintsXCTF
//
//  Created by Andy Jarombek on 6/11/17.
//  Copyright © 2017 Andy Jarombek. All rights reserved.
//

import Foundation
import ObjectMapper

class ActivationCode: Mappable {
    
    var activation_code: String!
    
    required init?(map: Map) {
        // pass
    }
    
    func mapping(map: Map) {
        activation_code <- map["activation_code"]
    }
}
