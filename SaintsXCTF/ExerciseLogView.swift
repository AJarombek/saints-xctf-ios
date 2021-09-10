//
//  ExerciseLogView.swift
//  SaintsXCTF
//
//  Created by Andrew Jarombek on 8/25/21.
//  Copyright © 2021 Andy Jarombek. All rights reserved.
//

import SwiftUI
import Combine

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
                
                ExerciseLogFormView(log: log, meta: meta, createLog: createLog, form: form)
            }
            .padding()
            .padding(.top, 20)
            .alert(isPresented: $createLog.created) {
                Alert(
                    title: Text(meta.isExistingLog ? "Exercise log updated!" : "Exercise log created!"),
                    dismissButton: .cancel(
                        Text("Continue"),
                        action: {
                            print("Continue")
                        }
                    )
                )
            }
            .alert(isPresented: $createLog.error) {
                Alert(
                    title: Text("An unexpected error occurred while creating an exercise log."),
                    primaryButton: .default(
                        Text("Try Again"),
                        action: {
                            print("Try Again")
                        }
                    ),
                    secondaryButton: .cancel(
                        Text("Cancel"),
                        action: {
                            print("Cancel")
                        }
                    )
                )
            }
            .alert(isPresented: $form.showCanceling) {
                Alert(
                    title: Text("Are you sure you want to cancel your changes?"),
                    message: Text("Your progress will be lost."),
                    primaryButton: .default(
                        Text("Yes"),
                        action: {
                            onConfirmCancel()
                        }
                    ),
                    secondaryButton: .cancel(
                        Text("No")
                    )
                )
            }
        }
        .progressViewStyle(
            CircularProgressViewStyle(tint: Color(UIColor(Constants.saintsXctfRed)))
        )
    }
    
    func onConfirmCancel() {
        reset()
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
