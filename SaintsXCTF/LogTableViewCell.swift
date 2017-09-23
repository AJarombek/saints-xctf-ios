//
//  LogTableViewCell.swift
//  SaintsXCTF
//
//  Created by Andy Jarombek on 8/26/17.
//  Copyright © 2017 Andy Jarombek. All rights reserved.
//

import UIKit

class LogTableViewCell: UITableViewCell {
    
    @IBOutlet weak var userLabel: UITextView!
    @IBOutlet weak var dateLabel: UITextView!
    @IBOutlet weak var nameLabel: UITextView!
    @IBOutlet weak var typeLabel: UITextView!
    @IBOutlet weak var descriptionLabel: UITextView!
    @IBOutlet weak var commentsButton: UIButton!
    
    // Add padding to the cell
    override var frame: CGRect {
        get {
            return super.frame
        }
        set {
            var frame = newValue
            frame.origin.x += 2
            frame.size.width -= 4
            
            frame.origin.y += 2
            frame.size.height -= 4
            
            super.frame = frame
        }
    }
    
    // Called when the cell is about to be reused.  Reset all of the text fields
    override func prepareForReuse() {
        super.prepareForReuse()
        
        userLabel.text = ""
        dateLabel.text = ""
        nameLabel.text = ""
        typeLabel.text = ""
        descriptionLabel.text = ""
    }
    
    // Set the style of the cell with a background color determined by the log feel
    func setStyle(withFeel feel: Int) {
        self.layer.borderWidth = 2
        self.layer.borderColor = UIColor(0xAAAAAA).cgColor
        self.layer.cornerRadius = 1
        self.backgroundColor = UIColor(Constants.getFeelColor(feel - 1))
    }
}
