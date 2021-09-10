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
    @ObservedObject var log: ExerciseLog
    @ObservedObject var meta: ExerciseLogMeta
    @ObservedObject var createLog: CreateExerciseLog
    @ObservedObject var form: ExerciseLogForm
    
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
                        form.isEditingName = isEditing
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
                    
                    if form.nameStatus == InputStatus.warning {
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
                        form.isEditingLocation = isEditing
                    }
                    .onReceive(Just(log.location), perform: { _ in
                        limitLocationText(locationTextLimit)
                    })
                    .autocapitalization(.none)
                    .disableAutocorrection(true)
                    .background(Color(UIColor.white))
                    .border(
                        Color(UIColor(Constants.spotPaletteCream)),
                        width: form.isEditingLocation ? 1 : 0
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
                            form.isEditingDistance = isEditing
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
                                    .tag(metric)
                            }
                        }
                        .pickerStyle(MenuPickerStyle())
                        .foregroundColor(Color(UIColor(Constants.saintsXctfRed)))
                        .frame(width: 90, alignment: .leading)
                        .disabled(createLog.creating)
                    }
                    
                    if form.distanceStatus == InputStatus.warning {
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
                    
                    TextField("", text: $form.displayedTime) { isEditing in
                        form.isEditingTime = isEditing
                    }
                    .onReceive(Just(form.displayedTime), perform: { _ in
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
                    
                    if form.timeStatus == InputStatus.warning {
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
                        form.isEditingDescription = isEditing
                    }
                    .onReceive(Just(log.description), perform: { _ in
                        limitDescriptionText(descriptionTextLimit)
                    })
                    .autocapitalization(.none)
                    .disableAutocorrection(true)
                    .background(Color(UIColor.white))
                    .border(
                        Color(UIColor(Constants.spotPaletteCream)),
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
        .background(Color.init(UIColor(Constants.getFeelColor(Int(log.feel - 1)))))
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
        form.rawTime = form.displayedTime
        
        var filteredTime = ""
        for char in form.rawTime {
            if let intValue = char.wholeNumberValue {
                filteredTime += "\(intValue)"
            }
        }
        
        form.rawTime = filteredTime
    }
    
    func limitTimeText(_ upper: Int) {
        if form.rawTime.count > upper {
            form.rawTime = String(form.rawTime.prefix(upper))
        }
    }
    
    func setFormattedTimeText() {
        form.displayedTime = form.rawTime
            .enumerated()
            .map {
                ((form.rawTime.count - $0.offset) % 2 != 0) || $0.offset == 0 ?
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
        if form.rawTime.count == 0 && log.distance.count == 0 {
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
            }
        } else {
            ExerciseLogFormView(
                log: ExerciseLog(),
                meta: ExerciseLogMeta(isExisting: false),
                createLog: CreateExerciseLog(),
                form: ExerciseLogForm()
            )
        }
    }
}
