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
    }
    
    // Remove the keyboard when tapping the background
    @IBAction func backgroundTapped(_ sender: UITapGestureRecognizer) {
        view.endEditing(true)
    }
    
    @IBAction func mensxcSelected(_ sender: UIButton) {
        mensxc = !mensxc
    }
    
    @IBAction func womensxcSelected(_ sender: UIButton) {
        wmensxc = !wmensxc
    }
    
    @IBAction func womenstfSelected(_ sender: UIButton) {
        wmenstf = !wmenstf
    }
    
    @IBAction func menstfSelected(_ sender: UIButton) {
        menstf = !menstf
    }
    
    @IBAction func alumniSelected(_ sender: UIButton) {
        alumni = !alumni
    }
    
    @IBAction func pickGroups(_ sender: UIButton) {
        
    }
}
