//
//  ExerciseType.swift
//  SaintsXCTF
//
//  Created by Andrew Jarombek on 8/27/21.
//  Copyright © 2021 Andy Jarombek. All rights reserved.
//

import Foundation

enum ExerciseType: String, CaseIterable, Identifiable {
    case run
    case bike
    case swim
    case other
    
    var id: String {
        self.rawValue
    }
}
