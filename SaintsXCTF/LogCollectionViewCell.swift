//
//  LogCollectionViewCell.swift
//  SaintsXCTF
//
//  Created by Andy Jarombek on 8/25/17.
//  Copyright © 2017 Andy Jarombek. All rights reserved.
//

import UIKit

class LogCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet var spinner: UIActivityIndicatorView!
    @IBOutlet var logUsername: UITextField!
    @IBOutlet var logName: UITextField!
    
    // Update the cell with either the log info or an activity indicator
    func update(with newlog: Log?) {
        if let log = newlog {
            spinner.stopAnimating()
            logUsername.text = log.username
            logUsername.isHidden = false
            logName.text = log.name
            logName.isHidden = false
        } else {
            spinner.startAnimating()
            logUsername.isHidden = true
            logName.isHidden = true
        }
    }
    
    // Called when the cell is first created
    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.layer.borderWidth = 2
        self.layer.borderColor = UIColor(0xCCCCCC).cgColor
        self.layer.cornerRadius = 1
        self.backgroundColor = UIColor.white
        
        update(with: nil)
    }
    
    // Called when the cell is getting reused
    override func prepareForReuse() {
        super.awakeFromNib()
        
        update(with: nil)
    }
}
