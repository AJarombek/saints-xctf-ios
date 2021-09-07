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
    
    @State private var isEditingName: Bool = false
    @State private var nameStatus: InputStatus = InputStatus.initial
    @State private var isEditingLocation: Bool = false
    @State private var isEditingDate: Bool = false
    @State private var distanceStatus: InputStatus = InputStatus.initial
    @State private var isEditingDistance: Bool = false
    @State private var rawTime: String = ""
    @State private var displayedTime: String = ""
    @State private var timeStatus: InputStatus = InputStatus.initial
    @State private var isEditingTime: Bool = false
    @State private var isEditingDescription: Bool = false
    
    @State private var showSuccess: Bool = false
    @State private var showError: Bool = false
    @State private var showCanceling: Bool = false
    
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
    
    let nameTextLimit = 40
    let locationTextLimit = 50
    let timeTextLimit = 6
    let descriptionTextLimit = 1000
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading) {
                Text(meta.isExistingLog ? "Edit Exercise Log" : "Create Exercise Log")
                    .font(.title)
                    .foregroundColor(.black)
                    .bold()
                
                VStack(alignment: .leading) {
                    HStack {
                        Text(Constants.getFeelDescription(Int(log.feel) - 1))
                            .font(.subheadline)
                            .foregroundColor(Color(UIColor(0x737373)))
                    }
                    .frame(minWidth: 0, maxWidth: .infinity, alignment: .trailing)
                    
                    VStack(alignment: .leading) {
                        Text("Exercise Name*")
                            .font(.subheadline)
                            .foregroundColor(Color(UIColor(Constants.spotPaletteBrown)))
                            .bold()
                        
                        VStack(alignment: .leading) {
                            TextField("", text: $log.name) { isEditing in
                                self.isEditingName = isEditing
                            }
                            .onReceive(Just(log.name), perform: { _ in
                                limitNameText(nameTextLimit)
                                validateNameText()
                            })
                            .autocapitalization(.none)
                            .disableAutocorrection(true)
                            .background(Color(UIColor.white))
                            .border(
                                Color(UIColor(Constants.spotPaletteCream)),
                                width: isEditingName ? 1 : 0
                            )
                            .border(
                                Color(UIColor(Constants.statusWarning)),
                                width: nameStatus == InputStatus.warning ? 2 : 0
                            )
                            .border(
                                Color(UIColor(Constants.statusFailure)),
                                width: nameStatus == InputStatus.failure ? 2 : 0
                            )
                            .frame(minHeight: 30)
                            .disabled(createLog.creating)
                            
                            if nameStatus == InputStatus.warning {
                                Text("Exercise logs must have a name.")
                                    .font(.caption)
                                    .foregroundColor(Color(UIColor(Constants.statusFailure)))
                            }
                        }
                    }
                    .padding(.top, 5.0)
                    
                    HStack {
                        VStack(alignment: .leading) {
                            Text("Location")
                                .font(.subheadline)
                                .foregroundColor(Color(UIColor(Constants.spotPaletteBrown)))
                                .bold()
                            
                            TextField("", text: $log.location) { isEditing in
                                self.isEditingLocation = isEditing
                            }
                            .onReceive(Just(log.location), perform: { _ in
                                limitLocationText(locationTextLimit)
                            })
                            .autocapitalization(.none)
                            .disableAutocorrection(true)
                            .background(Color(UIColor.white))
                            .border(
                                Color(UIColor(Constants.spotPaletteCream)),
                                width: isEditingLocation ? 1 : 0
                            )
                            .frame(minHeight: 30)
                            .disabled(createLog.creating)
                        }
                        VStack(alignment: .leading) {
                            Text("Date*")
                                .font(.subheadline)
                                .foregroundColor(Color(UIColor(Constants.spotPaletteBrown)))
                                .bold()
                                .padding(.leading, 8)
                            
                            DatePicker(
                                "",
                                selection: $log.date,
                                in: dateRange,
                                displayedComponents: [.date]
                            )
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
                                .foregroundColor(Color(UIColor(Constants.spotPaletteBrown)))
                                .bold()
                            
                            Picker(
                                selection: $log.exerciseType,
                                label: Text("\(log.exerciseType.rawValue.capitalized)")
                            ) {
                                ForEach(ExerciseType.allCases) { type in
                                    Text(type.rawValue.capitalized)
                                        .tag(type)
                                }
                            }
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
                                .foregroundColor(Color(UIColor(Constants.spotPaletteBrown)))
                                .bold()
                            
                            HStack {
                                TextField("", text: $log.distance) { isEditing in
                                    self.isEditingDistance = isEditing
                                }
                                .onReceive(Just(log.distance), perform: { _ in
                                    filterDistanceText()
                                    validateTimeAndDistance()
                                })
                                .autocapitalization(.none)
                                .disableAutocorrection(true)
                                .keyboardType(.numbersAndPunctuation)
                                .background(Color(UIColor.white))
                                .border(
                                    Color(UIColor(Constants.spotPaletteCream)),
                                    width: isEditingDistance ? 1 : 0
                                )
                                .border(
                                    Color(UIColor(Constants.statusWarning)),
                                    width: distanceStatus == InputStatus.warning ? 2 : 0
                                )
                                .border(
                                    Color(UIColor(Constants.statusFailure)),
                                    width: distanceStatus == InputStatus.failure ? 2 : 0
                                )
                                .frame(minWidth: 90, minHeight: 30)
                                
                                Picker(
                                    selection: $log.metric,
                                    label: Text("\(log.metric.rawValue.capitalized)")
                                ) {
                                    ForEach(Metric.allCases) { metric in
                                        Text(metric.rawValue.capitalized)
                                            .tag(metric)
                                    }
                                }
                                .pickerStyle(MenuPickerStyle())
                                .foregroundColor(Color(UIColor(Constants.saintsXctfRed)))
                                .frame(width: 90, alignment: .leading)
                                .disabled(createLog.creating)
                            }
                            
                            if distanceStatus == InputStatus.warning {
                                Text("A distance is required if no time is entered.")
                                    .font(.caption)
                                    .foregroundColor(Color(UIColor(Constants.statusFailure)))
                            }
                        }
                        VStack(alignment: .leading) {
                            Text("Time")
                                .font(.subheadline)
                                .foregroundColor(Color(UIColor(Constants.spotPaletteBrown)))
                                .bold()
                            
                            TextField("", text: $displayedTime) { isEditing in
                                self.isEditingTime = isEditing
                            }
                            .onReceive(Just(displayedTime), perform: { _ in
                                filterTimeText()
                                limitTimeText(timeTextLimit)
                                setFormattedTimeText()
                                validateTimeAndDistance()
                            })
                            .autocapitalization(.none)
                            .disableAutocorrection(true)
                            .keyboardType(.numbersAndPunctuation)
                            .background(Color(UIColor.white))
                            .border(
                                Color(UIColor(Constants.spotPaletteCream)),
                                width: isEditingTime ? 1 : 0
                            )
                            .border(
                                Color(UIColor(Constants.statusWarning)),
                                width: timeStatus == InputStatus.warning ? 2 : 0
                            )
                            .border(
                                Color(UIColor(Constants.statusFailure)),
                                width: timeStatus == InputStatus.failure ? 2 : 0
                            )
                            .frame(minHeight: 30)
                            .disabled(createLog.creating)
                            
                            if timeStatus == InputStatus.warning {
                                Text("A time is required if no distance is entered.")
                                    .font(.caption)
                                    .foregroundColor(Color(UIColor(Constants.statusFailure)))
                            }
                        }
                    }
                    .padding(.top, 5.0)
                    
                    HStack {
                        VStack(alignment: .leading) {
                            Text("Feel")
                                .font(.subheadline)
                                .foregroundColor(Color(UIColor(Constants.spotPaletteBrown)))
                                .bold()
                            
                            Slider(
                                value: $log.feel,
                                in: 1...10,
                                step: 1
                            ) {
                                Text("Title")
                            }
                            .accentColor(Color(UIColor(Constants.saintsXctfRed)))
                            .disabled(createLog.creating)
                        }
                    }
                    .padding(.top, 5.0)
                    
                    HStack {
                        VStack(alignment: .leading) {
                            Text("Description")
                                .font(.subheadline)
                                .foregroundColor(Color(UIColor(Constants.spotPaletteBrown)))
                                .bold()
                            
                            TextField("", text: $log.description) { isEditing in
                                self.isEditingDescription = isEditing
                            }
                            .onReceive(Just(log.description), perform: { _ in
                                limitDescriptionText(descriptionTextLimit)
                            })
                            .autocapitalization(.none)
                            .disableAutocorrection(true)
                            .background(Color(UIColor.white))
                            .border(
                                Color(UIColor(Constants.spotPaletteCream)),
                                width: isEditingDescription ? 1 : 0
                            )
                            .frame(minHeight: 30)
                            .disabled(createLog.creating)
                        }
                    }
                    .padding(.top, 5.0)
                    
                    HStack(spacing: 20) {
                        Button(action: {
                            onCreate()
                        }) {
                            if !isCreating {
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
                .padding()
                .overlay(
                    Rectangle()
                        .stroke(Color.gray, lineWidth: 0.25)
                        .shadow(radius: 2)
                )
                .background(Color.init(UIColor(Constants.getFeelColor(Int(log.feel - 1)))))
                .cornerRadius(5)
                .textFieldStyle(RoundedBorderTextFieldStyle())
            }
            .padding()
            .padding(.top, 20)
            .alert(isPresented: $showSuccess) {
                Alert(
                    title: Text("Exercise log created!"),
                    dismissButton: .cancel(
                        Text("Continue"),
                        action: {
                            print("Continue")
                        }
                    )
                )
            }
            .alert(isPresented: $showError) {
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
            .alert(isPresented: $showCanceling) {
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
    
    func limitNameText(_ upper: Int) {
        if log.name.count > upper {
            log.name = String(log.name.prefix(upper))
        }
    }
    
    func validateNameText() {
        if log.name.count == 0 {
            if nameStatus != InputStatus.initial {
                nameStatus = InputStatus.warning
            }
        } else {
            nameStatus = InputStatus.none
        }
    }
    
    func limitLocationText(_ upper: Int) {
        if log.location.count > upper {
            log.location = String(log.location.prefix(upper))
        }
    }
    
    func filterTimeText() {
        rawTime = displayedTime
        
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
        displayedTime = rawTime
            .enumerated()
            .map {
                ((rawTime.count - $0.offset) % 2 != 0) || $0.offset == 0 ?
                    $0.element.description : ":\($0.element)"
            }.reduce("") {
                $0 + $1
            }
        
        log.time = displayedTime
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
        if rawTime.count == 0 && log.distance.count == 0 {
            if timeStatus != InputStatus.initial {
                timeStatus = InputStatus.warning
            }
            
            if distanceStatus != InputStatus.initial {
                distanceStatus = InputStatus.warning
            }
        } else {
            timeStatus = InputStatus.none
            distanceStatus = InputStatus.none
        }
    }
    
    func limitDescriptionText(_ upper: Int) {
        if log.description.count > upper {
            log.description = String(log.description.prefix(upper))
        }
    }
    
    func onCancel() {
        showCanceling = true
    }
    
    func onConfirmCancel() {
        reset()
    }
    
    func onCreate() {
        var failedValidation = false
        
        if log.name.trimmingCharacters(in: .whitespaces).count == 0 {
            failedValidation = true
            nameStatus = InputStatus.failure
        }
        
        if rawTime.count == 0 && log.distance.count == 0 {
            failedValidation = true
            timeStatus = InputStatus.failure
            distanceStatus = InputStatus.failure
        }
        
        if !failedValidation {
            if meta.isExistingLog {
                createLog.updateExerciseLog(newLog: log, existingLog: Log())
            } else {
                createLog.createExerciseLog(exerciseLog: log)
            }
        }
    }
    
    func reset() {
        log.name = ""
        nameStatus = InputStatus.initial
        log.location = ""
        log.date = Date()
        log.exerciseType = ExerciseType.run
        log.distance = ""
        distanceStatus = InputStatus.initial
        log.metric = Metric.miles
        rawTime = ""
        displayedTime = ""
        timeStatus = InputStatus.initial
        log.time = ""
        log.feel = 6.0
        log.description = ""
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
                    createLog: CreateExerciseLog()
                )
                .previewDevice(PreviewDevice(rawValue: deviceName))
            }
        } else {
            ExerciseLogView(
                log: ExerciseLog(),
                meta: ExerciseLogMeta(isExisting: false),
                createLog: CreateExerciseLog()
            )
        }
    }
}
