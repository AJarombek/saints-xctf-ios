//
//  RangeView.swift
//  SaintsXCTF
//
//  Created by Andy Jarombek on 6/11/17.
//  Copyright © 2017 Andy Jarombek. All rights reserved.
//

import Foundation
import ObjectMapper

class RangeView: Mappable, CustomStringConvertible {
    
    var date: String!
    var miles: Double!
    var feel: Int!
    
    required init?(map: Map) {
        // pass
    }
    
    // This class uses the CustomStringConvertible protocol.
    // The description will be printed whenever we try to print a Comment object
    var description: String {
        return "RangeView: (\(date!), \(miles!), \(feel!))"
    }
    
    func mapping(map: Map) {
        date <- map["date"]
        miles <- map["miles"]
        feel <- map["feel"]
    }
}
