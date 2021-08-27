//
//  ExerciseLogView.swift
//  SaintsXCTF
//
//  Created by Andrew Jarombek on 8/25/21.
//  Copyright © 2021 Andy Jarombek. All rights reserved.
//

import SwiftUI

struct ExerciseLogView: View {
    @State private var name: String = ""
    @State private var isEditingName: Bool = false
    
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
                    .autocapitalization(.none)
                    .disableAutocorrection(true)
                    .background(Color(UIColor.white))
                    .frame(minHeight: 30)
                }
                .padding(.top, 5.0)
                HStack {
                    VStack {
                        Text("Location")
                            .font(.subheadline)
                            .foregroundColor(Color(UIColor(0xA96A5B)))
                            .bold()
                    }
                    VStack {
                        Text("Date*")
                            .font(.subheadline)
                            .foregroundColor(Color(UIColor(0xA96A5B)))
                            .bold()
                    }
                }
                .padding(.top, 5.0)
                .frame(minWidth: 0, maxWidth: .infinity, alignment: .leading)
                HStack {
                    Text("Exercise Type")
                        .font(.subheadline)
                        .foregroundColor(Color(UIColor(0xA96A5B)))
                        .bold()
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
            .textFieldStyle(RoundedBorderTextFieldStyle())
        }
        .padding()
    }
}

struct ExerciseLogView_Previews: PreviewProvider {
    static var previews: some View {
        ExerciseLogView()
    }
}
