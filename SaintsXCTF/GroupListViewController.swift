//
//  GroupListViewController.swift
//  SaintsXCTF
//
//  Created by Andy Jarombek on 8/12/17.
//  Copyright © 2017 Andy Jarombek. All rights reserved.
//

import UIKit
import os.log

class GroupListViewController: UIViewController, UIGestureRecognizerDelegate {
    
    let logTag = OSLog(subsystem: "SaintsXCTF.App.GroupListViewController",
                       category: "GroupListViewController")
    
    @IBOutlet weak var wxcView: UIView!
    @IBOutlet weak var mxcView: UIView!
    @IBOutlet weak var wtfView: UIView!
    @IBOutlet weak var mtfView: UIView!
    @IBOutlet weak var alumniView: UIView!
    
    @IBOutlet weak var wxcButton: UIButton!
    @IBOutlet weak var mxcButton: UIButton!
    @IBOutlet weak var wtfButton: UIButton!
    @IBOutlet weak var mtfButton: UIButton!
    @IBOutlet weak var alumniButton: UIButton!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        os_log("GroupListViewController Loaded.", log: logTag, type: .debug)
        
        navigationController?.navigationBar.backgroundColor = UIColor(0x990000, a: 0.9)
        
        // Create top borders for all the group selections
        let wxcTopBorder = CALayer()
        wxcTopBorder.frame = CGRect.init(x: -20, y: 0, width: view.frame.width + 20, height: 1)
        wxcTopBorder.backgroundColor = UIColor(0xBBBBBB).cgColor
        
        let mxcTopBorder = CALayer()
        mxcTopBorder.frame = CGRect.init(x: -20, y: 0, width: view.frame.width + 20, height: 1)
        mxcTopBorder.backgroundColor = UIColor(0xBBBBBB).cgColor
        
        let wtfTopBorder = CALayer()
        wtfTopBorder.frame = CGRect.init(x: -20, y: 0, width: view.frame.width + 20, height: 1)
        wtfTopBorder.backgroundColor = UIColor(0xBBBBBB).cgColor
        
        let mtfTopBorder = CALayer()
        mtfTopBorder.frame = CGRect.init(x: -20, y: 0, width: view.frame.width + 20, height: 1)
        mtfTopBorder.backgroundColor = UIColor(0xBBBBBB).cgColor
        
        let alumniTopBorder = CALayer()
        alumniTopBorder.frame = CGRect.init(x: -20, y: 0, width: view.frame.width + 20, height: 1)
        alumniTopBorder.backgroundColor = UIColor(0xBBBBBB).cgColor
        
        // Weekly bottom border for other profiles that dont show the edit view
        let alumniBottomBorder = CALayer()
        alumniBottomBorder.frame = CGRect.init(x: -20, y: alumniView.frame.height + 1,
                                               width: view.frame.width + 20, height: 1)
        alumniBottomBorder.backgroundColor = UIColor(0xBBBBBB).cgColor
        
        wxcView.layer.addSublayer(wxcTopBorder)
        mxcView.layer.addSublayer(mxcTopBorder)
        wtfView.layer.addSublayer(wtfTopBorder)
        mtfView.layer.addSublayer(mtfTopBorder)
        alumniView.layer.addSublayer(alumniTopBorder)
        alumniView.layer.addSublayer(alumniBottomBorder)
        
        // Set click listener on womens xc to open up the group page
        let click = UITapGestureRecognizer(target: self, action: #selector(self.womensXC(_:)))
        click.delegate = self
        wxcView.addGestureRecognizer(click)
        
        let buttonclick = UITapGestureRecognizer(target: self, action: #selector(self.womensXC(_:)))
        buttonclick.delegate = self
        wxcButton.addGestureRecognizer(buttonclick)
        
        // Set click listener on mens xc to open up the group page
        let mensxcclick = UITapGestureRecognizer(target: self, action: #selector(self.mensXC(_:)))
        mensxcclick.delegate = self
        mxcView.addGestureRecognizer(mensxcclick)
        
        let mensxcbuttonclick = UITapGestureRecognizer(target: self, action: #selector(self.mensXC(_:)))
        mensxcbuttonclick.delegate = self
        mxcButton.addGestureRecognizer(mensxcbuttonclick)
        
        // Set click listener on womens tf to open up the group page
        let wmenstfclick = UITapGestureRecognizer(target: self, action: #selector(self.womensTF(_:)))
        wmenstfclick.delegate = self
        wtfView.addGestureRecognizer(wmenstfclick)
        
        let wmenstfbuttonclick = UITapGestureRecognizer(target: self, action: #selector(self.womensTF(_:)))
        wmenstfbuttonclick.delegate = self
        wtfButton.addGestureRecognizer(wmenstfbuttonclick)
        
        // Set click listener on mens tf to open up the group page
        let menstfclick = UITapGestureRecognizer(target: self, action: #selector(self.mensTF(_:)))
        menstfclick.delegate = self
        mtfView.addGestureRecognizer(menstfclick)
        
        let menstfbuttonclick = UITapGestureRecognizer(target: self, action: #selector(self.mensTF(_:)))
        menstfbuttonclick.delegate = self
        mtfButton.addGestureRecognizer(menstfbuttonclick)
        
        // Set click listener on alumni to open up the group page
        let alumniclick = UITapGestureRecognizer(target: self, action: #selector(self.alumni(_:)))
        alumniclick.delegate = self
        alumniView.addGestureRecognizer(alumniclick)
        
        let alumnibuttonclick = UITapGestureRecognizer(target: self, action: #selector(self.alumni(_:)))
        alumnibuttonclick.delegate = self
        alumniButton.addGestureRecognizer(alumnibuttonclick)
        
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
    
    // Functions to load groups depending on the group picked
    func womensXC(_ sender: UIView) {
        os_log("Go to Women's Cross Country Page", log: logTag, type: .debug)
        loadGroup(withGroupname: "wmensxc")
    }
    
    func mensXC(_ sender: UIView) {
        os_log("Go to Men's Cross Country Page", log: logTag, type: .debug)
        loadGroup(withGroupname: "mensxc")
    }
    
    func womensTF(_ sender: UIView) {
        os_log("Go to Women's Track & Field Page", log: logTag, type: .debug)
        loadGroup(withGroupname: "wmenstf")
    }
    
    func mensTF(_ sender: UIView) {
        os_log("Go to Men's Track & Field Page", log: logTag, type: .debug)
        loadGroup(withGroupname: "menstf")
    }
    
    func alumni(_ sender: UIView) {
        os_log("Go to Alumni Page", log: logTag, type: .debug)
        loadGroup(withGroupname: "alumni")
    }
    
    // Load the groupViewController with the given groupname
    func loadGroup(withGroupname group: String) {
        
        let groupViewController = storyboard?.instantiateViewController(withIdentifier:
            "groupViewController") as! GroupViewController
        
        // Pass the user to the edit profile view
        groupViewController.groupname = group
        
        navigationController?.pushViewController(groupViewController, animated: true)
    }
}
