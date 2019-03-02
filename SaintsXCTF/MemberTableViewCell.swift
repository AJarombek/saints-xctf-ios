//
//  MemberTableViewCell.swift
//  SaintsXCTF
//
//  Created by Andy Jarombek on 10/12/17.
//  Copyright © 2017 Andy Jarombek. All rights reserved.
//

import UIKit

/**
 Class representing a cell in the member table view.  Displays a memebers name and join date.
 - Important:
 ## Extends the following class:
 - UITableViewCell: provides methods for managing a table view cell
 */
class MemberTableViewCell: UITableViewCell {
    
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var memberSinceLabel: UILabel!
    
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
    
    /**
     Called when the cell is about to be reused.  Reset all of the text fields
     */
    override func prepareForReuse() {
        super.prepareForReuse()
        
        nameLabel.text = ""
        memberSinceLabel.text = ""
    }
    
    /**
     Set the style of the cell with a gray background color
     */
    func setStyle() {
        self.layer.borderWidth = 1
        self.layer.borderColor = UIColor(0xAAAAAA).cgColor
        self.layer.cornerRadius = 1
        self.backgroundColor = UIColor(Constants.getFeelColor(5))
    }
}
