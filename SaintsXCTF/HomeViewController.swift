//
//  HomeViewController.swift
//  SaintsXCTF
//
//  Created by Andy Jarombek on 3/28/17.
//  Copyright © 2017 Andy Jarombek. All rights reserved.
//

import UIKit

class HomeViewController: UIViewController {
    
    @IBOutlet var backgroundImage: UIImageView!
    @IBOutlet var logIn: UIButton!
    @IBOutlet var signUp: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.backgroundImage.image = #imageLiteral(resourceName: "Background")
    }
}
