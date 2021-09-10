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
    @Published var nameStatus = InputStatus.initial
    @Published var isEditingLocation = false
    @Published var isEditingDate = false
    @Published var distanceStatus = InputStatus.initial
    @Published var isEditingDistance = false
    @Published var rawTime = ""
    @Published var displayedTime = ""
    @Published var timeStatus = InputStatus.initial
    @Published var isEditingTime = false
    @Published var isEditingDescription = false
    @Published var showCanceling = false
}
