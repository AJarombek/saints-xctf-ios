//
//  ExistingLog.swift
//  SaintsXCTF
//
//  Created by Andrew Jarombek on 9/11/21.
//  Copyright © 2021 Andy Jarombek. All rights reserved.
//

import SwiftUI

class ExistingLog: ObservableObject {
    @Published var log: Log? = nil
}
