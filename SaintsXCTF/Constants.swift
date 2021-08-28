//
//  Constants.swift
//  SaintsXCTF
//
//  Created by Andy Jarombek on 8/27/17.
//  Copyright © 2017 Andy Jarombek. All rights reserved.
//

import Foundation

/**
 Constant values used throughout the application.
 */
class Constants {
    
    public static let saintsXctfRed = 0x990000
    public static let spotPaletteBrown = 0xA96A5B
    public static let spotPaletteCream = 0xFFE6D9
    public static let spotPaletteBlue = 0x58B7D2
    public static let darkGray = 0x555555
    
    private static let feel_colors = [0xEA9999, 0xFFAD99, 0xEAC199, 0xFFD699, 0xFFFFAD, 0xE3E3E3, 0xC7F599,
                       0x99D699, 0x99C199, 0xA3A3FF]
    
    private static let feel_descriptions = ["Terrible", "Very Bad", "Bad", "Pretty Bad", "Mediocre", "Average",
                             "Fairly Good", "Good", "Great", "Fantastic"]
    
    /**
     Retrieve a color that corresponds to how someone felt in their exercise
     - parameters:
     - index: the location of the feel color in the feel_colors array
     */
    static func getFeelColor(_ index: Int) -> Int {
        return feel_colors[index]
    }
    
    /**
     Retrieve a string that corresponds to how someone felt in their exercise
     - parameters:
     - index: the location of the feel description in the feel_descriptions array
     */
    static func getFeelDescription(_ index: Int) -> String {
        return feel_descriptions[index]
    }
}
