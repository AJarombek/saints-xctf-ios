//
//  NewLog.swift
//  SaintsXCTF
//
//  Created by Andrew Jarombek on 9/2/21.
//  Copyright © 2021 Andy Jarombek. All rights reserved.
//

import SwiftUI

class NewLog: ObservableObject {
    @Published var name = ""
    @Published var location = ""
    @Published var date = Date()
    @Published var distance = ""
    @Published var metric = Metric.miles
    @Published var time = ""
    @Published var feel = 6.0
    @Published var description = ""
}
