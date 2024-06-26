//
//  EditProfileViewController.swift
//  SaintsXCTF
//
//  Created by Andy Jarombek on 9/26/17.
//  Copyright © 2017 Andy Jarombek. All rights reserved.
//

import UIKit
import os.log

/**
 Controller for editing a users profile information.
 - Important:
 ## Extends the following class:
 - UIViewController: provides behavior shared between all classes that manage a view
 
 ## Implements the following protocols:
 - UIGestureRecognizerDelegate: provides helper methods gor handling gestures (clicks,swipes,etc.)
 */
class EditProfileViewController: UIViewController, UIGestureRecognizerDelegate {
    
    let logTag = OSLog(subsystem: "SaintsXCTF.App.EditProfileViewController",
                       category: "EditProfileViewController")
    
    @IBOutlet weak var detailsView: UIView!
    @IBOutlet weak var profileView: UIView!
    @IBOutlet weak var groupsView: UIView!
    @IBOutlet weak var detailsButton: UIButton!
    @IBOutlet weak var profileButton: UIButton!
    @IBOutlet weak var groupsButton: UIButton!
    @IBOutlet weak var detailsIcon: UIButton!
    @IBOutlet weak var profileIcon: UIButton!
    @IBOutlet weak var groupsIcon: UIButton!
    
    var user: User = User()
    
    /**
     Invoked when the EditProfileViewController loads
     */
    override func viewDidLoad() {
        super.viewDidLoad()
        os_log("EditProfileViewController Loaded.", log: logTag, type: .debug)
        
        // Set the navigation bar back button to a custom image
        navigationController?.navigationBar.backIndicatorImage = UIImage(named: "back")
        navigationController?.navigationBar.backIndicatorTransitionMaskImage = UIImage(named: "back")
        navigationController?.navigationBar.tintColor = UIColor(0xFFFFFF)
        navigationItem.title = "Edit Profile"
        
        navigationItem.backBarButtonItem = UIBarButtonItem(title: " ", style:
            UIBarButtonItem.Style.plain, target: nil, action: nil)
        
        if self.traitCollection.userInterfaceStyle == .dark {
            detailsButton.tintColor = .white
            profileButton.tintColor = .white
            groupsButton.tintColor = .white
            
            detailsIcon.tintColor = UIColor(0xE60000)
            profileIcon.tintColor = UIColor(0xE60000)
            groupsIcon.tintColor = UIColor(0xE60000)
        } else {
            detailsButton.tintColor = .darkGray
            profileButton.tintColor = .darkGray
            groupsButton.tintColor = .darkGray
            
            detailsIcon.tintColor = UIColor(0x990000)
            profileIcon.tintColor = UIColor(0x990000)
            groupsIcon.tintColor = UIColor(0x990000)
        }
        
        // Create top borders for all the edit profile selections
        let detailsTopBorder = CALayer()
        detailsTopBorder.frame = CGRect.init(x: -20, y: 0, width: view.frame.width + 20, height: 1)
        detailsTopBorder.backgroundColor = UIColor(0xBBBBBB).cgColor
        
        let profileTopBorder = CALayer()
        profileTopBorder.frame = CGRect.init(x: -20, y: 0, width: view.frame.width + 20, height: 1)
        profileTopBorder.backgroundColor = UIColor(0xBBBBBB).cgColor
        
        let groupsTopBorder = CALayer()
        groupsTopBorder.frame = CGRect.init(x: -20, y: 0, width: view.frame.width + 20, height: 1)
        groupsTopBorder.backgroundColor = UIColor(0xBBBBBB).cgColor
        
        // Since groups is the last selection, it needs a bottom border as well
        let groupsBottomBorder = CALayer()
        groupsBottomBorder.frame = CGRect.init(x: -20, y: groupsView.frame.height + 1,
                                               width: view.frame.width + 20, height: 1)
        groupsBottomBorder.backgroundColor = UIColor(0xBBBBBB).cgColor
        
        detailsView.layer.addSublayer(detailsTopBorder)
        profileView.layer.addSublayer(profileTopBorder)
        groupsView.layer.addSublayer(groupsTopBorder)
        groupsView.layer.addSublayer(groupsBottomBorder)
        
        // Set click listener to the details view to open up the edit profile details page
        let click = UITapGestureRecognizer(target: self, action: #selector(self.editProfileDetails(_:)))
        click.delegate = self
        detailsView.addGestureRecognizer(click)
        
        let buttonclick = UITapGestureRecognizer(target: self, action: #selector(self.editProfileDetails(_:)))
        buttonclick.delegate = self
        detailsButton.addGestureRecognizer(buttonclick)
        
        // Set click listener to the profile picture view to open up the profile picture page
        let propicClick = UITapGestureRecognizer(target: self, action: #selector(self.editProfilePicture(_:)))
        propicClick.delegate = self
        profileView.addGestureRecognizer(propicClick)
        
        let propicButtonclick = UITapGestureRecognizer(target: self, action: #selector(self.editProfilePicture(_:)))
        propicButtonclick.delegate = self
        profileView.addGestureRecognizer(propicButtonclick)
        
        // Set click listener to the group view to open up the pick groups page
        let groupClick = UITapGestureRecognizer(target: self, action: #selector(self.editProfileGroups(_:)))
        groupClick.delegate = self
        groupsView.addGestureRecognizer(groupClick)
        
        let groupButtonclick = UITapGestureRecognizer(target: self, action: #selector(self.editProfileGroups(_:)))
        groupButtonclick.delegate = self
        groupsView.addGestureRecognizer(groupButtonclick)
    }
    
    /**
     Edit the users profile details (using detailsViewController)
     - parameters:
     - sender: the view that invoked this function (detailsButton)
     */
    @objc func editProfileDetails(_ sender: UIView) {
        os_log("Editing Profile Details", log: logTag, type: .debug)
        
        let detailsViewController = storyboard?.instantiateViewController(withIdentifier:
            "detailsViewController") as! DetailsViewController
        
        // Pass the user to the edit profile view
        detailsViewController.user = user
        
        navigationController?.pushViewController(detailsViewController, animated: true)
    }
    
    /**
     Edit the users profile picture (using proPicViewController)
     - parameters:
     - sender: the view that invoked this function (profileButton)
     */
    @objc func editProfilePicture(_ sender: UIView) {
        os_log("Editing Profile Picture", log: logTag, type: .debug)
        
        let proPicViewController = storyboard?.instantiateViewController(withIdentifier:
            "proPicViewController") as! ProPicViewController
        
        // Pass the user to the profile picture view
        proPicViewController.user = user
        
        navigationController?.pushViewController(proPicViewController, animated: true)
    }
    
    /**
     Edit the users groups (using pickGroupViewController)
     - parameters:
     - sender: the view that invoked this function (groupsButton)
     */
    @objc func editProfileGroups(_ sender: UIView) {
        os_log("Editing Profile Groups", log: logTag, type: .debug)
        
        let pickViewController = storyboard?.instantiateViewController(withIdentifier:
            "pickGroupViewController") as! PickGroupController
        
        // Pass the user to the pick groups view
        pickViewController.user = user
        
        navigationController?.pushViewController(pickViewController, animated: true)
    }
}
