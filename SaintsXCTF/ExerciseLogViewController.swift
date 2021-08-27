//
//  ExerciseLogViewController.swift
//  SaintsXCTF
//
//  Created by Andrew Jarombek on 8/26/21.
//  Copyright © 2021 Andy Jarombek. All rights reserved.
//

import UIKit
import SwiftUI

class ExerciseLogViewController: UIViewController {
    @IBOutlet weak var container: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let childView = UIHostingController(rootView: ExerciseLogView())
        addChild(childView)
        childView.view.frame = container.bounds
        container.addSubview(childView.view)
        childView.didMove(toParent: self)
    }
}
