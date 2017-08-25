//
//  MainViewController.swift
//  SaintsXCTF
//
//  Created by Andy Jarombek on 7/3/17.
//  Copyright © 2017 Andy Jarombek. All rights reserved.
//

import UIKit
import os.log

class MainViewController: UIViewController {
    
    let logTag = OSLog(subsystem: "SaintsXCTF.App.MainViewController", category: "MainViewController")
    
    @IBOutlet weak var logCollectionView: UICollectionView!
    
    let logDataSource = LogDataSource()
    
    let limit = 10
    var offset = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        os_log("MainViewController Loaded.", log: logTag, type: .debug)
        
        // Set up the datasource for the log collectionview and get the newest 10 logs
        logCollectionView.dataSource = logDataSource
        logDataSource.load(withLimit: limit, andOffset: offset)
        offset += 10
    }
    
    // Remove the keyboard when tapping the background
    @IBAction func backgroundTapped(_ sender: UITapGestureRecognizer) {
        view.endEditing(true)
    }
}
