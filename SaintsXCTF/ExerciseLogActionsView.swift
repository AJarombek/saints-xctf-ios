//
//  ExerciseLogActions.swift
//  SaintsXCTF
//
//  Created by Andrew Jarombek on 9/9/21.
//  Copyright © 2021 Andy Jarombek. All rights reserved.
//

import SwiftUI

struct ExerciseLogActionsView: View {
    @EnvironmentObject var existingLog: ExistingLog
    
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
                    Text(meta.isExistingLog ? "Updating  " : "Creating  ")
                        .foregroundColor(Color(UIColor(Constants.saintsXctfRed)))
                    ProgressView()
                }
            }
            .accessibility(label: Text(meta.isExistingLog ? "Update" : "Create"))
            .disabled(createLog.creating)
            .alert(isPresented: $createLog.created) {
                Alert(
                    title: Text(meta.isExistingLog ? "Exercise log updated!" : "Exercise log created!"),
                    dismissButton: .cancel(
                        Text("Continue"),
                        action: {
                            if !meta.isExistingLog {
                                log.reset()
                                form.reset()
                            }
                        }
                    )
                )
            }
            
            if !meta.isExistingLog {
                Button(action: {
                    onCancel()
                }) {
                    Text("Cancel")
                        .foregroundColor(Color("DarkGrayColor"))
                }
                .accessibility(label: Text("Cancel"))
                .disabled(createLog.creating)
                .alert(isPresented: $form.showCanceling) {
                    Alert(
                        title: Text("Are you sure you want to cancel your changes?"),
                        message: Text("Your progress will be lost."),
                        primaryButton: .default(
                            Text("No")
                        ),
                        secondaryButton: .cancel(
                            Text("Yes"),
                            action: {
                                onConfirmCancel()
                            }
                        )
                    )
                }
            }
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
                createLog.updateExerciseLog(newLog: log, existingLog: existingLog.log ?? Log()) {}
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
    
    func onConfirmCancel() {
        log.reset()
        form.reset()
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
                .previewDisplayName("Default")
                
                ExerciseLogActionsView(
                    log: ExerciseLog(),
                    meta: ExerciseLogMeta(isExisting: false),
                    createLog: CreateExerciseLog(),
                    form: ExerciseLogForm()
                )
                .previewDevice(PreviewDevice(rawValue: deviceName))
                .environment(\.colorScheme, .dark)
                .previewDisplayName("Dark Mode")
            }
        } else {
            ExerciseLogActionsView(
                log: ExerciseLog(),
                meta: ExerciseLogMeta(isExisting: false),
                createLog: CreateExerciseLog(),
                form: ExerciseLogForm()
            )
            .previewDisplayName("Default")
            
            ExerciseLogActionsView(
                log: ExerciseLog(),
                meta: ExerciseLogMeta(isExisting: false),
                createLog: CreateExerciseLog(),
                form: ExerciseLogForm()
            )
            .environment(\.colorScheme, .dark)
            .previewDisplayName("Dark Mode")
        }
    }
}
