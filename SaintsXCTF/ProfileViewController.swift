//
//  ProfileViewController.swift
//  SaintsXCTF
//
//  Created by Andy Jarombek on 8/12/17.
//  Copyright © 2017 Andy Jarombek. All rights reserved.
//

import UIKit
import os.log

/**
 Controller for the profile information and navigation options.
 - Important:
 ## Extends the following class:
 - UIViewController: provides behavior shared between all classes that manage a view
 
 ## Implements the following protocols:
 - UIGestureRecognizerDelegate: provides helper methods gor handling gestures (clicks,swipes,etc.)
 */
class ProfileViewController: UIViewController, UIGestureRecognizerDelegate {
    
    let logTag = OSLog(subsystem: "SaintsXCTF.App.ProfileViewController", category: "ProfileViewController")
    
    @IBOutlet weak var profilePictureView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var usernameLabel: UILabel!
    @IBOutlet weak var descriptionView: UITextView!
    @IBOutlet weak var reportButton: UIButton!
    @IBOutlet weak var editProfileButton: UIButton!
    @IBOutlet weak var logsButton: UIButton!
    @IBOutlet weak var monthlyButton: UIButton!
    @IBOutlet weak var weeklyButton: UIButton!
    @IBOutlet weak var reportView: UIView!
    @IBOutlet weak var editView: UIView!
    @IBOutlet weak var logsView: UIView!
    @IBOutlet weak var monthlyView: UIView!
    @IBOutlet weak var weeklyView: UIView!
    
    var user: User? = nil
    
    var showNavBar = false
    
    /**
     Invoked when the ProfileViewController loads
     */
    override func viewDidLoad() {
        super.viewDidLoad()
        os_log("ProfileViewController Loaded.", log: logTag, type: .debug)
        
        navigationController?.navigationBar.backgroundColor = UIColor(0x990000, a: 0.9)
        
        // Add a border to the profile picture
        profilePictureView.layer.borderWidth = 2
        profilePictureView.layer.borderColor = UIColor(0xCCCCCC).cgColor
        profilePictureView.layer.cornerRadius = 1
        
        // Create top borders for all the profile selections
        let logsTopBorder = createTopBorder()
        let monthlyTopBorder = createTopBorder()
        let weeklyTopBorder = createTopBorder()
        let editTopBorder = createTopBorder()
        let reportTopBorder = createTopBorder()
        
        // Weekly bottom border for other profiles that dont show the edit view
        let weeklyBottomBorder = createBottomBorder()
        
        // Since report is the last selection, it needs a bottom border as well
        let reportBottomBorder = createBottomBorder()
        
        logsView.layer.addSublayer(logsTopBorder)
        monthlyView.layer.addSublayer(monthlyTopBorder)
        weeklyView.layer.addSublayer(weeklyTopBorder)
        editView.layer.addSublayer(editTopBorder)
        reportView.layer.addSublayer(reportTopBorder)
        reportView.layer.addSublayer(reportBottomBorder)
        
        // Set up click listeners
        logsClickListener()
        monthlyClickListener()
        weeklyClickListener()
        editClickListener()
        
        
        // If there is no user defined, use the currently signed in user
        if let _ = user {
            os_log("Viewing Other Profile: %@", log: logTag, type: .debug, user?.description ?? "")
            
            // If this is not the signed in user, set the edit profile view to hidden
            editView.isHidden = true
            weeklyView.layer.addSublayer(weeklyBottomBorder)
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
        
        if (groups.count > 0) {
            for i in 0...groups.count - 1 {
                teamsTxt += "\(groups[i].group_title!)\n"
            }
        } else {
            teamsTxt += "No Teams"
        }
        
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
        
        let descriptionText = "\(teamsTxt)\n\(classYearTxt)\(favoriteEventTxt)\(locationTxt)"
        
        // Create a MutableAttributedString for the profile description
        let mutableContent = NSMutableAttributedString(string: descriptionText,
                                                       attributes: [:])
        
        let start = 0
        let end = teamsTxt.count
        
        let boldFontAttribute = [NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: 12.0)]
        mutableContent.addAttributes(boldFontAttribute, range: NSRange(location: start, length: end))
        
        descriptionView.attributedText = mutableContent
        
        // Set the profile picture
        if let profPicBase64 = user?.profilepic {
            
            if let range = profPicBase64.range(of: ",") {
                let start = profPicBase64.distance(from: profPicBase64.startIndex, to: range.lowerBound)
                
                // Part of the base 64 encoding is html specific, remove this piece
                let startIndex = profPicBase64.index(profPicBase64.startIndex, offsetBy: start)
                let endIndex = profPicBase64.endIndex
                
                let base64 = String(profPicBase64[startIndex..<endIndex])
                
                // Now decode the base 64 encoded string and convert it to an image
                guard let profPicData: Data = Data(base64Encoded: base64, options: .ignoreUnknownCharacters) else {
                    os_log("Failed to decode profile picture", log: logTag, type: .error)
                    return
                }
                
                let profPic: UIImage = UIImage(data: profPicData)!
                
                // Display the profile picture image
                profilePictureView.image = profPic
            }
        }
    }
    
