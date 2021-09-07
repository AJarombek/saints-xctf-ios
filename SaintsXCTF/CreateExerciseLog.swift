//
//  CreateExerciseLog.swift
//  SaintsXCTF
//
//  Created by Andrew Jarombek on 9/6/21.
//  Copyright © 2021 Andy Jarombek. All rights reserved.
//

import SwiftUI

class CreateExerciseLog: ObservableObject {
    @Published var creating = false
    @Published var created = false
    @Published var error: String? = nil
    
    func createExerciseLog(exerciseLog: ExerciseLog) -> Void {
        creating = true
        created = false
        error = nil
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        let formattedDate = dateFormatter.string(from: exerciseLog.date)
        
        let timeFormat = "00:00:00"
        let end = timeFormat.index(timeFormat.endIndex, offsetBy: 0 - exerciseLog.time.count)
        let formattedTime = "\(timeFormat[timeFormat.startIndex...end])\(exerciseLog.time)"
        
        let user = SignedInUser.user
        
        let log = Log()
        log.name = exerciseLog.name
        log.username = user.username
        log.first = user.first
        log.last = user.last
        log.location = exerciseLog.location
        log.date = formattedDate
        log.type = exerciseLog.exerciseType.rawValue
        log.distance = Double(exerciseLog.distance)
        log.metric = exerciseLog.metric.rawValue
        log.time = formattedTime
        log.feel = Int(exerciseLog.feel)
        log.log_description = exerciseLog.description
        
        APIClient.logPostRequest(withLog: log, fromController: nil) {
            (newlog) -> Void in
            
            self.creating = false
            
            if newlog != nil {
                self.created = true
            } else {
                self.error = "Failed to Create New Exercise Log"
            }
        }
    }
    
    func updateExerciseLog(newLog: ExerciseLog, existingLog: Log) -> Void {
        
    }
}
