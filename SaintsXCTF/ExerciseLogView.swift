//
//  ExerciseLogView.swift
//  SaintsXCTF
//
//  Created by Andrew Jarombek on 8/25/21.
//  Copyright © 2021 Andy Jarombek. All rights reserved.
//

import SwiftUI

struct ExerciseLogView: View {
    var body: some View {
        VStack(alignment: .leading) {
            Text("Create Exercise Log")
                .font(/*@START_MENU_TOKEN@*/.title/*@END_MENU_TOKEN@*/)
                .foregroundColor(.black)
            VStack {
                Text("Exercise Name*")
                    .font(.subheadline)
                HStack {
                    Text("Location")
                        .font(.subheadline)
                    Spacer()
                    Text("Date*")
                        .font(.subheadline)
                }
            }
            .padding()
            .overlay(
                Rectangle()
                    .stroke(Color.gray, lineWidth: 0.25)
                    .shadow(radius: 2)
            )
            .background(Color.init(UIColor(0xF8F8F8)))
        }
        .padding()
    }
}

struct ExerciseLogView_Previews: PreviewProvider {
    static var previews: some View {
        ExerciseLogView()
    }
}
