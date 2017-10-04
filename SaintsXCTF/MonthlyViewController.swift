//
//  MonthlyViewController.swift
//  SaintsXCTF
//
//  Created by Andy Jarombek on 10/3/17.
//  Copyright © 2017 Andy Jarombek. All rights reserved.
//

import UIKit
import os.log

class MonthlyViewController: UIViewController {
    
    let logTag = OSLog(subsystem: "SaintsXCTF.App.MonthlyViewController",
                       category: "MonthlyViewController")
    
    @IBOutlet weak var runFilterButton: UIButton!
    @IBOutlet weak var bikeFilterButton: UIButton!
    @IBOutlet weak var swimFilterButton: UIButton!
    @IBOutlet weak var otherFilterButton: UIButton!
    @IBOutlet weak var monthLabel: UILabel!
    @IBOutlet weak var prevButton: UIButton!
    @IBOutlet weak var nextButton: UIButton!
    @IBOutlet weak var d1Label: UILabel!
    @IBOutlet weak var d2Label: UILabel!
    @IBOutlet weak var d3Label: UILabel!
    @IBOutlet weak var d4Label: UILabel!
    @IBOutlet weak var d5Label: UILabel!
    @IBOutlet weak var d6Label: UILabel!
    @IBOutlet weak var d7Label: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        os_log("MonthlyViewController Loaded.", log: logTag, type: .debug)
        
        // Set the navigation bar back button to a custom image
        navigationController?.navigationBar.backIndicatorImage = UIImage(named: "back")
        navigationController?.navigationBar.backIndicatorTransitionMaskImage = UIImage(named: "back")
        navigationController?.navigationBar.tintColor = UIColor(0x000000)
        navigationItem.title = "Monthly Calendar"
        
        navigationItem.backBarButtonItem = UIBarButtonItem(title: " ", style:
            UIBarButtonItemStyle.plain, target: nil, action: nil)
    }
}
