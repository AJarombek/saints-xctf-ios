//
//  ExerciseLogView.swift
//  SaintsXCTF
//
//  Created by Andrew Jarombek on 8/25/21.
//  Copyright © 2021 Andy Jarombek. All rights reserved.
//

import SwiftUI

struct ExerciseLogView: View {
    @ObservedObject var log: ExerciseLog
    @ObservedObject var meta: ExerciseLogMeta
    @ObservedObject var createLog: CreateExerciseLog
    @ObservedObject var form: ExerciseLogForm
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading) {
                Text(meta.isExistingLog ? "Edit Exercise Log" : "Create Exercise Log")
                    .font(.title)
                    .foregroundColor(.black)
                    .bold()
                    .alert(isPresented: $createLog.error) {
                        Alert(
                            title: Text("An unexpected error occurred while creating an exercise log."),
                            primaryButton: .default(
                                Text("Try Again"),
                                action: {
                                    createLog.error = false
                                    createLog.createExerciseLog(exerciseLog: log) {
                                        log.reset()
                                        form.reset()
                                    }
                                }
                            ),
                            secondaryButton: .cancel(
                                Text("Cancel"),
                                action: {
                                    createLog.error = false
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
            }
        } else {
            ExerciseLogView(
                log: ExerciseLog(),
                meta: ExerciseLogMeta(isExisting: false),
                createLog: CreateExerciseLog(),
                form: ExerciseLogForm()
            )
        }
    }
}
