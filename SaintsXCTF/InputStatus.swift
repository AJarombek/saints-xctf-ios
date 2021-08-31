//
//  InputStatus.swift
//  SaintsXCTF
//
//  Created by Andrew Jarombek on 8/29/21.
//  Copyright © 2021 Andy Jarombek. All rights reserved.
//

import Foundation

enum InputStatus: String, CaseIterable, Identifiable {
    case none
    case success
    case warning
    case failure
    case initial
    
    var id: String {
        self.rawValue
    }
}
