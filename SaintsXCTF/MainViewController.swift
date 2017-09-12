//
//  MainViewController.swift
//  SaintsXCTF
//
//  Created by Andy Jarombek on 7/3/17.
//  Copyright © 2017 Andy Jarombek. All rights reserved.
//

import UIKit
import os.log

class MainViewController: UITableViewController {
    
    let logTag = OSLog(subsystem: "SaintsXCTF.App.MainViewController", category: "MainViewController")
    
    @IBOutlet weak var logTableView: UITableView!
    
    let logDataSource = LogDataSource()
    let heightDict = NSMutableDictionary()
    var finished = false
    
    let paramType = "all"
    let sortParam = "all"
    let limit = 10
    var offset = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        os_log("MainViewController Loaded.", log: logTag, type: .debug)
        
        navigationController?.navigationBar.backgroundColor = UIColor(0x999999, a: 0.9)
        
        // Setting the row height to UITableViewAutomaticDimension tells the TableView to determine the
        // height of a cell based on its contents and constraints.
        logTableView.rowHeight = UITableViewAutomaticDimension

        load()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // Hide the navigation bar on view appearing
        navigationController?.setNavigationBarHidden(true, animated: animated)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        // Show the navigation bar on view disappearing
        navigationController?.setNavigationBarHidden(false, animated: animated)
    }
    
    // Remove the keyboard when tapping the background
    @IBAction func backgroundTapped(_ sender: UITapGestureRecognizer) {
        view.endEditing(true)
    }
    
    // Returns the number of rows that the tableview should display
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return logDataSource.count()
    }
    
    // Either set the height to the cached value or let the automaticdimension determine the height
    override func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        if let height = heightDict.object(forKey: indexPath) as? NSNumber {
            return CGFloat(height.floatValue)
        } else {
            return UITableViewAutomaticDimension
        }
    }
    
    // Called when a cell at a certain index is about to be displayed
    override func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell,
                            forRowAt indexPath: IndexPath) {
        
        // Cache the height of the cell
        let height = NSNumber(value: Float(cell.frame.size.height))
        heightDict.setObject(height, forKey: indexPath as NSCopying)
        
        // When we are four logs from the bottom, load more
        if indexPath.row == logDataSource.count() - 4 {
            load()
        }
    }
    
    // Ask the datasource for a cell to insert at a certain location in the table view
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! LogTableViewCell
        let log = logDataSource.get(indexPath.row)
        
        let feelInt: Int! = Int(log.feel)
        if let validFeel: Int = feelInt {
            cell.setStyle(withFeel: validFeel)
        } else {
            cell.setStyle(withFeel: 6)
        }
        
        // Create a top border for the comments button
        let topline = UIView(frame: CGRect(x: -10, y: 0, width: cell.commentsButton.frame.size.width + 10, height: 1))
        topline.layer.backgroundColor = UIColor(0xAAAAAA).cgColor
        
        // Customize the comments button display
        cell.commentsButton.backgroundColor = UIColor(0x000000, a: 0.0)
        cell.commentsButton.addSubview(topline)
        cell.commentsButton.setTitleColor(UIColor(0x333333), for: UIControlState.normal)
        
        cell.userLabel?.text = "\(log.first!) \(log.last!)"
        
        // Convert the string to a date
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        
        // Then format the date for viewing
        let formattedDate = dateFormatter.date(from: log.date)
        dateFormatter.dateFormat = "MMM dd, yyyy"
        cell.dateLabel?.text = dateFormatter.string(from: formattedDate!)
        
        cell.nameLabel?.text = log.name!
        
        // Set the logs type
        cell.typeLabel?.text = log.type?.uppercased()
        
        // Set the logs location
        if let location: String = log.location {
            cell.locationLabel?.text = "Location: " + location
        } else {
            cell.locationLabel?.text = ""
        }
        
        // Set the logs distance
        var distanceTxt = ""
        
        if let distance: String = log.distance, let metric: String = log.metric {
            
            if distance != "0" {
                distanceTxt = distance + " " + metric
            }
        }
        
        cell.distanceLabel?.text = distanceTxt
        
        // Set the logs time
        var timeTxt = ""
        
        if let time: String = log.time, let pace: String = log.pace {
            if time != "00:00:00" {
                timeTxt = shortenTime(withTime: time)
                
                if pace == "00:00:00" {
                    timeTxt += " (0:00/mi)"
                } else {
                    timeTxt += " (\(shortenTime(withTime: pace))/mi)"
                }
            }
        }
        
        cell.timeLabel?.text = timeTxt
        
        // Set the logs description
        if let description: String = log.log_description {
            cell.descriptionLabel?.text = description
        }
        
        // Add a tag to the comments button of the current index path.
        // This will be used with the segue to call the commentsView
        cell.commentsButton.tag = indexPath.row
        
        return cell
    }
    
    // Pass data to the CommentViewController when the segue is executed
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        // We want to send the CommentViewController the log that was selected
        if let destination = segue.destination as? CommentViewController {
            
            if let button: UIButton = sender as! UIButton? {
                
                let row = button.tag
                let log = logDataSource.get(row)
                destination.log = log
            }
        }
    }
    
    // Load more logs into the data source
    func load() {
        logDataSource.load(withParamType: paramType, sortParam: sortParam, limit: limit, andOffset: offset) {
            (done) -> Void in
            
            self.logTableView.reloadData()
            
            // If there are no more logs to load, remove the activity indicator and
            // stop trying to load more logs
            if (done) {
                self.finished = done
            }
        }
        offset += limit
    }
    
    // Function to remove excess zeros from the time
    func shortenTime(withTime time: String) -> String {
        var start = 0
        
        for i in 0 ..< time.characters.count {
            let index = time.index(time.startIndex, offsetBy: i)
            if time[index] != "0" && time[index] != ":" {
                start = i
                break
            }
        }
        
        let index =  time.index(time.startIndex, offsetBy: start)
        return time.substring(from: index)
    }
}
