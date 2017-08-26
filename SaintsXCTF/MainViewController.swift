//
//  MainViewController.swift
//  SaintsXCTF
//
//  Created by Andy Jarombek on 7/3/17.
//  Copyright © 2017 Andy Jarombek. All rights reserved.
//

import UIKit
import os.log

class MainViewController: UIViewController, UICollectionViewDelegateFlowLayout {
    
    let logTag = OSLog(subsystem: "SaintsXCTF.App.MainViewController", category: "MainViewController")
    
    @IBOutlet weak var logCollectionView: UICollectionView!
    
    let logDataSource = LogDataSource()
    var finished = false
    
    let paramType = "all"
    let sortParam = "all"
    let limit = 10
    var offset = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        os_log("MainViewController Loaded.", log: logTag, type: .debug)
        
        
        
        // Set up the datasource for the log collectionview and get the newest 10 logs
        logCollectionView.dataSource = logDataSource
        load()
    }
    
    // Remove the keyboard when tapping the background
    @IBAction func backgroundTapped(_ sender: UITapGestureRecognizer) {
        view.endEditing(true)
    }
    
    func load() {
        logDataSource.load(withParamType: paramType, sortParam: sortParam, limit: limit, andOffset: offset) {
            (done) -> Void in
            
            // If there are no more logs to load, remove the activity indicator and
            // stop trying to load more logs
            if (done) {
                self.finished = done
            }
            
            self.logCollectionView.reloadSections(IndexSet(integer: 0))
        }
        offset += 10
    }
    
    // Set the width and height of the collection view item
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        let height = 100
        let width = collectionView.bounds.size.width - 10
        return CGSize(width: Int(width), height: height)
    }
}
