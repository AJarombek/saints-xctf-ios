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
        
        // Add a border to the profile picture
        profilePictureView.layer.borderWidth = 2
        profilePictureView.layer.borderColor = UIColor(0xCCCCCC).cgColor
        profilePictureView.layer.cornerRadius = 1
        
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
        
        // Weekly bottom border for other profiles that dont show the edit view
        let weeklyBottomBorder = CALayer()
        weeklyBottomBorder.frame = CGRect.init(x: -20, y: weeklyView.frame.height + 1,
                                             width: view.frame.width + 20, height: 1)
        weeklyBottomBorder.backgroundColor = UIColor(0xBBBBBB).cgColor
        
        // Since weekly is the last selection, it needs a bottom border as well
        let editBottomBorder = CALayer()
        editBottomBorder.frame = CGRect.init(x: -20, y: weeklyView.frame.height + 1,
                                               width: view.frame.width + 20, height: 1)
        editBottomBorder.backgroundColor = UIColor(0xBBBBBB).cgColor
        
        logsView.layer.addSublayer(logsTopBorder)
        monthlyView.layer.addSublayer(monthlyTopBorder)
        weeklyView.layer.addSublayer(weeklyTopBorder)
        editView.layer.addSublayer(topBorder)
        editView.layer.addSublayer(editBottomBorder)
        
        // Set click listener to the edit view to open up the edit profile page
        let click = UITapGestureRecognizer(target: self, action: #selector(self.editProfile(_:)))
        click.delegate = self
        editView.addGestureRecognizer(click)
        
        let buttonclick = UITapGestureRecognizer(target: self, action: #selector(self.editProfile(_:)))
        buttonclick.delegate = self
        editProfileButton.addGestureRecognizer(buttonclick)
        
        // Set click listener to the logs view to open up the users logs
        let clickLogs = UITapGestureRecognizer(target: self, action: #selector(self.showLogs(_:)))
        clickLogs.delegate = self
        logsView.addGestureRecognizer(clickLogs)
        
        let buttonclickLogs = UITapGestureRecognizer(target: self, action: #selector(self.showLogs(_:)))
        buttonclickLogs.delegate = self
        logsButton.addGestureRecognizer(buttonclickLogs)
        
        // Set click listener to the monthly view to open up the users monthly calendar
        let clickMonthly = UITapGestureRecognizer(target: self, action: #selector(self.showMonthly(_:)))
        clickMonthly.delegate = self
        monthlyView.addGestureRecognizer(clickMonthly)
        
        let buttonclickMonthly = UITapGestureRecognizer(target: self, action: #selector(self.showMonthly(_:)))
        buttonclickMonthly.delegate = self
        monthlyButton.addGestureRecognizer(buttonclickMonthly)
        
        // Set click listener to the weekly view to open up the users weekly exercise graph
        let clickWeekly = UITapGestureRecognizer(target: self, action: #selector(self.showWeekly(_:)))
        clickWeekly.delegate = self
        weeklyView.addGestureRecognizer(clickWeekly)
        
        let buttonclickWeekly = UITapGestureRecognizer(target: self, action: #selector(self.showWeekly(_:)))
        buttonclickWeekly.delegate = self
        weeklyButton.addGestureRecognizer(buttonclickWeekly)
        
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
        
        for i in 0...groups.count - 1 {
            teamsTxt += "\(groups[i].group_title!)\n"
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
        let end = teamsTxt.characters.count
        
        let boldFontAttribute = [NSFontAttributeName: UIFont.boldSystemFont(ofSize: 12.0)]
        mutableContent.addAttributes(boldFontAttribute, range: NSRange(location: start, length: end))
        
        descriptionView.attributedText = mutableContent
        
        // Set the profile picture
        if let profPicBase64 = user?.profilepic {
            
            // Part of the base 64 encoding is html specific, remove this piece
            let index = profPicBase64.index(profPicBase64.startIndex, offsetBy: 23)
            let base64 = profPicBase64.substring(from: index)
            
            // Now decode the base 64 encoded string and convert it to an image
            let profPicData: Data = Data(base64Encoded: base64, options: .ignoreUnknownCharacters)!
            let profPic: UIImage = UIImage(data: profPicData)!
            
            // Display the profile picture image
            profilePictureView.image = profPic
        }
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
    
    // Show the users logs (using mainViewController)
    func showLogs(_ sender: UIView) {
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
    
    // Show the users monthly calendar (using monthlyViewController)
    func showMonthly(_ sender: UIView) {
        os_log("Viewing Profile Monthly", log: logTag, type: .debug)
        
        let monthlyViewController = storyboard?.instantiateViewController(withIdentifier:
            "monthlyViewController") as! MonthlyViewController
        
        // Pass the user to the edit profile view
        monthlyViewController.user = user ?? User()
        
        navigationController?.pushViewController(monthlyViewController, animated: true)
    }
    
    // Show the users weekly exercise graph (using weeklyViewController)
    func showWeekly(_ sender: UIView) {
        os_log("Viewing Profile Weekly", log: logTag, type: .debug)
        
        let weeklyViewController = storyboard?.instantiateViewController(withIdentifier:
            "weeklyViewController") as! WeeklyViewController
        
        // Pass the user to the edit profile view
        weeklyViewController.user = user ?? User()
        
        navigationController?.pushViewController(weeklyViewController, animated: true)
    }
    
    // Edit the users profile (using editProfileViewController)
    func editProfile(_ sender: UIView) {
        os_log("Editing Profile", log: logTag, type: .debug)
        
        let editProfileViewController = storyboard?.instantiateViewController(withIdentifier:
            "editProfileViewController") as! EditProfileViewController
        
        // Pass the user to the edit profile view
        editProfileViewController.user = user ?? User()
        
        navigationController?.pushViewController(editProfileViewController, animated: true)
    }
}
