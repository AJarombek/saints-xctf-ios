//
//  EditExerciseLogViewController.swift
//  SaintsXCTF
//
//  Created by Andrew Jarombek on 9/11/21.
//  Copyright © 2021 Andy Jarombek. All rights reserved.
//

import UIKit
import SwiftUI

class EditExerciseLogViewController: UIViewController {
    @IBOutlet weak var container: UIView!
    
    var log: Log? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let existingLog = ExistingLog()
        existingLog.log = log
        
        let childView = UIHostingController(rootView: EditExerciseLogView().environmentObject(existingLog))
        addChild(childView)
        childView.view.frame = container.bounds
        container.addSubview(childView.view)
        childView.didMove(toParent: self)
    }
}
