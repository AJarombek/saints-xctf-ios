//
//  ExerciseLogForm.swift
//  SaintsXCTF
//
//  Created by Andrew Jarombek on 9/9/21.
//  Copyright © 2021 Andy Jarombek. All rights reserved.
//

import SwiftUI

class ExerciseLogForm: ObservableObject {
    @Published var isEditingName = false
    var nameStatus = InputStatus.initial
    @Published var isEditingLocation = false
    @Published var isEditingDate = false
    var distanceStatus = InputStatus.initial
    @Published var isEditingDistance = false
    @Published var displayedTime = ""
    var timeStatus = InputStatus.initial
    @Published var isEditingTime = false
    @Published var isEditingDescription = false
    @Published var showCanceling = false
    
    func reset() {
        nameStatus = InputStatus.initial
        distanceStatus = InputStatus.initial
        displayedTime = ""
        timeStatus = InputStatus.initial
    }
}
