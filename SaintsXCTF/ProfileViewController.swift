//
//  ProfileViewController.swift
//  SaintsXCTF
//
//  Created by Andy Jarombek on 8/12/17.
//  Copyright © 2017 Andy Jarombek. All rights reserved.
//

import UIKit
import os.log

class ProfileViewController: UIViewController, UIGestureRecognizerDelegate {
    
    let logTag = OSLog(subsystem: "SaintsXCTF.App.ProfileViewController", category: "ProfileViewController")
    
    @IBOutlet weak var profilePictureView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var usernameLabel: UILabel!
    @IBOutlet weak var teamsView: UITextView!
    @IBOutlet weak var descriptionView: UITextView!
    @IBOutlet weak var editProfileButton: UIButton!
    @IBOutlet weak var logsButton: UIButton!
    @IBOutlet weak var monthlyButton: UIButton!
    @IBOutlet weak var weeklyButton: UIButton!
    @IBOutlet weak var editView: UIView!
    @IBOutlet weak var logsView: UIView!
    @IBOutlet weak var monthlyView: UIView!
    @IBOutlet weak var weeklyView: UIView!
    
    var user: User? = nil
    
    var showNavBar = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        os_log("ProfileViewController Loaded.", log: logTag, type: .debug)
        
        navigationController?.navigationBar.backgroundColor = UIColor(0x999999, a: 0.9)
        
        // Create top borders for all the profile selections
        let topBorder = CALayer()
        topBorder.frame = CGRect.init(x: -20, y: 0, width: view.frame.width + 20, height: 1)
        topBorder.backgroundColor = UIColor(0xBBBBBB).cgColor
        
        let logsTopBorder = CALayer()
        logsTopBorder.frame = CGRect.init(x: -20, y: 0, width: view.frame.width + 20, height: 1)
        logsTopBorder.backgroundColor = UIColor(0xBBBBBB).cgColor
        
        let monthlyTopBorder = CALayer()
        monthlyTopBorder.frame = CGRect.init(x: -20, y: 0, width: view.frame.width + 20, height: 1)
        monthlyTopBorder.backgroundColor = UIColor(0xBBBBBB).cgColor
        
        let weeklyTopBorder = CALayer()
        weeklyTopBorder.frame = CGRect.init(x: -20, y: 0, width: view.frame.width + 20, height: 1)
        weeklyTopBorder.backgroundColor = UIColor(0xBBBBBB).cgColor
        
        // Since weekly is the last selection, it needs a bottom border as well
        let weeklyBottomBorder = CALayer()
        weeklyBottomBorder.frame = CGRect.init(x: -20, y: weeklyView.frame.height + 1,
                                               width: view.frame.width + 20, height: 1)
        weeklyBottomBorder.backgroundColor = UIColor(0xBBBBBB).cgColor
        
        editView.layer.addSublayer(topBorder)
        logsView.layer.addSublayer(logsTopBorder)
        monthlyView.layer.addSublayer(monthlyTopBorder)
        weeklyView.layer.addSublayer(weeklyTopBorder)
        weeklyView.layer.addSublayer(weeklyBottomBorder)
        
        // Set click listener to the logs view to open up the users logs
        let click = UITapGestureRecognizer(target: self, action: #selector(self.showLogs(_:)))
        click.delegate = self
        logsView.addGestureRecognizer(click)
        
        let buttonclick = UITapGestureRecognizer(target: self, action: #selector(self.showLogs(_:)))
        buttonclick.delegate = self
        logsButton.addGestureRecognizer(buttonclick)
        
        // If there is no user defined, use the currently signed in user
        if let _ = user {
            os_log("Viewing Other Profile: %@", log: logTag, type: .debug, user?.description ?? "")
        } else {
            user = SignedInUser.user
            os_log("Viewing My Profile: %@", log: logTag, type: .debug, user?.description ?? "")
        }
        
        // Set the name labels for the profile
        nameLabel.text = "\(user?.first ?? "") \(user?.last ?? "")"
        usernameLabel.text = "@\(user?.username ?? "")"
        
        // Build up the group label with all of the users groups
        var teamsTxt = ""
        let groups: [GroupInfo] = (user?.groups)!
        
        for i in 0...groups.count - 1 {
            
            if i == 0 {
                teamsTxt += groups[i].group_title!
            } else {
                
                if i % 2 == 0 {
                    teamsTxt += ",\n\(groups[i].group_title!)"
                } else {
                    teamsTxt += ", \(groups[i].group_title!)"
                }
            }
        }
        
        teamsView.text = teamsTxt
        
        // Set the description text view with the users class year, favorite event,
        // and location
        var classYearTxt = ""
        if let class_year = user?.class_year {
            classYearTxt = "Class Year: \(class_year)\n"
        }
        
        var favoriteEventTxt = ""
        if let favorite_event = user?.favorite_event {
            favoriteEventTxt = "Favorite Event: \(favorite_event)\n"
        }
        
        var locationTxt = ""
        if let location = user?.location {
            locationTxt = "Location: \(location)\n"
        }
        
        descriptionView.text = "\(classYearTxt)\(favoriteEventTxt)\(locationTxt)"
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // Hide the navigation bar on view appearing
        if !showNavBar {
            navigationController?.setNavigationBarHidden(true, animated: animated)
            
        } else {
            // Set the navigation bar back button to a custom image
            navigationController?.navigationBar.backIndicatorImage = UIImage(named: "back")
            navigationController?.navigationBar.backIndicatorTransitionMaskImage = UIImage(named: "back")
            navigationController?.navigationBar.tintColor = UIColor(0x000000)
            navigationItem.title = "\(user?.first ?? "") \(user?.last ?? "")"
            
            navigationItem.backBarButtonItem = UIBarButtonItem(title: " ", style: UIBarButtonItemStyle.plain, target: nil, action: nil)
        }
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
    
    func showLogs(_ sender: UIView) {
        os_log("Viewing Profile Logs", log: logTag, type: .debug)
        
        if let _: UIStoryboard = storyboard {
            os_log("Storyboard Exists", log: logTag, type: .debug)
        } else {
            os_log("No Current Storyboard", log: logTag, type: .debug)
        }
        
        let mainViewController = storyboard?.instantiateViewController(withIdentifier:
            "showLogView") as! MainViewController
        
        // Pass both the log and the index to the log view controller
        mainViewController.paramType = "user"
        mainViewController.sortParam = user?.username ?? ""
        mainViewController.showNavBar = true
        mainViewController.userPassed = user ?? User()
        
        navigationController?.pushViewController(mainViewController, animated: true)
    }
}
