//
//  ExerciseLogActions.swift
//  SaintsXCTF
//
//  Created by Andrew Jarombek on 9/9/21.
//  Copyright © 2021 Andy Jarombek. All rights reserved.
//

import SwiftUI

struct ExerciseLogActionsView: View {
    @ObservedObject var log: ExerciseLog
    @ObservedObject var meta: ExerciseLogMeta
    @ObservedObject var createLog: CreateExerciseLog
    @ObservedObject var form: ExerciseLogForm
    
    var body: some View {
        HStack(spacing: 20) {
            Button(action: {
                onCreate()
            }) {
                if !createLog.creating {
                    Text(meta.isExistingLog ? "Update" : "Create")
                        .foregroundColor(Color(UIColor(Constants.saintsXctfRed)))
                } else {
                    Text(meta.isExistingLog ? "Creating  " : "Updating  ")
                        .foregroundColor(Color(UIColor(Constants.saintsXctfRed)))
                    ProgressView()
                }
            }
            .disabled(createLog.creating)
            
            Button(action: {
                onCancel()
            }) {
                Text("Cancel")
                    .foregroundColor(Color(UIColor(Constants.darkGray)))
            }
            .disabled(createLog.creating)
        }
        .padding(.top, 15)
        .padding(.trailing, 10)
        .frame(minWidth: 0, maxWidth: .infinity, alignment: .trailing)
    }
    
    func onCreate() {
        var failedValidation = false
        
        if log.name.trimmingCharacters(in: .whitespaces).count == 0 {
            failedValidation = true
            form.nameStatus = InputStatus.failure
        }
        
        if form.displayedTime.count == 0 && log.distance.count == 0 {
            failedValidation = true
            form.timeStatus = InputStatus.failure
            form.distanceStatus = InputStatus.failure
        }
        
        if !failedValidation {
            if meta.isExistingLog {
                createLog.updateExerciseLog(newLog: log, existingLog: Log()) {
                    log.reset()
                    form.reset()
                }
            } else {
                createLog.createExerciseLog(exerciseLog: log) {
                    log.reset()
                    form.reset()
                }
            }
        }
    }
    
    func onCancel() {
        form.showCanceling = true
    }
}

struct ExerciseLogActionsView_Previews: PreviewProvider {
    static let previewAllDevices = false

    static var previews: some View {
        if previewAllDevices {
            ForEach(Devices.IPhonesSupported, id: \.self) { deviceName in
                ExerciseLogActionsView(
                    log: ExerciseLog(),
                    meta: ExerciseLogMeta(isExisting: false),
                    createLog: CreateExerciseLog(),
                    form: ExerciseLogForm()
                )
                .previewDevice(PreviewDevice(rawValue: deviceName))
            }
        } else {
            ExerciseLogActionsView(
                log: ExerciseLog(),
                meta: ExerciseLogMeta(isExisting: false),
                createLog: CreateExerciseLog(),
                form: ExerciseLogForm()
            )
        }
    }
}
