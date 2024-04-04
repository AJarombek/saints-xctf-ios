//
//  ExerciseLogFormView.swift
//  SaintsXCTF
//
//  Created by Andrew Jarombek on 9/9/21.
//  Copyright © 2021 Andy Jarombek. All rights reserved.
//

import SwiftUI
import Combine

struct ExerciseLogFormView: View {
    @Environment(\.colorScheme) private var colorScheme: ColorScheme
    
    @ObservedObject var log: ExerciseLog
    @ObservedObject var meta: ExerciseLogMeta
    @ObservedObject var createLog: CreateExerciseLog
    @ObservedObject var form: ExerciseLogForm
    
    @State var rawTime = ""
    
    let dateRange: ClosedRange<Date> = {
        let calendar = Calendar.current
        let startComponents = DateComponents(year: 1994, month: 12, day: 31)
        let endComponents = DateComponents(
            year: calendar.component(.year, from: Date()),
            month: calendar.component(.month, from: Date()),
            day: calendar.component(.day, from: Date())
        )
        return calendar.date(from: startComponents)! ... calendar.date(from: endComponents)!
    }()
    
    let formatter: DateFormatter = {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        return dateFormatter
    }()
    
    let nameTextLimit = 40
    let locationTextLimit = 50
    let timeTextLimit = 6
    let descriptionTextLimit = 1000
    
