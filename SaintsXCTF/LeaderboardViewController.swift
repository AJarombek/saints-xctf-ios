//
//  LeaderboardViewController.swift
//  SaintsXCTF
//
//  Created by Andy Jarombek on 10/8/17.
//  Copyright © 2017 Andy Jarombek. All rights reserved.
//

import UIKit
import os.log

/**
 Controller for the group leaderboard UI.
 - Important:
 ## Extends the following class:
 - UITableViewController: view controller for managing a table view
 
 ## Implements the following protocols:
 - UIGestureRecognizerDelegate: provides helper methods gor handling gestures (clicks,swipes,etc.)
 - UIPickerViewDelegate: provides the data needed for a picker view to construct itself
 - UIPickerViewDataSource: used as a bridge between a picker view and the data held in the picker view
 */
class LeaderboardViewController: UITableViewController, UIGestureRecognizerDelegate, UIPickerViewDelegate, UIPickerViewDataSource {
    
    let logTag = OSLog(subsystem: "SaintsXCTF.App.LeaderboardViewController",
                       category: "LeaderboardViewController")
    
    @IBOutlet weak var leaderboardTableView: UITableView!
    
    var passedGroup: Group? = nil
    var leaderboardItems: [LeaderboardItem] = [LeaderboardItem]()
    var leaderboard: [[String]] = [[String]]()
    let heightDict = NSMutableDictionary()
    
    let timeFilters = ["All Time", "Past Year", "Past Month", "Past Week"]
    let timeAPIFilters = ["miles", "milespastyear", "milespastmonth", "milespastweek"]
    var run = true, bike = false, swim = false, other = false
    
    var timePicker: UIPickerView!
    var filters: SortView? = nil
    
    /**
     Invoked when the LeaderboardViewController loads
     */
    override func viewDidLoad() {
        super.viewDidLoad()
        os_log("LeaderboardViewController Loaded.", log: logTag, type: .debug)
        
        navigationController?.navigationBar.backgroundColor = UIColor(0x990000, a: 0.9)
        
        // Set the navigation bar back button to a custom image
        navigationController?.navigationBar.backIndicatorImage = UIImage(named: "back")
        navigationController?.navigationBar.backIndicatorTransitionMaskImage = UIImage(named: "back")
        navigationController?.navigationBar.tintColor = UIColor(0xFFFFFF)
        
        navigationItem.backBarButtonItem = UIBarButtonItem(title: " ", style:
            UIBarButtonItem.Style.plain, target: nil, action: nil)
        
        // Make sure the table view does not overlap the status bar & overlay view
        let insets = UIEdgeInsets(top: 98, left: 0, bottom: 0, right: 0)
        
        leaderboardTableView.contentInset = insets
        leaderboardTableView.scrollIndicatorInsets = insets
        
        // Setting the row height to UITableViewAutomaticDimension tells the TableView to determine the
        // height of a cell based on its contents and constraints.
        leaderboardTableView.rowHeight = UITableView.automaticDimension
        
        if let group: Group = passedGroup {
            navigationItem.title = group.group_title!
            
            // Build the default leaderboard - all time running miles
            leaderboardItems = group.leaderboards["miles"]!
            buildLeaderboardData()
            self.leaderboardTableView.reloadData()
        }
    }
    
    /**
     Invoked when the LeaderboardViewController is about to first appear on the screen
     - parameters:
     - animated: If true, the view is added to the window using an animation
     */
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        // Set up the view for the leaderboard filters
        filters = SortView.instantiateFromNib()
        filters?.center.x = (navigationController?.view.center.x)!
        navigationController?.view.insertSubview(filters!,
                                                 belowSubview: (self.navigationController?.navigationBar)!)
        
