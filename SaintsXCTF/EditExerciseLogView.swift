//
//  EditExerciseLogView.swift
//  SaintsXCTF
//
//  Created by Andrew Jarombek on 9/3/21.
//  Copyright © 2021 Andy Jarombek. All rights reserved.
//

import SwiftUI

struct EditExerciseLogView: View {
    @StateObject var log = ExerciseLog()
    @StateObject var meta = ExerciseLogMeta(isExisting: true)
    @StateObject var createLog = CreateExerciseLog()
    @StateObject var form = ExerciseLogForm()
    
    var body: some View {
        ExerciseLogView(log: log, meta: meta, createLog: createLog, form: form)
    }
}

struct EditExerciseLogView_Previews: PreviewProvider {
    static let previewAllDevices = false
    
    static var previews: some View {
        if previewAllDevices {
            ForEach(Devices.IPhonesSupported, id: \.self) { deviceName in
                EditExerciseLogView()
                    .previewDevice(PreviewDevice(rawValue: deviceName))
            }
        } else {
            EditExerciseLogView()
        }
    }
}