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
    
    // Get all the views for the week totals
    @IBOutlet weak var totalView01: UIView!
    @IBOutlet weak var totalView02: UIView!
    @IBOutlet weak var totalView03: UIView!
    @IBOutlet weak var totalView04: UIView!
    @IBOutlet weak var totalView05: UIView!
    @IBOutlet weak var totalView06: UIView!
    
    var user: User = User()
    var weekstart: String = ""
    var run = true, bike = false, swim = false, other = false
    
    var weekdays: [UILabel] = []
    var views: [UIView] = []
    var days: [UILabel] = []
    var miles: [UILabel] = []
    var totals: [UILabel] = []
    var totalviews: [UIView] = []
    var dayLabels: [String] = []
    
    var monthStart: Date = Date()
    
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
        
        // Create array for the calendar day labels
        weekdays = [d1Label, d2Label, d3Label, d4Label, d5Label, d6Label, d7Label]
        dayLabels = ["SUN", "MON", "TUE", "WED", "THU", "FRI", "SAT"]
        
        // Create array for the views in the calendar
        views = [view01, view02, view03, view04, view05, view06, view07, view08, view09, view10,
                    view11, view12, view13, view14, view15, view16, view17, view18, view19, view20,
                    view21, view22, view23, view24, view25, view26, view27, view28, view29, view30,
                    view31, view32, view33, view34, view35, view36, view37, view38, view39, view40,
                    view41, view42]
        
        // Create array for the days in the calendar
        days = [day01, day02, day03, day04, day05, day06, day07, day08, day09, day10,
                 day11, day12, day13, day14, day15, day16, day17, day18, day19, day20,
                 day21, day22, day23, day24, day25, day26, day27, day28, day29, day30,
                 day31, day32, day33, day34, day35, day36, day37, day38, day39, day40,
                 day41, day42]
        
        // Create array for the daily mileage in the calendar
        miles = [miles01, miles02, miles03, miles04, miles05, miles06, miles07, miles08, miles09, miles10,
                miles11, miles12, miles13, miles14, miles15, miles16, miles17, miles18, miles19, miles20,
                miles21, miles22, miles23, miles24, miles25, miles26, miles27, miles28, miles29, miles30,
                miles31, miles32, miles33, miles34, miles35, miles36, miles37, miles38, miles39, miles40,
                miles41, miles42]
        
        // Create array for the weekly total mileage in the calendar
        totals = [total01, total02, total03, total04, total05, total06]
        
        // Create array for the weekly total views in the calendar
        totalviews = [totalView01, totalView02, totalView03, totalView04, totalView05, totalView06]
        
        // Give each day a border
        for dayview in views {
            dayview.layer.borderWidth = 1
            dayview.layer.borderColor = UIColor(0xCCCCCC).cgColor
        }
        
        // Give each week total a border
        for totalview in totalviews {
            totalview.layer.borderWidth = 1
            totalview.layer.borderColor = UIColor(0xCCCCCC).cgColor
        }
        
        // Get the users weekstart to build the calendar
        weekstart = user.week_start!
        
        // Days have to be shifted if the weekstart is sunday
        if weekstart == "sunday" {
            
            for i in 0...6 {
                weekdays[i].text = dayLabels[i]
            }
        }
        
        // By default runs are shown in the monthly view
        filterRun()
        
        // Get the date for the start of the month
        let date = Date()
        let calendar = Calendar(identifier: .gregorian)
        
        var components = calendar.dateComponents([.year, .month, .day], from: date)
        components.day = 1
        
        monthStart = Calendar.current.date(from: components)!
        
        reset()
        filter(monthStart)
    }
    
    // Actions for when the filter buttons for the monthly view are clicked
    // First set the filter to the new boolean value
    // Second change the filter button accordingly
    // Last implement the filter to get appropriate range view data from the API
    
    // Run Filter
    @IBAction func filterRun(_ sender: UIButton) {
        run = !run
        filterRun()
        filter(monthStart)
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
        filter(monthStart)
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
        filter(monthStart)
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
        filter(monthStart)
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
    func filter(_ startMonth: Date) {
        
        let calendar = Calendar(identifier: .gregorian)
        var components = calendar.dateComponents([.year, .month, .day], from: startMonth)
        
        components.month = 1
        components.year = 0
        components.day = -1
        var endMonth = Calendar.current.date(byAdding: components, to: startMonth)
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MMMM YYYY"
        let title = dateFormatter.string(from: startMonth)
        
        monthLabel.text = title
    }
    
    // A function to reset the calendar to its original state
    func reset() {
        views.forEach {
            view -> Void in
            
            view.backgroundColor = UIColor(0xFFFFFF)
        }
        
        miles.forEach {
            mileLabel -> Void in
            
            mileLabel.text = ""
        }
    }
    
    @IBAction func prevMonth(_ sender: UIButton) {
        os_log("View Previous Month.", log: logTag, type: .debug)
        
        let calendar = Calendar(identifier: .gregorian)
        var components = calendar.dateComponents([.year, .month, .day], from: monthStart)
        
        components.year = 0
        components.day = 0
        components.month = -1
        monthStart = Calendar.current.date(byAdding: components, to: monthStart)!
        
        reset()
        filter(monthStart)
    }
    
    @IBAction func nextMonth(_ sender: UIButton) {
        os_log("View Next Month.", log: logTag, type: .debug)
        
        let calendar = Calendar(identifier: .gregorian)
        var components = calendar.dateComponents([.year, .month, .day], from: monthStart)
        
        components.year = 0
        components.day = 0
        components.month = 1
        monthStart = Calendar.current.date(byAdding: components, to: monthStart)!
        
        reset()
        filter(monthStart)
    }
    
}