        // Set click listener to the leaderboard run filter
        let click = UITapGestureRecognizer(target: self, action: #selector(self.filterRun(_:)))
        click.delegate = self
        self.filters?.runButton.addGestureRecognizer(click)
        
        // Set click listener to the leaderboard bike filter
        let bikeclick = UITapGestureRecognizer(target: self, action: #selector(self.filterBike(_:)))
        bikeclick.delegate = self
        self.filters?.bikeButton.addGestureRecognizer(bikeclick)
        
        // Set click listener to the leaderboard swim filter
        let swimclick = UITapGestureRecognizer(target: self, action: #selector(self.filterSwim(_:)))
        swimclick.delegate = self
        self.filters?.swimButton.addGestureRecognizer(swimclick)
        
        // Set click listener to the leaderboard other filter
        let otherclick = UITapGestureRecognizer(target: self, action: #selector(self.filterOther(_:)))
        otherclick.delegate = self
        self.filters?.otherButton.addGestureRecognizer(otherclick)
        
        // Create a view to hold the time picker and the done button
        let timeInputView = UIView(frame: CGRect(x: 0, y: 0, width: self.view.bounds.size.width, height: 240))
        
        // Set the picker view for time filter
        timePicker = UIPickerView(frame: CGRect(x: 0, y: 40, width: 0, height: 0))
        timePicker.delegate = self
        timePicker.dataSource = self
        
        timeInputView.addSubview(timePicker)
        self.filters?.rangeSortField.inputView = timePicker
        self.filters?.rangeSortField.text = timeFilters[0]
        
        let typeToolbar = UIToolbar().PickerToolbar(selector: #selector(filters?.dismissPicker))
        self.filters?.rangeSortField.inputAccessoryView = typeToolbar
        
        // Hide the colored cursor when the rangeSortField is selected
        self.filters?.rangeSortField.tintColor = .clear
        
        // The run filter is selected by default
        filterRun()
    }
    
    /**
     Invoked when the LeaderboardViewController is about to disappear from the screen
     - parameters:
     - animated: If true, the view is added to the window using an animation
     */
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)

        filters?.removeFromSuperview()
    }
    
    /**
     Returns the number of rows that the tableview should display
     - parameters:
     - tableView: the table view in which rows will be displayed
     - section: the number of rows in this particular table view section.  This table view only uses
     a single section.
     - returns: The number of rows in the tableview
     */
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return leaderboard.count
    }
    
    /**
     Either set the height to the cached value or let the automaticdimension determine the height
     - parameters:
     - tableView: the table view requesting information
     - indexPath: the index of a row in the table view
     - returns: The height of a row in the tableview
     */
    override func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        if let height = heightDict.object(forKey: indexPath) as? NSNumber {
            return CGFloat(height.floatValue)
        } else {
            return UITableView.automaticDimension
        }
    }
    
