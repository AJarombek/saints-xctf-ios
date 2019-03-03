//
//  LogData.swift
//  SaintsXCTF
//
//  Created by Andy Jarombek on 10/17/17.
//  Copyright © 2017 Andy Jarombek. All rights reserved.
//

import Foundation

/**
 Model class that represents data held in a LogTableViewCell
 - SeeAlso: `LogTableViewCell`
 */
class LogData {
    
    var log: Log!
    var username: String!
    var feel: Int!
    var userLabelText: NSMutableAttributedString!
    var date: String!
    var name: String!
    var type: String?
    var description: String?
    var descriptionTags: NSMutableAttributedString?
    
    /**
     Empty default initializer for the class
     */
    init() {}
}
