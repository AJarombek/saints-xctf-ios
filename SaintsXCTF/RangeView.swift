//
//  RangeView.swift
//  SaintsXCTF
//
//  Created by Andy Jarombek on 6/11/17.
//  Copyright © 2017 Andy Jarombek. All rights reserved.
//

import Foundation
import ObjectMapper

class RangeView: Mappable {
    
    var date: String!
    var miles: Double!
    var feel: Int!
    
    required init?(map: Map) {
        // pass
    }
    
    func mapping(map: Map) {
        date <- map["date"]
        miles <- map["miles"]
        feel <- map["feel"]
    }
}
