//
//  NewLog.swift
//  SaintsXCTF
//
//  Created by Andrew Jarombek on 9/2/21.
//  Copyright © 2021 Andy Jarombek. All rights reserved.
//

import SwiftUI

class ExerciseLog: ObservableObject {
    @Published var id: Int? = nil
    @Published var name = ""
    var location = ""
    var date = Date()
    @Published var exerciseType = ExerciseType.run
    var distance = ""
    @Published var metric = Metric.miles
    var time = ""
    @Published var feel = 6.0
    var description = ""
}

func createExerciseLog(log: ExerciseLog) -> Void {
    
}
