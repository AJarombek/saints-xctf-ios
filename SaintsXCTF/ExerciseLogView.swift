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
    @State private var distance: String = ""
    @State private var isEditingDistance: Bool = false
    @State private var metric: Metric = Metric.miles
    @State private var time: String = ""
    @State private var isEditingTime: Bool = false
    @State private var feel: Float = 6.0
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
    let timeTextLimit = 6
    let descriptionTextLimit = 1000
    
    var body: some View {
        VStack(alignment: .leading) {
            Text("Create Exercise Log")
                .font(.title)
                .foregroundColor(.black)
                .bold()
            
            VStack(alignment: .leading) {
                HStack {
                    Text(Constants.getFeelDescription(Int(feel) - 1))
                        .font(.subheadline)
                        .foregroundColor(Color(UIColor(0x737373)))
                }
                .frame(minWidth: 0, maxWidth: .infinity, alignment: .trailing)
                
                VStack(alignment: .leading) {
                    Text("Exercise Name*")
                        .font(.subheadline)
                        .foregroundColor(Color(UIColor(Constants.spotPaletteBrown)))
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
                    .border(
                        Color(UIColor(Constants.spotPaletteCream)),
                        width: isEditingName ? 1 : 0
                    )
                    .frame(minHeight: 30)
                }
                .padding(.top, 5.0)
                
                HStack {
                    VStack(alignment: .leading) {
                        Text("Location")
                            .font(.subheadline)
                            .foregroundColor(Color(UIColor(Constants.spotPaletteBrown)))
                            .bold()
                        
                        TextField("", text: $location) { isEditing in
                            self.isEditingLocation = isEditing
                        }
                        .onReceive(Just(location), perform: { _ in
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
                    }
                    VStack(alignment: .leading) {
                        Text("Date*")
                            .font(.subheadline)
                            .foregroundColor(Color(UIColor(Constants.spotPaletteBrown)))
                            .bold()
                            .padding(.leading, 8)
                        
                        DatePicker(
                            "",
                            selection: $date,
                            in: dateRange,
                            displayedComponents: [.date]
                        )
                        .frame(minWidth: 0, maxWidth: .infinity, minHeight: 30)
                        .accentColor(Color(UIColor(Constants.saintsXctfRed)))
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
                            selection: $exerciseType,
                            label: Text("\(exerciseType.rawValue.capitalized)")
                        ) {
                            ForEach(ExerciseType.allCases) { type in
                                Text(type.rawValue.capitalized)
                                    .tag(type)
                            }
                        }
                        .pickerStyle(MenuPickerStyle())
                        .foregroundColor(Color(UIColor(Constants.saintsXctfRed)))
                        .frame(width: 80, alignment: .leading)
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
                            TextField("", text: $distance) { isEditing in
                                self.isEditingDistance = isEditing
                            }
                            .autocapitalization(.none)
                            .disableAutocorrection(true)
                            .background(Color(UIColor.white))
                            .border(
                                Color(UIColor(Constants.spotPaletteCream)),
                                width: isEditingDistance ? 1 : 0
                            )
                            .frame(minWidth: 90, minHeight: 30)
                            
                            Picker(
                                selection: $metric,
                                label: Text("\(metric.rawValue.capitalized)")
                            ) {
                                ForEach(Metric.allCases) { metric in
                                    Text(metric.rawValue.capitalized)
                                        .tag(metric)
                                }
                            }
                            .pickerStyle(MenuPickerStyle())
                            .foregroundColor(Color(UIColor(Constants.saintsXctfRed)))
                            .frame(width: 90, alignment: .leading)
                        }
                    }
                    VStack(alignment: .leading) {
                        Text("Time")
                            .font(.subheadline)
                            .foregroundColor(Color(UIColor(Constants.spotPaletteBrown)))
                            .bold()
                        
                        TextField("", text: $time) { isEditing in
                            self.isEditingTime = isEditing
                        }
                        .onReceive(Just(time), perform: { _ in
                            limitTimeText(timeTextLimit)
                            filterTimeText()
                        })
                        .autocapitalization(.none)
                        .disableAutocorrection(true)
                        .background(Color(UIColor.white))
                        .border(
                            Color(UIColor(Constants.spotPaletteCream)),
                            width: isEditingTime ? 1 : 0
                        )
                        .frame(minHeight: 30)
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
                            value: $feel,
                            in: 1...10,
                            step: 1
                        ) {
                            Text("Title")
                        }
                        .accentColor(Color(UIColor(Constants.saintsXctfRed)))
                    }
                }
                .padding(.top, 5.0)
                
                HStack {
                    VStack(alignment: .leading) {
                        Text("Description")
                            .font(.subheadline)
                            .foregroundColor(Color(UIColor(Constants.spotPaletteBrown)))
                            .bold()
                        
                        TextField("", text: $description) { isEditing in
                            self.isEditingDescription = isEditing
                        }
                        .onReceive(Just(description), perform: { _ in
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
                    }
                }
                .padding(.top, 5.0)
                
                HStack(spacing: 20) {
                    Button(action: {
                        print("Create")
                    }) {
                        Text("Create")
                            .foregroundColor(Color(UIColor(Constants.saintsXctfRed)))
                    }
                    Button(action: {
                        print("Cancel")
                    }) {
                        Text("Cancel")
                            .foregroundColor(Color(UIColor(Constants.darkGray)))
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
            .background(Color.init(UIColor(Constants.getFeelColor(Int(feel - 1)))))
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
    
    func limitTimeText(_ upper: Int) {
        if time.count > upper {
            time = String(time.prefix(upper))
        }
    }
    
    func filterTimeText() {
        
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
