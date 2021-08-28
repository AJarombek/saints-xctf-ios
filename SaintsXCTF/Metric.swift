//
//  Metric.swift
//  SaintsXCTF
//
//  Created by Andrew Jarombek on 8/28/21.
//  Copyright © 2021 Andy Jarombek. All rights reserved.
//

import Foundation

enum Metric: String, CaseIterable, Identifiable {
    case miles
    case kilometers
    case meters
    
    var id: String {
        self.rawValue
    }
}