    var body: some View {
        VStack(alignment: .leading) {
            HStack {
                Text(Constants.getFeelDescription(Int(log.feel) - 1))
                    .font(.subheadline)
                    .foregroundColor(Color(ColorSet.tip.rawValue))
            }
            .frame(minWidth: 0, maxWidth: .infinity, alignment: .trailing)
            
            VStack(alignment: .leading) {
                Text("Exercise Name*")
                    .font(.subheadline)
                    .foregroundColor(Color(ColorSet.brown.rawValue))
                    .bold()
                
                VStack(alignment: .leading) {
                    TextField("", text: $log.name) { isEditing in
                        form.isEditingName = isEditing
                    }
                    .onChange(of: log.name) { _ in
                        limitNameText(nameTextLimit)
                        validateNameText()
                    }
                    .accessibility(label: Text("Name Field"))
                    .autocapitalization(.none)
                    .disableAutocorrection(true)
                    .background(Color(ColorSet.white.rawValue))
                    .border(
                        Color(ColorSet.cream.rawValue),
                        width: form.isEditingName ? 1 : 0
                    )
                    .border(
                        Color(UIColor(Constants.statusWarning)),
                        width: form.nameStatus == InputStatus.warning ? 2 : 0
                    )
                    .border(
                        Color(UIColor(Constants.statusFailure)),
                        width: form.nameStatus == InputStatus.failure ? 2 : 0
                    )
                    .frame(minHeight: 30)
                    .disabled(createLog.creating)
                    
                    if form.nameStatus == InputStatus.warning || form.nameStatus == InputStatus.failure {
                        Text("Exercise logs must have a name.")
                            .font(.caption)
                            .foregroundColor(Color(UIColor(Constants.statusFailure)))
                            .accessibility(label: Text("Name Validation Text"))
                    }
                }
            }
            .padding(.top, 5.0)
            
            HStack {
                VStack(alignment: .leading) {
                    Text("Location")
                        .font(.subheadline)
                        .foregroundColor(Color(ColorSet.brown.rawValue))
                        .bold()
                    
                    TextField("", text: $log.location) { isEditing in
                        form.isEditingLocation = isEditing
                    }
                    .onChange(of: log.location) { _ in
                        limitLocationText(locationTextLimit)
                    }
                    .accessibility(label: Text("Location Field"))
                    .autocapitalization(.none)
                    .disableAutocorrection(true)
                    .background(Color(ColorSet.white.rawValue))
                    .border(
                        Color(ColorSet.cream.rawValue),
                        width: form.isEditingLocation ? 1 : 0
                    )
                    .frame(minHeight: 30)
                    .disabled(createLog.creating)
                }
                VStack(alignment: .leading) {
                    Text("Date*")
                        .font(.subheadline)
                        .foregroundColor(Color(ColorSet.brown.rawValue))
                        .bold()
                        .padding(.leading, 8)
                    
                    DatePicker(
                        "",
                        selection: $log.date,
                        in: dateRange,
                        displayedComponents: [.date]
                    )
                    .accessibility(label: Text(formatter.string(from: log.date)))
                    .frame(minWidth: 0, maxWidth: .infinity, minHeight: 30)
                    .accentColor(Color(UIColor(Constants.saintsXctfRed)))
                    .disabled(createLog.creating)
                }
                .frame(minWidth: 0, maxWidth: 130)
            }
            .padding(.top, 5.0)
            .frame(minWidth: 0, maxWidth: .infinity, alignment: .leading)
            
            HStack {
                VStack(alignment: .leading) {
                    Text("Exercise Type")
                        .font(.subheadline)
                        .foregroundColor(Color(ColorSet.brown.rawValue))
                        .bold()
                    
                    Picker(
                        selection: $log.exerciseType,
                        label: Text("\(log.exerciseType.rawValue.capitalized)")
                    ) {
                        ForEach(ExerciseType.allCases) { type in
                            Text(type.rawValue.capitalized)
                                .accessibility(label: Text(type.rawValue.capitalized))
                                .tag(type)
                        }
                    }
                    .accessibility(label: Text(log.exerciseType.rawValue.capitalized))
                    .pickerStyle(MenuPickerStyle())
                    .foregroundColor(Color(UIColor(Constants.saintsXctfRed)))
                    .frame(width: 80, alignment: .leading)
                    .disabled(createLog.creating)
                }
            }
            .padding(.top, 5.0)
            
            HStack {
                VStack(alignment: .leading) {
                    Text("Distance")
                        .font(.subheadline)
                        .foregroundColor(Color(ColorSet.brown.rawValue))
                        .bold()
                    
                    HStack {
                        TextField("", text: $log.distance) { isEditing in
                            form.isEditingDistance = isEditing
                        }
                        .onChange(of: log.distance) { _ in
                            filterDistanceText()
                            validateTimeAndDistance()
                        }
                        .accessibility(label: Text("Distance Field"))
                        .autocapitalization(.none)
                        .disableAutocorrection(true)
                        .keyboardType(.numbersAndPunctuation)
                        .background(Color(ColorSet.white.rawValue))
                        .border(
                            Color(ColorSet.cream.rawValue),
                            width: form.isEditingDistance ? 1 : 0
                        )
                        .border(
                            Color(UIColor(Constants.statusWarning)),
                            width: form.distanceStatus == InputStatus.warning ? 2 : 0
                        )
                        .border(
                            Color(UIColor(Constants.statusFailure)),
                            width: form.distanceStatus == InputStatus.failure ? 2 : 0
                        )
                        .frame(minWidth: 90, minHeight: 30)
                        
                        Picker(
                            selection: $log.metric,
                            label: Text("\(log.metric.rawValue.capitalized)")
                        ) {
                            ForEach(Metric.allCases) { metric in
                                Text(metric.rawValue.capitalized)
                                    .accessibility(label: Text(metric.rawValue.capitalized))
                                    .tag(metric)
                            }
                        }
                        .accessibility(label: Text(log.metric.rawValue.capitalized))
                        .pickerStyle(MenuPickerStyle())
                        .foregroundColor(Color(UIColor(Constants.saintsXctfRed)))
                        .frame(width: 90, alignment: .leading)
                        .disabled(createLog.creating)
                    }
                    
                    if form.distanceStatus == InputStatus.warning || form.distanceStatus == InputStatus.failure {
                        Text("A distance is required if no time is entered.")
                            .font(.caption)
                            .foregroundColor(Color(UIColor(Constants.statusFailure)))
                            .accessibility(label: Text("Distance Validation Text"))
                    }
                }
                VStack(alignment: .leading) {
                    Text("Time")
                        .font(.subheadline)
                        .foregroundColor(Color(ColorSet.brown.rawValue))
                        .bold()
                    
                    TextField("", text: $form.displayedTime) { isEditing in
                        form.isEditingTime = isEditing
                    }
                    .onChange(of: form.displayedTime) { _ in
                        filterTimeText()
                        limitTimeText(timeTextLimit)
                        setFormattedTimeText()
                        validateTimeAndDistance()
                    }
                    .accessibility(label: Text("Time Field"))
                    .autocapitalization(.none)
                    .disableAutocorrection(true)
                    .keyboardType(.numbersAndPunctuation)
                    .background(Color(ColorSet.white.rawValue))
                    .border(
                        Color(ColorSet.cream.rawValue),
                        width: form.isEditingTime ? 1 : 0
                    )
                    .border(
                        Color(UIColor(Constants.statusWarning)),
                        width: form.timeStatus == InputStatus.warning ? 2 : 0
                    )
                    .border(
                        Color(UIColor(Constants.statusFailure)),
                        width: form.timeStatus == InputStatus.failure ? 2 : 0
                    )
                    .frame(minHeight: 30)
                    .disabled(createLog.creating)
                    
                    if form.timeStatus == InputStatus.warning || form.timeStatus == InputStatus.failure {
                        Text("A time is required if no distance is entered.")
                            .font(.caption)
                            .foregroundColor(Color(UIColor(Constants.statusFailure)))
                            .accessibility(label: Text("Time Validation Text"))
                    }
                }
            }
            .padding(.top, 5.0)
            
            HStack {
                VStack(alignment: .leading) {
                    Text("Feel")
                        .font(.subheadline)
                        .foregroundColor(Color(ColorSet.brown.rawValue))
                        .bold()
                    
                    Slider(
                        value: $log.feel,
                        in: 1...10,
                        step: 1
                    ) {
                        Text("Title")
                    }
                    .accessibility(label: Text("Feel"))
                    .accentColor(Color(UIColor(Constants.saintsXctfRed)))
                    .disabled(createLog.creating)
                }
            }
            .padding(.top, 5.0)
            
            HStack {
                VStack(alignment: .leading) {
                    Text("Description")
                        .font(.subheadline)
                        .foregroundColor(Color(ColorSet.brown.rawValue))
                        .bold()
                    
                    TextField("", text: $log.description) { isEditing in
                        form.isEditingDescription = isEditing
                    }
                    .onReceive(Just(log.description), perform: { _ in
                        limitDescriptionText(descriptionTextLimit)
                    })
                    .accessibility(label: Text("Description Field"))
                    .autocapitalization(.none)
                    .disableAutocorrection(true)
                    .background(Color(ColorSet.white.rawValue))
                    .border(
                        Color(ColorSet.cream.rawValue),
                        width: form.isEditingDescription ? 1 : 0
                    )
                    .frame(minHeight: 30)
                    .disabled(createLog.creating)
                }
            }
            .padding(.top, 5.0)
            
            ExerciseLogActionsView(log: log, meta: meta, createLog: createLog, form: form)
        }
        .padding()
        .overlay(
            Rectangle()
                .stroke(Color.gray, lineWidth: 0.25)
                .shadow(radius: 2)
        )
        .background(Color.init(Constants.getFeelUIColor(Int(log.feel - 1), colorScheme)))
        .cornerRadius(5)
        .textFieldStyle(RoundedBorderTextFieldStyle())
    }
    