    /**
     Called when a cell at a certain index is about to be displayed
     - parameters:
     - tableView: the table view requesting information
     - cell: the cell about to be displayed
     - indexPath: The index of the cell in the table view
     */
    override func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell,
                            forRowAt indexPath: IndexPath) {
        
        // Cache the height of the cell
        let height = NSNumber(value: Float(cell.frame.size.height))
        heightDict.setObject(height, forKey: indexPath as NSCopying)
    }
    
    /**
     Ask the datasource for a cell to insert at a certain location in the table view
     The less work that is done in this function, the smoother the scrolling is
     - parameters:
     - tableView: the table view requesting information
     - indexPath: the index of a row in the table view
     - returns: The table view cell to be added
     */
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "LogCell", for: indexPath)
                        as! LeaderboardTableViewCell
        let leader: [String] = leaderboard[indexPath.row]
        
        cell.nameLabel.text = "\(indexPath.row + 1)) \(leader[0])"
        let distanceDouble = Double(leader[1])!
        let distance = String(format: "%.2f", distanceDouble)
        cell.distanceLabel.text = "\(distance) Miles"
        
        cell.setStyle()
        
        return cell
    }
    
    /**
     Return the number of components in the UIPicker
     - parameters:
     - pickerView: the picker view requesting information
     - returns: number of components (always 1)
     */
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    /**
     Return the number of rows in the given UIPicker
     - parameters:
     - pickerView: the picker view requesting information
     - component: unused
     - returns: number of rows (length of the time filter list)
     */
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return timeFilters.count
    }
    
    /**
     Return the title for the row that is to be shown in the UIPicker
     - parameters:
     - pickerView: the picker view requesting information
     - row: the row in the picker view being shown
     - component: unused
     - returns: the title for the row
     */
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return timeFilters[row]
    }
    
    /**
     Dislay the picked value from the UIPicker
     - parameters:
     - pickerView: the picker view requesting information
     - row: the row in the picker view being shown
     - component: the component in the picker view being shown (there is only one component)
     */
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        self.filters?.rangeSortField.text = timeFilters[row]
        
        // Get the proper leaderboard based on the time filter selected.  Also make sure to reload the
        // data for the table view
        let filter: String = timeAPIFilters[row]
        leaderboardItems = (passedGroup?.leaderboards[filter])!
        buildLeaderboardData()
        self.leaderboardTableView.reloadData()
    }
    
    /**
     Function to build the leaderboard array with the current filters
     */
    func buildLeaderboardData() {
        var leaders: [[String]] = buildLeaderboardDataStructure(leaderboardItems: leaderboardItems)
        leaders = sortLeaderboardByMileage(leaderArray: leaders)
        
        leaderboard = leaders
    }
    
    /**
     Create a new array data structure for leaderboard items.  This data structure is used to
     populate the leaderbaord UI.
     - parameters:
     - leaderboardItems: A list of LeaderboardItem objects which contain the leaders in exercises
     for a group
     */
    func buildLeaderboardDataStructure(leaderboardItems: [LeaderboardItem]) -> [[String]] {
        // Array for the final leaderboard data structure
        var leaders: [[String]] = [[String]]()
        
        // Go through each of the leaderboard items from the API
        leaderboardItems.forEach {
            entry -> Void in
            
            // For each item, get the persons name and their mileage for the given filters
            var leader: [String] = []
            
            let milesrun: Double = run ? entry.milesrun : 0
            let milesbiked: Double = bike ? entry.milesbiked : 0
            let milesswam: Double = swim ? entry.milesswam : 0
            let milesother: Double = other ? entry.milesother : 0
            
            leader.append("\(entry.first!) \(entry.last!)")
            leader.append("\(milesrun + milesbiked + milesswam + milesother)")
            
            leaders.append(leader)
        }
        
        return leaders
    }
    
    /**
     Sort leaderboard items by the miles exercised (highest mileage coming first).
     - parameters:
     - leaderArray: An array of leaderboard items that need to be sorted by mileage
     */
    func sortLeaderboardByMileage(leaderArray: [[String]]) -> [[String]] {
        var leaders = leaderArray
        
        leaders.sort {
            $0[1].compare($1[1], options: .numeric) == .orderedDescending
        }
        
        return leaders
    }
    
    // These functions are called when the filter buttons for the leaderboard are clicked
    
    /**
     Toggle running exercises in the leaderboard table
     - parameters:
     - sender: the view clicked which toggles the run filter
     */
    @objc func filterRun(_ sender: UIView) {
        run = !run
        filterRun()
        buildLeaderboardData()
        self.leaderboardTableView.reloadData()
    }
    
    /**
     Visualize the running exercises toggled on/off in the leaderboard table
     */
    func filterRun() {
        if run {
            filters?.runButton.backgroundColor = UIColor(0x990000)
            filters?.runButton.setTitleColor(UIColor(0xFFFFFF), for: .normal)
        } else {
            filters?.runButton.backgroundColor = UIColor(0xEEEEEE)
            filters?.runButton.setTitleColor(UIColor(0x000000), for: .normal)
        }
    }
    
    /**
     Toggle bike exercises in the leaderboard table
     - parameters:
     - sender: the view clicked which toggles the bike filter
     */
    @objc func filterBike(_ sender: UIView) {
        bike = !bike
        filterBike()
        buildLeaderboardData()
        self.leaderboardTableView.reloadData()
    }
    
    /**
     Visualize the bike exercises toggled on/off in the leaderboard table
     */
    func filterBike() {
        if bike {
            filters?.bikeButton.backgroundColor = UIColor(0x990000)
            filters?.bikeButton.setTitleColor(UIColor(0xFFFFFF), for: .normal)
        } else {
            filters?.bikeButton.backgroundColor = UIColor(0xEEEEEE)
            filters?.bikeButton.setTitleColor(UIColor(0x000000), for: .normal)
        }
    }
    
    /**
     Toggle swimming exercises in the leaderboard table
     - parameters:
     - sender: the view clicked which toggles the swim filter
     */
    @objc func filterSwim(_ sender: UIView) {
        swim = !swim
        filterSwim()
        buildLeaderboardData()
        self.leaderboardTableView.reloadData()
    }
    
    /**
     Visualize the swimming exercises toggled on/off in the leaderboard table
     */
    func filterSwim() {
        if swim {
            filters?.swimButton.backgroundColor = UIColor(0x990000)
            filters?.swimButton.setTitleColor(UIColor(0xFFFFFF), for: .normal)
        } else {
            filters?.swimButton.backgroundColor = UIColor(0xEEEEEE)
            filters?.swimButton.setTitleColor(UIColor(0x000000), for: .normal)
        }
    }
    
    /**
     Toggle other exercises in the leaderboard table
     - parameters:
     - sender: the view clicked which toggles the other filter
     */
    @objc func filterOther(_ sender: UIView) {
        other = !other
        filterOther()
        buildLeaderboardData()
        self.leaderboardTableView.reloadData()
    }
    
    /**
     Visualize the other exercises toggled on/off in the leaderboard table
     */
    func filterOther() {
        if other {
            filters?.otherButton.backgroundColor = UIColor(0x990000)
            filters?.otherButton.setTitleColor(UIColor(0xFFFFFF), for: .normal)
        } else {
            filters?.otherButton.backgroundColor = UIColor(0xEEEEEE)
            filters?.otherButton.setTitleColor(UIColor(0x000000), for: .normal)
        }
    }
}
