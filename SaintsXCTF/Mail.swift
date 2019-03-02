//
//  Mail.swift
//  SaintsXCTF
//
//  Created by Andy Jarombek on 10/14/17.
//  Copyright © 2017 Andy Jarombek. All rights reserved.
//

import Foundation
import ObjectMapper

/**
 Class that represents an email for the application.  Emails can be sent through the REST API
 - Important:
 ## Implements the following protocols:
 - Mappable: used to map an object to JSON
 - CustomStringConvertible: allows class instances to create a string representation of themself
 */
class Mail: Mappable, CustomStringConvertible {
    
    var emailAddress: String!
    var subject: String!
    var body: String!
    
    init() {
        emailAddress = ""
    }
    
    required init?(map: Map) {}
    
    // This class uses the CustomStringConvertible protocol.
    // The description will be printed whenever we try to print a Mail object
    var description: String {
        return "Mail: (\(emailAddress!), \(subject!), \(body!))"
    }
    
    func mapping(map: Map) {
        emailAddress <- map["emailAddress"]
        subject <- map["subject"]
        body <- map["body"]
    }
}
