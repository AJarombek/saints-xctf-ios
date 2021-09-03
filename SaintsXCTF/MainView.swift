//
//  MainView.swift
//  SaintsXCTF
//
//  Created by Andrew Jarombek on 9/1/21.
//  Copyright © 2021 Andy Jarombek. All rights reserved.
//

import UIKit
import SwiftUI

struct MainView: UIViewControllerRepresentable {
    func makeUIViewController(context: Context) -> some UIViewController {
        guard let viewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(
            identifier: "showLogView"
        ) as? MainViewController else {
            fatalError("MainViewController not implemented in storyboard.")
        }

        return viewController
    }
    
    func updateUIViewController(_ uiViewController: UIViewControllerType, context: Context) {}
}
