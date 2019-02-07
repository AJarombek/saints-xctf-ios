//
//  RangeView.swift
//  SaintsXCTF
//
//  Created by Andy Jarombek on 6/11/17.
//  Copyright © 2017 Andy Jarombek. All rights reserved.
//

import Foundation
import ObjectMapper

/**
 Class that represents a range view of exercise in the application.  Range Views are stored across
 multiple tables in the MySQL database.
 - Important:
 ## Implements the following protocols:
 - Mappable: used to map an object to JSON
 - CustomStringConvertible: allows class instances to create a string representation of themself
 */
class RangeView: Mappable, CustomStringConvertible {
    
    var date: String!
    var miles: String!
    var feel: String!
    
    /**
     Required initializer for the Mappable protocol
     - parameters:
     - map: JSON data is stored within this map
     */
    required init?(map: Map) {}
    
    // This class uses the CustomStringConvertible protocol.
    // The description will be printed whenever we try to print a Comment object
    var description: String {
        return "RangeView: (\(date!), \(miles!), \(feel!))"
    }
    
    /**
     Required function for the Mappable protocol.  Defines how each member maps to and from JSON.
     - parameters:
     - map: JSON data is stored within this map
     */
    func mapping(map: Map) {
        date <- map["date"]
        miles <- map["miles"]
        feel <- map["feel"]
    }
}
