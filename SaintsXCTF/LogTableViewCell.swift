//
//  LogTableViewCell.swift
//  SaintsXCTF
//
//  Created by Andy Jarombek on 8/26/17.
//  Copyright © 2017 Andy Jarombek. All rights reserved.
//

import UIKit

class LogTableViewCell: UITableViewCell {
    
    @IBOutlet weak var userLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var typeLabel: UILabel!
    @IBOutlet weak var locationLabel: UILabel!
    @IBOutlet weak var distanceLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var commentField: UITextField!
    
    // Add padding to the cell
    override var frame: CGRect {
        get {
            return super.frame
        }
        set {
            var frame = newValue
            frame.origin.x += 2
            frame.size.width -= 2
            
            frame.origin.y += 2
            frame.size.height -= 2
            
            super.frame = frame
        }
    }
    
    // Set the style of the cell with a background color determined by the log feel
    func setStyle(withFeel feel: Int) {
        self.layer.borderWidth = 2
        self.layer.borderColor = UIColor(0xAAAAAA).cgColor
        self.layer.cornerRadius = 1
        self.backgroundColor = UIColor(Constants.getFeelColor(feel))
    }
}
