//
//  WeeklyViewController.swift
//  SaintsXCTF
//
//  Created by Andy Jarombek on 10/7/17.
//  Copyright © 2017 Andy Jarombek. All rights reserved.
//

import UIKit
import os.log
import Charts

class WeeklyViewController: UIViewController {
    
    let logTag = OSLog(subsystem: "SaintsXCTF.App.WeeklyViewController",
                       category: "WeeklyViewController")
    
    @IBOutlet weak var runFilterButton: UIButton!
    @IBOutlet weak var bikeFilterButton: UIButton!
    @IBOutlet weak var swimFilterButton: UIButton!
    @IBOutlet weak var otherFilterButton: UIButton!
    
    var user: User = User()
    var weekstart: String = ""
    var weekstartOffset: Int = 0
    var run = true, bike = false, swim = false, other = false
    var weekTotals: [Double] = [0,0,0,0,0,0,0,0,0,0]
    
    var start = ""
    var end = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        os_log("WeeklyViewController Loaded.", log: logTag, type: .debug)
        
        // Set the navigation bar back button to a custom image
        navigationController?.navigationBar.backIndicatorImage = UIImage(named: "back")
        navigationController?.navigationBar.backIndicatorTransitionMaskImage = UIImage(named: "back")
        navigationController?.navigationBar.tintColor = UIColor(0x000000)
        navigationItem.title = "Weekly Graph"
        
        navigationItem.backBarButtonItem = UIBarButtonItem(title: " ", style:
            UIBarButtonItemStyle.plain, target: nil, action: nil)
        
        // Get the users weekstart to build the calendar
        weekstart = user.week_start!
        
        // Setup depending on when the user has their weeks set to start
        if weekstart == "sunday" {
            weekstartOffset = 0
        } else {
            weekstartOffset = 1
        }
        
        // By default runs are shown in the weekly graph
        filterRun()
        
        // Interval to add a day to a date
        let day: TimeInterval = 60 * 60 * 24
        
        // Initialize the date range for the graph
        let calendar = Calendar(identifier: .gregorian)
        
        // Get the day of the week
        let date: Date = Date()
        var weekdayComponent = calendar.dateComponents([.weekday], from: date)
        let weekday = weekdayComponent.weekday!
        
        // Set the end date as the end of this week and start date as 10 weeks previous
        var endDate: Date = Calendar.current.date(byAdding: .day, value: weekstartOffset - weekday, to: date)!
        endDate.addTimeInterval(day * 7)
        var startDate: Date = endDate
        startDate.addTimeInterval(day * -69)
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        
        end = dateFormatter.string(from: endDate)
        start = dateFormatter.string(from: startDate)
        print(start)
        print(end)
        
        // Initialize the graph itself
        initialize()
        populate()
    }
    
    // Actions for when the filter buttons for the monthly view are clicked
    // First set the filter to the new boolean value
    // Second change the filter button accordingly
    // Last implement the filter to get appropriate range view data from the API
    
    // Run Filter
    @IBAction func filterRun(_ sender: UIButton) {
        run = !run
        filterRun()
        populate()
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
        populate()
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
        populate()
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
        populate()
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
    
    // Function to Initialize the creation of the weekly graph
    func initialize() {
        
    }
    
    // Function to populate the weekly graph based on the filter
    func populate() {
        
        let typeFilter = getTypeFilter()
    }
    
    // Return the type filter to send to the rangeview API endpoint
    func getTypeFilter() -> String {
        let r = run ? "r" : ""
        let b = bike ? "b" : ""
        let s = swim ? "s" : ""
        let o = other ? "o" : ""
        return "\(r)\(b)\(s)\(o)"
    }
}
