//
//  ExerciseLogMeta.swift
//  SaintsXCTF
//
//  Created by Andrew Jarombek on 9/3/21.
//  Copyright © 2021 Andy Jarombek. All rights reserved.
//

import SwiftUI

class ExerciseLogMeta: ObservableObject {
    
    init(isExisting: Bool) {
        self.isExistingLog = isExisting
    }
    
    var isExistingLog = false
    var existingLogInitialized = false
}
