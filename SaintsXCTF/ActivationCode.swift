//
//  ActivationCode.swift
//  SaintsXCTF
//
//  Created by Andy Jarombek on 6/11/17.
//  Copyright © 2017 Andy Jarombek. All rights reserved.
//

import Foundation
import ObjectMapper

/**
 Class that represents an activation code for the application.  Activation codes are stored in the MySQL database.
 */
class ActivationCode: Mappable, CustomStringConvertible {
    
    var activation_code: String!
    
    /**
     Default initializer for an ActivationCode object
     */
    init() {
        activation_code = ""
    }
    
    /**
     Required initializer for the Mappable protocol
     */
    required init?(map: Map) {
        // pass
    }
    
    // This class uses the CustomStringConvertible protocol.
    // The description will be printed whenever we try to print a Notification object
    var description: String {
        return "Activation Code: (\(activation_code ?? ""))"
    }
    
    /**
     Required function for the Mappable protocol.  Defines how each member maps to and from JSON.
     - parameters:
     - map: JSON is stored within this map
     */
    func mapping(map: Map) {
        activation_code <- map["activation_code"]
    }
}
