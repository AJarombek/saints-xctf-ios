//
//  ExerciseLogView.swift
//  SaintsXCTF
//
//  Created by Andrew Jarombek on 8/25/21.
//  Copyright © 2021 Andy Jarombek. All rights reserved.
//

import SwiftUI

struct ExerciseLogView: View {
    @EnvironmentObject var existingLog: ExistingLog
    
    @ObservedObject var log: ExerciseLog
    @ObservedObject var meta: ExerciseLogMeta
    @ObservedObject var createLog: CreateExerciseLog
    @ObservedObject var form: ExerciseLogForm
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading) {
                Text(meta.isExistingLog ? "Edit Exercise Log" : "Create Exercise Log")
                    .font(.title)
                    .foregroundColor(Color(ColorSet.text.rawValue))
                    .bold()
                    .alert(isPresented: $createLog.error) {
                        Alert(
                            title: Text(
                                meta.isExistingLog ?
                                    "An unexpected error occurred while updating the exercise log." :
                                    "An unexpected error occurred while creating an exercise log."
                            ),
                            primaryButton: .default(
                                Text("Cancel"),
                                action: {
                                    createLog.error = false
                                }
                            ),
                            secondaryButton: .cancel(
                                Text("Try Again"),
                                action: {
                                    createLog.error = false
                                    
                                    if meta.isExistingLog {
                                        createLog.updateExerciseLog(newLog: log, existingLog: existingLog.log ?? Log()) {}
                                    } else {
                                        createLog.createExerciseLog(exerciseLog: log) {
                                            log.reset()
                                            form.reset()
                                        }
                                    }
                                }
                            )
                        )
                    }
                
                ExerciseLogFormView(log: log, meta: meta, createLog: createLog, form: form)
            }
            .padding()
            .padding(.top, 20)
        }
        .progressViewStyle(
            CircularProgressViewStyle(tint: Color(UIColor(Constants.saintsXctfRed)))
        )
    }
}

struct ExerciseLogView_Previews: PreviewProvider {
    static let previewAllDevices = false

    static var previews: some View {
        if previewAllDevices {
            ForEach(Devices.IPhonesSupported, id: \.self) { deviceName in
                ExerciseLogView(
                    log: ExerciseLog(),
                    meta: ExerciseLogMeta(isExisting: false),
                    createLog: CreateExerciseLog(),
                    form: ExerciseLogForm()
                )
                .previewDevice(PreviewDevice(rawValue: deviceName))
                .previewDisplayName("Default")
                
                ExerciseLogView(
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
            ExerciseLogView(
                log: ExerciseLog(),
                meta: ExerciseLogMeta(isExisting: false),
                createLog: CreateExerciseLog(),
                form: ExerciseLogForm()
            )
            .previewDisplayName("Default")
            
            ExerciseLogView(
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
