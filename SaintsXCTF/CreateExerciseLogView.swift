//
//  CreateExerciseLogView.swift
//  SaintsXCTF
//
//  Created by Andrew Jarombek on 9/3/21.
//  Copyright © 2021 Andy Jarombek. All rights reserved.
//

import SwiftUI

struct CreateExerciseLogView: View {
    @StateObject var log = ExerciseLog()
    @StateObject var meta = ExerciseLogMeta(isExisting: false)
    @StateObject var createLog = CreateExerciseLog()
    @StateObject var form = ExerciseLogForm()
    
    var body: some View {
        ExerciseLogView(log: log, meta: meta, createLog: createLog, form: form)
    }
}

struct CreateExerciseLogView_Previews: PreviewProvider {
    static let previewAllDevices = false
    
    static var previews: some View {
        if previewAllDevices {
            ForEach(Devices.IPhonesSupported, id: \.self) { deviceName in
                CreateExerciseLogView()
                    .previewDevice(PreviewDevice(rawValue: deviceName))
                
                CreateExerciseLogView()
                    .previewDevice(PreviewDevice(rawValue: deviceName))
                    .environment(\.colorScheme, .dark)
            }
        } else {
            CreateExerciseLogView()
                .previewDisplayName("Default")
            
            CreateExerciseLogView()
                .environment(\.colorScheme, .dark)
                .previewDisplayName("Dark Mode")
        }
    }
}
