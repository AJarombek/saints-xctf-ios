//
//  MonthlyViewController.swift
//  SaintsXCTF
//
//  Created by Andy Jarombek on 10/3/17.
//  Copyright © 2017 Andy Jarombek. All rights reserved.
//

import UIKit
import os.log

/**
 Controller for a monthly calendar disaplying an exercise summary for each day.
 - Important:
 ## Extends the following class:
 - UIViewController: provides behavior shared between all classes that manage a view
 */
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
    var weekstartOffset: Int = 0
    var run = true, bike = false, swim = false, other = false
    
    var weekdays: [UILabel] = []
    var views: [UIView] = []
    var days: [UILabel] = []
    var miles: [UILabel] = []
    var totals: [UILabel] = []
    var totalviews: [UIView] = []
    var dayLabels: [String] = []
    
    var monthStart: Date = Date()
    
    /**
     Invoked when the MonthlyViewController loads
     */
    override func viewDidLoad() {
        super.viewDidLoad()
        os_log("MonthlyViewController Loaded.", log: logTag, type: .debug)
        
        // Set the navigation bar back button to a custom image
        navigationController?.navigationBar.backIndicatorImage = UIImage(named: "back")
        navigationController?.navigationBar.backIndicatorTransitionMaskImage = UIImage(named: "back")
        navigationController?.navigationBar.tintColor = UIColor(0xFFFFFF)
        navigationItem.title = "Monthly Calendar"
        
        navigationItem.backBarButtonItem = UIBarButtonItem(title: " ", style:
            UIBarButtonItem.Style.plain, target: nil, action: nil)
        
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
        
        // Setup depending on when the user has their weeks set to start
        if weekstart == "sunday" {
            weekstartOffset = 1
            
            // Days have to be shifted if the weekstart is sunday
            for i in 0...6 {
                weekdays[i].text = dayLabels[i]
            }
        } else {
            weekstartOffset = 2
        }
        
        // By default runs are shown in the monthly view
        filterRun()
        
        // Get the date for the start of the month
        let date = Date()
        var calendar = Calendar(identifier: .gregorian)
        calendar.timeZone = TimeZone(secondsFromGMT: 0)!
        
        var components = calendar.dateComponents([.year, .month, .day], from: date)
        components.day = 1
        
        monthStart = calendar.date(from: components)!
        os_log("Month Start: %@", log: logTag, type: .debug, monthStart.description)
        
        reset()
        filter(monthStart)
    }
    
    // Actions for when the filter buttons for the monthly view are clicked
    // First set the filter to the new boolean value
    // Second change the filter button accordingly
    // Last implement the filter to get appropriate range view data from the API
    
    /**
     Run Filter is invoked when the 'Run' button is clicked
     - parameters:
     - sender: the 'Run' button that was clicked
     */
    @IBAction func filterRun(_ sender: UIButton) {
        run = !run
        filterRun()
        reset()
        filter(monthStart)
    }
    
    /**
     Set the background color of the Run button based on whether its active
     */
    func filterRun() {
        if run {
            runFilterButton.backgroundColor = UIColor(0x990000)
            runFilterButton.setTitleColor(UIColor(0xFFFFFF), for: .normal)
        } else {
            runFilterButton.backgroundColor = UIColor(0xEEEEEE)
            runFilterButton.setTitleColor(UIColor(0x000000), for: .normal)
        }
    }
    
    /**
     Bike Filter is invoked when the 'Bike' button is clicked
     - parameters:
     - sender: the 'Bike' button that was clicked
     */
    @IBAction func filterBike(_ sender: UIButton) {
        bike = !bike
        filterBike()
        reset()
        filter(monthStart)
    }
    
    /**
     Set the background color of the Bike button based on whether its active
     */
    func filterBike() {
        if bike {
            bikeFilterButton.backgroundColor = UIColor(0x990000)
            bikeFilterButton.setTitleColor(UIColor(0xFFFFFF), for: .normal)
        } else {
            bikeFilterButton.backgroundColor = UIColor(0xEEEEEE)
            bikeFilterButton.setTitleColor(UIColor(0x000000), for: .normal)
        }
    }
    
    /**
     Swim Filter is invoked when the 'Swim' button is clicked
     - parameters:
     - sender: the 'Swim' button that was clicked
     */
    @IBAction func filterSwim(_ sender: UIButton) {
        swim = !swim
        filterSwim()
        reset()
        filter(monthStart)
    }
    
    /**
     Set the background color of the Swim button based on whether its active
     */
    func filterSwim() {
        if swim {
            swimFilterButton.backgroundColor = UIColor(0x990000)
            swimFilterButton.setTitleColor(UIColor(0xFFFFFF), for: .normal)
        } else {
            swimFilterButton.backgroundColor = UIColor(0xEEEEEE)
            swimFilterButton.setTitleColor(UIColor(0x000000), for: .normal)
        }
    }
    
    /**
     Other Filter is invoked when the 'Other' button is clicked
     - parameters:
     - sender: the 'Other' button that was clicked
     */
    @IBAction func filterOther(_ sender: UIButton) {
        other = !other
        filterOther()
        reset()
        filter(monthStart)
    }
    
    /**
     Set the background color of the Other button based on whether its active
     */
    func filterOther() {
        if other {
            otherFilterButton.backgroundColor = UIColor(0x990000)
            otherFilterButton.setTitleColor(UIColor(0xFFFFFF), for: .normal)
        } else {
            otherFilterButton.backgroundColor = UIColor(0xEEEEEE)
            otherFilterButton.setTitleColor(UIColor(0x000000), for: .normal)
        }
    }
    
    /**
     A general filter function for the monthly calendar.  Sets the initial background colors for
     each day and numerically labels each calendar day.
     - parameters:
     - startMonth: the first day of the current month in the monthly view
     */
    func filter(_ startMonth: Date) {
        
        // Get the type filter to send to the API
        let typeFilter = getTypeFilter()
        
        let start = startMonth
        
        var calendar = Calendar(identifier: .gregorian)
        calendar.timeZone = TimeZone(secondsFromGMT: 0)!
        
        // Intervals to add and subtract a day from a date
        let prevday: TimeInterval = -60 * 60 * 24
        let day: TimeInterval = 60 * 60 * 24
        
        // First set up the date formatter for the month and year label
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MMMM YYYY"
        dateFormatter.timeZone = TimeZone(secondsFromGMT: 0)

        let title = dateFormatter.string(from: startMonth)
        
        monthLabel.text = title
        
        // Get the day of the week that the first of the month is on
        let weekdayComponent = calendar.dateComponents([.weekday], from: startMonth)
        let weekday = weekdayComponent.weekday!
        
        // First day of the calendar
        var firstDay: Date = calendar.date(
            byAdding: .day,
            value: weekstartOffset - weekday,
            to: start
        )!
        
        let dayComponent = calendar.dateComponents([.day], from: firstDay)
        let dayNum: Int = dayComponent.day!
        
        // If the first day is between 2 and 4, we want to subtract a week from the first day
        if dayNum < 5 && dayNum > 1 {
            firstDay.addTimeInterval(prevday * 7)
        }
        
        // Get a copy of firstDay for later use - we will be modifying firstDay
        let fd = firstDay
        
        // Last day of the calendar - add 41 days to the first day in the calendar
        let lastDay: Date = calendar.date(byAdding: .day, value: 41, to: firstDay)!
        
        // Keep track of the previous day when iterating through the calendar days
        var prevDayNum = -1
        
        // Format the first and last days of the month - used in an API request to populate the calendar
        dateFormatter.dateFormat = "yyyy-MM-dd"
        let first = dateFormatter.string(from: firstDay)
        let last = dateFormatter.string(from: lastDay)
        
        os_log("Start Date: %@", log: logTag, type: .debug, first)
        os_log("End Date: %@", log: logTag, type: .debug, last)
        
        // Go through each cell in the calendar
        for i in 0...41 {
            let dayComponents = calendar.dateComponents([.day], from: firstDay)
            var dayNum = dayComponents.day!
            
            // If this day's calendar number equals yesterday, a common bug occurred.  Fix it.
            if (dayNum == prevDayNum) {
                os_log("Duplicate day bug occurred on day: %@", log: logTag, type: .debug, "\(dayNum)")
                dayNum += 1
                firstDay.addTimeInterval(day)
            }
            
            days[i].text = "\(dayNum)"
            
            // Check to see whether the cell is a part of this month or next month for background
            // coloring purposes
            if (i < 8 && dayNum > 10) || (i > 30 && dayNum < 15) {
                // Previous or next month
                views[i].backgroundColor = UIColor(0xEEEEEE)
                
            } else {
                // Current month
                views[i].backgroundColor = UIColor(0xFFFFFF)
            }
            
            firstDay.addTimeInterval(day)
            prevDayNum = dayNum
        }
        
        // Get the range view from the API for this month and user
        APIClient.rangeViewGetRequest(
            withParamType: "user",
            sortParam: user.username!,
            filter: typeFilter,
            start: first,
            end: last,
            fromController: self
        ) {
            rangeView -> Void in
            
            var weekTotals: [Double] = [0,0,0,0,0,0]
            
            rangeView.forEach {
                activity -> Void in
                
                dateFormatter.dateFormat = "E, dd MMM yyyy HH:mm:ss zzz"
                
                let activityDateString: String = activity.date!
                let activityDate: Date = dateFormatter.date(from: activityDateString)!
                
                let difComponent = Calendar.current.dateComponents([.day], from: fd, to: activityDate)
                let day = difComponent.day!
                
                var miles: Double = activity.miles!
                
                // Get the miles into a number with two decimal places
                let milesString = String(format: "%.2f", miles)
                miles = Double(milesString)!
                
                let milesText = "\(milesString)\n Miles"
                self.miles[day].text = milesText
                self.miles[day].accessibilityValue = milesText
                self.miles[day].accessibilityLabel = milesText
                self.miles[day].accessibilityIdentifier = "miles\(day + 1)"
                
                // Set the background color based on the days feel
                let feel: Int = activity.feel!
                self.views[day].backgroundColor = UIColor(Constants.getFeelColor(feel - 1))
                
                // Add this days mileage to the weekly total
                let weekIndex: Int = day / 7
                weekTotals[weekIndex] += miles
            }
            
            // Populate all the week totals
            for i in 0...5 {
                let weekMiles = String(format: "%.2f", weekTotals[i])
                let totalText = "\(weekMiles)\n Miles"
                self.totals[i].text = totalText
                self.totals[i].accessibilityValue = totalText
            }
        }
    }
    
    /**
     A function to reset the calendar to its original state
     */
    func reset() {
        
        // Reset all the views background color
        views.forEach {
            view -> Void in
            
            view.backgroundColor = UIColor(0xFFFFFF)
        }
        
        // Reset all the miles for each day
        miles.forEach {
            mileLabel -> Void in
            
            mileLabel.text = ""
        }
        
        // Reset the weekly mileage totals
        totals.forEach {
            total -> Void in
            
            total.text = ""
        }
    }
    
    /**
     Return the type filter to send to the rangeview API endpoint
     - returns: A type filter code
     */
    func getTypeFilter() -> String {
        let r = run ? "r" : ""
        let b = bike ? "b" : ""
        let s = swim ? "s" : ""
        let o = other ? "o" : ""
        return "\(r)\(b)\(s)\(o)"
    }
    
    /**
     Navigate to the previous month in the calendar
     - parameters:
     - sender: the view that invoked this function (prevButton)
     */
    @IBAction func prevMonth(_ sender: UIButton) {
        os_log("View Previous Month.", log: logTag, type: .debug)
        
        // Subtract one month to the current monthStart date
        var calendar = Calendar(identifier: .gregorian)
        calendar.timeZone = TimeZone(secondsFromGMT: 0)!
        
        monthStart = calendar.date(byAdding: .month, value: -1, to: monthStart)!
        os_log("Previous Month Start: %@", log: logTag, type: .debug, monthStart.description)
        
        // Reset the calendar to default values and build the new month
        reset()
        filter(monthStart)
    }
    
    /**
     Navigate to the next month in the calendar
     - parameters:
     - sender: the view that invoked this function (nextButton)
     */
    @IBAction func nextMonth(_ sender: UIButton) {
        os_log("View Next Month.", log: logTag, type: .debug)
        
        // Add one month to the current monthStart date
        var calendar = Calendar(identifier: .gregorian)
        calendar.timeZone = TimeZone(secondsFromGMT: 0)!
        
        monthStart = calendar.date(byAdding: .month, value: 1, to: monthStart)!
        os_log("Next Month Start: %@", log: logTag, type: .debug, monthStart.description)
        
        // Reset the calendar to default values and build the new month
        reset()
        filter(monthStart)
    }
    
}
