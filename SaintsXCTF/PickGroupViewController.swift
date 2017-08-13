//
//  PickGroupController.swift
//  SaintsXCTF
//
//  Created by Andy Jarombek on 8/12/17.
//  Copyright © 2017 Andy Jarombek. All rights reserved.
//

import UIKit

class PickGroupController: UIViewController {
    
    let logTag = "PickGroupViewController: "
    
    @IBOutlet weak var alumniButton: UIButton!
    @IBOutlet weak var womenstfButton: UIButton!
    @IBOutlet weak var menstfButton: UIButton!
    @IBOutlet weak var womensxcButton: UIButton!
    @IBOutlet weak var mensxcButton: UIButton!
    
    var mensxc = false, wmensxc = false, menstf = false,
        wmenstf = false, alumni = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("\(logTag) SignOutViewController Loaded.")
        
        // Programatically set the radiuses of all the buttons
        mensxcButton.layer.cornerRadius = 4
        womensxcButton.layer.cornerRadius = 4
        menstfButton.layer.cornerRadius = 4
        womenstfButton.layer.cornerRadius = 4
        alumniButton.layer.cornerRadius = 4
        
        mensxcButton.backgroundColor = UIColor(0xFFFFFF)
        womensxcButton.backgroundColor = UIColor(0xFFFFFF)
        menstfButton.backgroundColor = UIColor(0xFFFFFF)
        womenstfButton.backgroundColor = UIColor(0xFFFFFF)
        alumniButton.backgroundColor = UIColor(0xFFFFFF)
    }
    
    // Remove the keyboard when tapping the background
    @IBAction func backgroundTapped(_ sender: UITapGestureRecognizer) {
        view.endEditing(true)
    }
    
    // Functions for clicking group buttons.
    // Joined -> Change to Grey Background, Disable Conflicting Groups
    // Unjoined -> Change to White Background, Check for Resolved Conflicts
    
    @IBAction func mensxcSelected(_ sender: UIButton) {
        mensxc = !mensxc
        
        if (mensxc) {
            mensxcButton.backgroundColor = UIColor(0xCCCCCC)
            womensxcButton.isEnabled = false
            womenstfButton.isEnabled = false
        } else {
            mensxcButton.backgroundColor = UIColor(0xFFFFFF)
            if (!menstf) {
                womensxcButton.isEnabled = true
                womenstfButton.isEnabled = true
            }
        }
    }
    
    @IBAction func womensxcSelected(_ sender: UIButton) {
        wmensxc = !wmensxc
        
        if (wmensxc) {
            womensxcButton.backgroundColor = UIColor(0xCCCCCC)
            mensxcButton.isEnabled = false
            menstfButton.isEnabled = false
        } else {
            womensxcButton.backgroundColor = UIColor(0xFFFFFF)
            if (!wmenstf) {
                mensxcButton.isEnabled = true
                menstfButton.isEnabled = true
            }
        }
    }
    
    @IBAction func womenstfSelected(_ sender: UIButton) {
        wmenstf = !wmenstf
        
        if (wmenstf) {
            womenstfButton.backgroundColor = UIColor(0xCCCCCC)
            mensxcButton.isEnabled = false
            menstfButton.isEnabled = false
        } else {
            womensxcButton.backgroundColor = UIColor(0xFFFFFF)
            if (!wmensxc) {
                mensxcButton.isEnabled = true
                menstfButton.isEnabled = true
            }
        }
    }
    
    @IBAction func menstfSelected(_ sender: UIButton) {
        menstf = !menstf
        
        if (menstf) {
            menstfButton.backgroundColor = UIColor(0xCCCCCC)
            womensxcButton.isEnabled = false
            womenstfButton.isEnabled = false
        } else {
            menstfButton.backgroundColor = UIColor(0xFFFFFF)
            if (!mensxc) {
                womenstfButton.isEnabled = true
                womensxcButton.isEnabled = true
            }
        }
    }
    
    @IBAction func alumniSelected(_ sender: UIButton) {
        alumni = !alumni
        
        if (alumni) {
            alumniButton.backgroundColor = UIColor(0xCCCCCC)
        } else {
            alumniButton.backgroundColor = UIColor(0xFFFFFF)
        }
    }
    
    @IBAction func pickGroups(_ sender: UIButton) {
        /*APIClient.userPutRequest(withUsername: username, andUser: user) {
            (User) -> Void in
        }*/
    }
}