    func limitNameText(_ upper: Int) {
        if log.name.count > upper {
            log.name = String(log.name.prefix(upper))
        }
    }
    
    func validateNameText() {
        if log.name.count == 0 {
            if form.nameStatus != InputStatus.initial {
                form.nameStatus = InputStatus.warning
            }
        } else {
            form.nameStatus = InputStatus.none
        }
    }
    
    func limitLocationText(_ upper: Int) {
        if log.location.count > upper {
            log.location = String(log.location.prefix(upper))
        }
    }
    
    func filterTimeText() {
        rawTime = form.displayedTime
        
        var filteredTime = ""
        for char in rawTime {
            if let intValue = char.wholeNumberValue {
                filteredTime += "\(intValue)"
            }
        }
        
        rawTime = filteredTime
    }
    
    func limitTimeText(_ upper: Int) {
        if rawTime.count > upper {
            rawTime = String(rawTime.prefix(upper))
        }
    }
    
    func setFormattedTimeText() {
        form.displayedTime = rawTime
            .enumerated()
            .map {
                ((rawTime.count - $0.offset) % 2 != 0) || $0.offset == 0 ?
                    $0.element.description : ":\($0.element)"
            }.reduce("") {
                $0 + $1
            }
        
        log.time = form.displayedTime
    }
    
    func filterDistanceText() {
        var decimalPointUsed = false
        var filteredDistance = ""
        
        for char in log.distance {
            if let intValue = char.wholeNumberValue {
                filteredDistance += "\(intValue)"
            } else if char == "." && !decimalPointUsed {
                filteredDistance += char.description
                decimalPointUsed = true
            }
        }
        
        log.distance = filteredDistance
    }
    
    func validateTimeAndDistance() {
        if log.time.count == 0 && log.distance.count == 0 {
            if form.timeStatus != InputStatus.initial {
                form.timeStatus = InputStatus.warning
            }
            
            if form.distanceStatus != InputStatus.initial {
                form.distanceStatus = InputStatus.warning
            }
        } else {
            form.timeStatus = InputStatus.none
            form.distanceStatus = InputStatus.none
        }
    }
    
    func limitDescriptionText(_ upper: Int) {
        if log.description.count > upper {
            log.description = String(log.description.prefix(upper))
        }
    }
}

struct ExerciseLogFormView_Previews: PreviewProvider {
    static let previewAllDevices = false

    static var previews: some View {
        if previewAllDevices {
            ForEach(Devices.IPhonesSupported, id: \.self) { deviceName in
                ExerciseLogFormView(
                    log: ExerciseLog(),
                    meta: ExerciseLogMeta(isExisting: false),
                    createLog: CreateExerciseLog(),
                    form: ExerciseLogForm()
                )
                .previewDevice(PreviewDevice(rawValue: deviceName))
                .previewDisplayName("Default")
                
                ExerciseLogFormView(
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
            ExerciseLogFormView(
                log: ExerciseLog(),
                meta: ExerciseLogMeta(isExisting: false),
                createLog: CreateExerciseLog(),
                form: ExerciseLogForm()
            )
            .previewDisplayName("Default")
            
            ExerciseLogFormView(
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