    /**
     Invoked when the ProfileViewController is about to first appear on the screen
     - parameters:
     - animated: If true, the view is added to the window using an animation
     */
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // Hide the navigation bar on view appearing
        if !showNavBar {
            navigationController?.setNavigationBarHidden(true, animated: animated)
            
        } else {
            // Set the navigation bar back button to a custom image
            navigationController?.navigationBar.backIndicatorImage = UIImage(named: "back")
            navigationController?.navigationBar.backIndicatorTransitionMaskImage = UIImage(named: "back")
            navigationController?.navigationBar.tintColor = UIColor(0xFFFFFF)
            navigationItem.title = "\(user?.first ?? "") \(user?.last ?? "")"
            
            navigationItem.backBarButtonItem = UIBarButtonItem(title: " ", style: UIBarButtonItem.Style.plain, target: nil, action: nil)
        }
    }
    
    /**
     Invoked when the ProfileViewController is about to disappear from the screen
     - parameters:
     - animated: If true, the view is added to the window using an animation
     */
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        // Show the navigation bar on view disappearing
        navigationController?.setNavigationBarHidden(false, animated: animated)
    }
    
    /**
     Set click listener to the logs view to open up the users logs
     */
    func logsClickListener() {
        let clickLogs = UITapGestureRecognizer(target: self, action: #selector(self.showLogs(_:)))
        clickLogs.delegate = self
        logsView.addGestureRecognizer(clickLogs)
        
        let buttonclickLogs = UITapGestureRecognizer(target: self, action: #selector(self.showLogs(_:)))
        buttonclickLogs.delegate = self
        logsButton.addGestureRecognizer(buttonclickLogs)
    }
    
    /**
     Show the users logs (using mainViewController)
     - parameters:
     - sender: the view that invoked this function (logsView)
     */
    @objc func showLogs(_ sender: UIView) {
        os_log("Viewing Profile Logs", log: logTag, type: .debug)
        
        let mainViewController = storyboard?.instantiateViewController(withIdentifier:
            "showLogView") as! MainViewController
        
        // Pass both the log and the index to the log view controller
        mainViewController.paramType = "user"
        mainViewController.sortParam = user?.username ?? ""
        mainViewController.showNavBar = true
        mainViewController.userPassed = user ?? User()
        
        navigationController?.pushViewController(mainViewController, animated: true)
    }
    
    /**
     Set click listener to the monthly view to open up the users monthly calendar
     */
    func monthlyClickListener() {
        let clickMonthly = UITapGestureRecognizer(target: self, action: #selector(self.showMonthly(_:)))
        clickMonthly.delegate = self
        monthlyView.addGestureRecognizer(clickMonthly)
        
        let buttonclickMonthly = UITapGestureRecognizer(target: self, action: #selector(self.showMonthly(_:)))
        buttonclickMonthly.delegate = self
        monthlyButton.addGestureRecognizer(buttonclickMonthly)
    }
    
    /**
     Show the users monthly calendar (using monthlyViewController)
     - parameters:
     - sender: the view that invoked this function (monthlyView)
     */
    @objc func showMonthly(_ sender: UIView) {
        os_log("Viewing Profile Monthly", log: logTag, type: .debug)
        
        let monthlyViewController = storyboard?.instantiateViewController(withIdentifier:
            "monthlyViewController") as! MonthlyViewController
        
        // Pass the user to the edit profile view
        monthlyViewController.user = user ?? User()
        
        navigationController?.pushViewController(monthlyViewController, animated: true)
    }
    
    /**
     Set click listener to the weekly view to open up the users weekly exercise graph
     */
    func weeklyClickListener() {
        let clickWeekly = UITapGestureRecognizer(target: self, action: #selector(self.showWeekly(_:)))
        clickWeekly.delegate = self
        weeklyView.addGestureRecognizer(clickWeekly)
        
        let buttonclickWeekly = UITapGestureRecognizer(target: self, action: #selector(self.showWeekly(_:)))
        buttonclickWeekly.delegate = self
        weeklyButton.addGestureRecognizer(buttonclickWeekly)
    }
    
    /**
     Show the users weekly exercise graph (using weeklyViewController)
     - parameters:
     - sender: the view that invoked this function (weeklyView)
     */
    @objc func showWeekly(_ sender: UIView) {
        os_log("Viewing Profile Weekly", log: logTag, type: .debug)
        
        let weeklyViewController = storyboard?.instantiateViewController(withIdentifier:
            "weeklyViewController") as! WeeklyViewController
        
        // Pass the user to the edit profile view
        weeklyViewController.user = user ?? User()
        
        navigationController?.pushViewController(weeklyViewController, animated: true)
    }
    
    /**
     Set click listener to the edit view to open up the edit profile page
     */
    func editClickListener() {
        let click = UITapGestureRecognizer(target: self, action: #selector(self.editProfile(_:)))
        click.delegate = self
        editView.addGestureRecognizer(click)
        
        let buttonclick = UITapGestureRecognizer(target: self, action: #selector(self.editProfile(_:)))
        buttonclick.delegate = self
        editProfileButton.addGestureRecognizer(buttonclick)
    }
    
    /**
     Edit the users profile (using editProfileViewController)
     - parameters:
     - sender: the view that invoked this function (editView)
     */
    @objc func editProfile(_ sender: UIView) {
        os_log("Editing Profile", log: logTag, type: .debug)
        
        let editProfileViewController = storyboard?.instantiateViewController(withIdentifier:
            "editProfileViewController") as! EditProfileViewController
        
        // Pass the user to the edit profile view
        editProfileViewController.user = user ?? User()
        
        navigationController?.pushViewController(editProfileViewController, animated: true)
    }
    
    /**
     Set click listener to the report view to open up the file report page
     */
    func reportClickListener() {
        let click = UITapGestureRecognizer(target: self, action: #selector(self.fileReport(_:)))
        click.delegate = self
        reportView.addGestureRecognizer(click)
        
        let buttonclick = UITapGestureRecognizer(target: self, action: #selector(self.fileReport(_:)))
        buttonclick.delegate = self
        reportButton.addGestureRecognizer(buttonclick)
    }
    
    /**
     File a report to the app admin (using reportViewController)
     - parameters:
     - sender: the view that invoked this function (reportView)
     */
    @objc func fileReport(_ sender: UIView) {
        os_log("Filing Report", log: logTag, type: .debug)
        
        let reportViewController = storyboard?.instantiateViewController(withIdentifier:
            "reportViewController") as! ReportViewController
        
        // Pass the user to the file report view
        reportViewController.user = user ?? User()
        
        navigationController?.pushViewController(reportViewController, animated: true)
    }
    
    /**
     Creates a border for the top of a view
     - returns: A border to place at the top of a view
     */
    func createTopBorder() -> CALayer {
        let topBorder = CALayer()
        topBorder.frame = CGRect.init(x: -20, y: 0, width: view.frame.width + 20, height: 1)
        topBorder.backgroundColor = UIColor(0xBBBBBB).cgColor
        
        return topBorder
    }
    
    /**
     Creates a border for the bottom of a view
     - returns: A border to place at the bottom of a view
     */
    func createBottomBorder() -> CALayer {
        let bottomBorder = CALayer()
        bottomBorder.frame = CGRect.init(x: -20, y: weeklyView.frame.height + 1,
                                      width: view.frame.width + 20, height: 1)
        bottomBorder.backgroundColor = UIColor(0xBBBBBB).cgColor
        
        return bottomBorder
    }
}
