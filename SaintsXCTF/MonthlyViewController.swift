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
    
    // Calendar day labels
    @IBOutlet weak var d1Label: UILabel!
    @IBOutlet weak var d2Label: UILabel!
    @IBOutlet weak var d3Label: UILabel!
    @IBOutlet weak var d4Label: UILabel!
    @IBOutlet weak var d5Label: UILabel!
    @IBOutlet weak var d6Label: UILabel!
    @IBOutlet weak var d7Label: UILabel!
    
    // Calendar first row views, dates, and miles
    @IBOutlet weak var view01: UIView!
    @IBOutlet weak var day01: UILabel!
    @IBOutlet weak var miles01: UILabel!
    @IBOutlet weak var view02: UIView!
    @IBOutlet weak var day02: UILabel!
    @IBOutlet weak var miles02: UILabel!
    @IBOutlet weak var view03: UIView!
    @IBOutlet weak var day03: UILabel!
    @IBOutlet weak var miles03: UILabel!
    @IBOutlet weak var view04: UIView!
    @IBOutlet weak var day04: UILabel!
    @IBOutlet weak var miles04: UILabel!
    @IBOutlet weak var view05: UIView!
    @IBOutlet weak var day05: UILabel!
    @IBOutlet weak var miles05: UILabel!
    @IBOutlet weak var view06: UIView!
    @IBOutlet weak var day06: UILabel!
    @IBOutlet weak var miles06: UILabel!
    @IBOutlet weak var view07: UIView!
    @IBOutlet weak var day07: UILabel!
    @IBOutlet weak var miles07: UILabel!
    @IBOutlet weak var total01: UILabel!
    
    // Calendar second row views, dates, and miles
    @IBOutlet weak var view08: UIView!
    @IBOutlet weak var day08: UILabel!
    @IBOutlet weak var miles08: UILabel!
    @IBOutlet weak var view09: UIView!
    @IBOutlet weak var day09: UILabel!
    @IBOutlet weak var miles09: UILabel!
    @IBOutlet weak var view10: UIView!
    @IBOutlet weak var day10: UILabel!
    @IBOutlet weak var miles10: UILabel!
    @IBOutlet weak var view11: UIView!
    @IBOutlet weak var day11: UILabel!
    @IBOutlet weak var miles11: UILabel!
    @IBOutlet weak var view12: UIView!
    @IBOutlet weak var day12: UILabel!
    @IBOutlet weak var miles12: UILabel!
    @IBOutlet weak var view13: UIView!
    @IBOutlet weak var day13: UILabel!
    @IBOutlet weak var miles13: UILabel!
    @IBOutlet weak var view14: UIView!
    @IBOutlet weak var day14: UILabel!
    @IBOutlet weak var miles14: UILabel!
    @IBOutlet weak var total02: UILabel!
    
    // Calendar third row views, dates, and miles
    @IBOutlet weak var view15: UIView!
    @IBOutlet weak var day15: UILabel!
    @IBOutlet weak var miles15: UILabel!
    @IBOutlet weak var view16: UIView!
    @IBOutlet weak var day16: UILabel!
    @IBOutlet weak var miles16: UILabel!
    @IBOutlet weak var view17: UIView!
    @IBOutlet weak var day17: UILabel!
    @IBOutlet weak var miles17: UILabel!
    @IBOutlet weak var view18: UIView!
    @IBOutlet weak var day18: UILabel!
    @IBOutlet weak var miles18: UILabel!
    @IBOutlet weak var view19: UIView!
    @IBOutlet weak var day19: UILabel!
    @IBOutlet weak var miles19: UILabel!
    @IBOutlet weak var view20: UIView!
    @IBOutlet weak var day20: UILabel!
    @IBOutlet weak var miles20: UILabel!
    @IBOutlet weak var view21: UIView!
    @IBOutlet weak var day21: UILabel!
    @IBOutlet weak var miles21: UILabel!
    @IBOutlet weak var total03: UILabel!
    
    // Calendar fourth row views, dates, and miles
    @IBOutlet weak var view22: UIView!
    @IBOutlet weak var day22: UILabel!
    @IBOutlet weak var miles22: UILabel!
    @IBOutlet weak var view23: UIView!
    @IBOutlet weak var day23: UILabel!
    @IBOutlet weak var miles23: UILabel!
    @IBOutlet weak var view24: UIView!
    @IBOutlet weak var day24: UILabel!
    @IBOutlet weak var miles24: UILabel!
    @IBOutlet weak var view25: UIView!
    @IBOutlet weak var day25: UILabel!
    @IBOutlet weak var miles25: UILabel!
    @IBOutlet weak var view26: UIView!
    @IBOutlet weak var day26: UILabel!
    @IBOutlet weak var miles26: UILabel!
    @IBOutlet weak var view27: UIView!
    @IBOutlet weak var day27: UILabel!
    @IBOutlet weak var miles27: UILabel!
    @IBOutlet weak var view28: UIView!
    @IBOutlet weak var day28: UILabel!
    @IBOutlet weak var miles28: UILabel!
    @IBOutlet weak var total04: UILabel!
    
    // Calendar fifth row views, dates, and miles
    @IBOutlet weak var view29: UIView!
    @IBOutlet weak var day29: UILabel!
    @IBOutlet weak var miles29: UILabel!
    @IBOutlet weak var view30: UIView!
    @IBOutlet weak var day30: UILabel!
    @IBOutlet weak var miles30: UILabel!
    @IBOutlet weak var view31: UIView!
    @IBOutlet weak var day31: UILabel!
    @IBOutlet weak var miles31: UILabel!
    @IBOutlet weak var view32: UIView!
    @IBOutlet weak var day32: UILabel!
    @IBOutlet weak var miles32: UILabel!
    @IBOutlet weak var view33: UIView!
    @IBOutlet weak var day33: UILabel!
    @IBOutlet weak var miles33: UILabel!
    @IBOutlet weak var view34: UIView!
    @IBOutlet weak var day34: UILabel!
    @IBOutlet weak var miles34: UILabel!
    @IBOutlet weak var view35: UIView!
    @IBOutlet weak var day35: UILabel!
    @IBOutlet weak var miles35: UILabel!
    @IBOutlet weak var total05: UILabel!
    
    // Calendar sixth row views, dates, and miles
    @IBOutlet weak var view36: UIView!
    @IBOutlet weak var day36: UILabel!
    @IBOutlet weak var miles36: UILabel!
    @IBOutlet weak var view37: UIView!
    @IBOutlet weak var day37: UILabel!
    @IBOutlet weak var miles37: UILabel!
    @IBOutlet weak var view38: UIView!
    @IBOutlet weak var day38: UILabel!
    @IBOutlet weak var miles38: UILabel!
    @IBOutlet weak var view39: UIView!
    @IBOutlet weak var day39: UILabel!
    @IBOutlet weak var miles39: UILabel!
    @IBOutlet weak var view40: UIView!
    @IBOutlet weak var day40: UILabel!
    @IBOutlet weak var miles40: UILabel!
    @IBOutlet weak var view41: UIView!
    @IBOutlet weak var day41: UILabel!
    @IBOutlet weak var miles41: UILabel!
    @IBOutlet weak var view42: UIView!
    @IBOutlet weak var day42: UILabel!
    @IBOutlet weak var miles42: UILabel!
    @IBOutlet weak var total06: UILabel!
    
    var user: User = User()
    var run = true, bike = false, swim = false, other = false
    
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
        
        // Set the margins for the filter stack view
        //filterStackView.layoutMargins = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 1)
        //filterStackView.isLayoutMarginsRelativeArrangement = true
        
        // Add a border to the right side of the filter buttons
        let runRightBorder = CALayer()
        runRightBorder.frame = CGRect.init(x: runFilterButton.frame.width + 1, y: 0,
                                               width: 1, height: runFilterButton.frame.height)
        runRightBorder.backgroundColor = UIColor(0xBBBBBB).cgColor
        
        runFilterButton.layer.addSublayer(runRightBorder)
        
        // By default runs are shown in the monthly view
        filterRun()
    }
    
    // Actions for when the filter buttons for the monthly view are clicked
    // First set the filter to the new boolean value
    // Second change the filter button accordingly
    // Last implement the filter to get appropriate range view data from the API
    
    // Run Filter
    @IBAction func filterRun(_ sender: UIButton) {
        run = !run
        filterRun()
        filter()
    }
    
    func filterRun() {
        if run {
            runFilterButton.backgroundColor = UIColor(0x990000)
            runFilterButton.setTitleColor(UIColor(0xFFFFFF), for: .normal)
        } else {
            runFilterButton.backgroundColor = UIColor(0xEEEEEE)
            runFilterButton.setTitleColor(UIColor(0x000000), for: .normal)
        }
    }
    
    // Bike Filter
    @IBAction func filterBike(_ sender: UIButton) {
        bike = !bike
        filterBike()
        filter()
    }
    
    func filterBike() {
        if bike {
            bikeFilterButton.backgroundColor = UIColor(0x990000)
            bikeFilterButton.setTitleColor(UIColor(0xFFFFFF), for: .normal)
        } else {
            bikeFilterButton.backgroundColor = UIColor(0xEEEEEE)
            bikeFilterButton.setTitleColor(UIColor(0x000000), for: .normal)
        }
    }
    
    // Swim Filter
    @IBAction func filterSwim(_ sender: UIButton) {
        swim = !swim
        filterSwim()
        filter()
    }
    
    func filterSwim() {
        if swim {
            swimFilterButton.backgroundColor = UIColor(0x990000)
            swimFilterButton.setTitleColor(UIColor(0xFFFFFF), for: .normal)
        } else {
            swimFilterButton.backgroundColor = UIColor(0xEEEEEE)
            swimFilterButton.setTitleColor(UIColor(0x000000), for: .normal)
        }
    }
    
    // Other Filter
    @IBAction func filterOther(_ sender: UIButton) {
        other = !other
        filterOther()
        filter()
    }
    
    func filterOther() {
        if other {
            otherFilterButton.backgroundColor = UIColor(0x990000)
            otherFilterButton.setTitleColor(UIColor(0xFFFFFF), for: .normal)
        } else {
            otherFilterButton.backgroundColor = UIColor(0xEEEEEE)
            otherFilterButton.setTitleColor(UIColor(0x000000), for: .normal)
        }
    }
    
    // A general filter function for the monthly calendar
    func filter() {
        
    }
    
    @IBAction func prevMonth(_ sender: UIButton) {
        os_log("View Previous Month.", log: logTag, type: .debug)
    }
    
    @IBAction func nextMonth(_ sender: UIButton) {
        os_log("View Next Month.", log: logTag, type: .debug)
    }
    
}
