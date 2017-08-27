//
//  Constants.swift
//  SaintsXCTF
//
//  Created by Andy Jarombek on 8/27/17.
//  Copyright © 2017 Andy Jarombek. All rights reserved.
//

import Foundation

class Constants {
    
    private static let feel_colors = [0xEA9999, 0xFFAD99, 0xEAC199, 0xFFD699, 0xFFFFAD, 0xE3E3E3, 0xC7F599,
                       0x99D699, 0x99C199, 0xA3A3FF]
    
    private static let feel_descriptions = ["Terrible", "Very Bad", "Bad", "Pretty Bad", "Mediocre", "Average",
                             "Fairly Good", "Good", "Great", "Fantastic"]
    
    static func getFeelColor(_ index: Int) -> Int {
        return feel_colors[index]
    }
    
    static func getFeelDescription(_ index: Int) -> String {
        return feel_descriptions[index]
    }
}
