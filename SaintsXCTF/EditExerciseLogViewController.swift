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
        
        let exerciseLog = ExerciseLog()
        
        if let logObject = log {
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "yyyy-MM-dd"
            let dateObject = dateFormatter.date(from: logObject.date) ?? Date()
            
            exerciseLog.id = logObject.log_id
            exerciseLog.name = logObject.name
            exerciseLog.location = logObject.location ?? ""
            exerciseLog.date = dateObject
            exerciseLog.exerciseType = ExerciseType(rawValue: logObject.type!) ?? ExerciseType.run
            exerciseLog.distance = logObject.distance != nil ? String(logObject.distance!) : ""
            exerciseLog.metric = Metric(rawValue: logObject.metric!) ?? Metric.miles
            exerciseLog.time = logObject.time ?? ""
            exerciseLog.feel = Double(logObject.feel)
            exerciseLog.description = logObject.log_description ?? ""
        }
        
        let existingLog = ExistingLog(log ?? Log())
        
        let childView = UIHostingController(rootView: EditExerciseLogView(log: exerciseLog).environmentObject(existingLog))
        addChild(childView)
        childView.view.frame = container.bounds
        container.addSubview(childView.view)
        childView.didMove(toParent: self)
    }
}
