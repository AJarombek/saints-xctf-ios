//
//  EditProfileViewController.swift
//  SaintsXCTF
//
//  Created by Andy Jarombek on 9/26/17.
//  Copyright © 2017 Andy Jarombek. All rights reserved.
//

import UIKit
import os.log

class EditProfileViewController: UIViewController, UIGestureRecognizerDelegate {
    
    let logTag = OSLog(subsystem: "SaintsXCTF.App.EditProfileViewController",
                       category: "EditProfileViewController")
    
    @IBOutlet weak var detailsView: UIView!
    @IBOutlet weak var profileView: UIView!
    @IBOutlet weak var groupsView: UIView!
    @IBOutlet weak var detailsButton: UIButton!
    @IBOutlet weak var profileButton: UIButton!
    @IBOutlet weak var groupsButton: UIButton!
    
    var user: User = User()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        os_log("EditProfileViewController Loaded.", log: logTag, type: .debug)
        
        // Set the navigation bar back button to a custom image
        navigationController?.navigationBar.backIndicatorImage = UIImage(named: "back")
        navigationController?.navigationBar.backIndicatorTransitionMaskImage = UIImage(named: "back")
        navigationController?.navigationBar.tintColor = UIColor(0x000000)
        navigationItem.title = "Edit Profile"
        
        navigationItem.backBarButtonItem = UIBarButtonItem(title: " ", style:
            UIBarButtonItemStyle.plain, target: nil, action: nil)
        
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
    
    // Edit the users profile details (using detailsViewController)
    func editProfileDetails(_ sender: UIView) {
        os_log("Editing Profile Details", log: logTag, type: .debug)
        
        let detailsViewController = storyboard?.instantiateViewController(withIdentifier:
            "detailsViewController") as! DetailsViewController
        
        // Pass the user to the edit profile view
        detailsViewController.user = user
        
        navigationController?.pushViewController(detailsViewController, animated: true)
    }
    
    // Edit the users profile picture (using proPicViewController)
    func editProfilePicture(_ sender: UIView) {
        os_log("Editing Profile Picture", log: logTag, type: .debug)
        
        let proPicViewController = storyboard?.instantiateViewController(withIdentifier:
            "proPicViewController") as! ProPicViewController
        
        // Pass the user to the profile picture view
        proPicViewController.user = user
        
        navigationController?.pushViewController(proPicViewController, animated: true)
    }
    
    // Edit the users groups (using pickGroupViewController)
    func editProfileGroups(_ sender: UIView) {
        os_log("Editing Profile Picture", log: logTag, type: .debug)
        
        let pickViewController = storyboard?.instantiateViewController(withIdentifier:
            "pickGroupViewController") as! PickGroupController
        
        // Pass the user to the pick groups view
        pickViewController.user = user
        
        navigationController?.pushViewController(pickViewController, animated: true)
    }
}
