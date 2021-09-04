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
    
    var body: some View {
        ExerciseLogView(log: log)
    }
}

struct EditExerciseLogView_Previews: PreviewProvider {
    static var previews: some View {
        EditExerciseLogView()
    }
}
