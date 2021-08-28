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
    @State private var name: String = ""
    @State private var isEditingName: Bool = false
    @State private var location: String = ""
    @State private var isEditingLocation: Bool = false
    @State private var date: Date = Date()
    @State private var isEditingDate: Bool = false
    @State private var exerciseType: ExerciseType = ExerciseType.run
    @State private var description: String = ""
    @State private var isEditingDescription: Bool = false
    
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
    let descriptionTextLimit = 1000
    
    var body: some View {
        VStack(alignment: .leading) {
            Text("Create Exercise Log")
                .font(.title)
                .foregroundColor(.black)
                .bold()
            VStack(alignment: .leading) {
                HStack {
                    Text("Average")
                        .font(.subheadline)
                        .foregroundColor(Color(UIColor(0x737373)))
                }
                .frame(minWidth: 0, maxWidth: .infinity, alignment: .trailing)
                VStack(alignment: .leading) {
                    Text("Exercise Name*")
                        .font(.subheadline)
                        .foregroundColor(Color(UIColor(0xA96A5B)))
                        .bold()
                    TextField("", text: $name) { isEditing in
                        self.isEditingName = isEditing
                    }
                    .onReceive(Just(name), perform: { _ in
                        limitNameText(nameTextLimit)
                    })
                    .autocapitalization(.none)
                    .disableAutocorrection(true)
                    .background(Color(UIColor.white))
                    .frame(minHeight: 30)
                }
                .padding(.top, 5.0)
                HStack {
                    VStack(alignment: .leading) {
                        Text("Location")
                            .font(.subheadline)
                            .foregroundColor(Color(UIColor(0xA96A5B)))
                            .bold()
                        TextField("", text: $location) { isEditing in
                            self.isEditingLocation = isEditing
                        }
                        .autocapitalization(.none)
                        .disableAutocorrection(true)
                        .background(Color(UIColor.white))
                        .frame(minHeight: 30)
                    }
                    VStack(alignment: .leading) {
                        Text("Date*")
                            .font(.subheadline)
                            .foregroundColor(Color(UIColor(0xA96A5B)))
                            .bold()
                            .padding(.leading, 8)
                        DatePicker(
                            "",
                            selection: $date,
                            in: dateRange,
                            displayedComponents: [.date]
                        )
                        .frame(minWidth: 0, maxWidth: .infinity, minHeight: 30)
                    }
                    .frame(minWidth: 0, maxWidth: 130)
                }
                .padding(.top, 5.0)
                .frame(minWidth: 0, maxWidth: .infinity, alignment: .leading)
                HStack {
                    VStack {
                        Text("Exercise Type")
                            .font(.subheadline)
                            .foregroundColor(Color(UIColor(0xA96A5B)))
                            .bold()
                        Picker(selection: $exerciseType, label: Text("Exercise Type")) {
                            ForEach(ExerciseType.allCases) { type in
                                Text(type.rawValue.capitalized)
                            }
                        }
                        .pickerStyle(MenuPickerStyle())
                    }
                }
                .padding(.top, 5.0)
                HStack {
                    Text("Distance")
                        .font(.subheadline)
                        .foregroundColor(Color(UIColor(0xA96A5B)))
                        .bold()
                    Text("Time")
                        .font(.subheadline)
                        .foregroundColor(Color(UIColor(0xA96A5B)))
                        .bold()
                }
                .padding(.top, 5.0)
                HStack {
                    Text("Feel")
                        .font(.subheadline)
                        .foregroundColor(Color(UIColor(0xA96A5B)))
                        .bold()
                }
                .padding(.top, 5.0)
                HStack {
                    Text("Description")
                        .font(.subheadline)
                        .foregroundColor(Color(UIColor(0xA96A5B)))
                        .bold()
                }
                .padding(.top, 5.0)
                HStack(spacing: 20) {
                    Button(action: {
                        print("Create")
                    }) {
                        Text("Create")
                    }
                    Button(action: {
                        print("Cancel")
                    }) {
                        Text("Cancel")
                            .foregroundColor(Color(UIColor(0x990000)))
                    }
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
            .background(Color.init(UIColor(0xF8F8F8)))
            .cornerRadius(5)
            .textFieldStyle(RoundedBorderTextFieldStyle())
        }
        .padding()
    }
    
    func limitNameText(_ upper: Int) {
        if name.count > upper {
            name = String(name.prefix(upper))
        }
    }
    
    func limitLocationText(_ upper: Int) {
        if location.count > upper {
            location = String(location.prefix(upper))
        }
    }
    
    func limitDescriptionText(_ upper: Int) {
        if description.count > upper {
            description = String(description.prefix(upper))
        }
    }
}

struct ExerciseLogView_Previews: PreviewProvider {
    static var previews: some View {
        ForEach(["iPhone 12 Pro", "iPhone 12"], id: \.self) { deviceName in
            ExerciseLogView()
                .previewDevice(PreviewDevice(rawValue: deviceName))
        }
    }
}
