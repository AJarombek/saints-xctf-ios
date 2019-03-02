//
//  LeaderboardTableViewCell.swift
//  SaintsXCTF
//
//  Created by Andy Jarombek on 10/8/17.
//  Copyright © 2017 Andy Jarombek. All rights reserved.
//

import UIKit

/**
 Class controlling logic for a cell in the group leaderboard.
 - Important:
 ## Extends the following class:
 - UITableViewCell: provides methods for a cell in a table view
 */
class LeaderboardTableViewCell: UITableViewCell {
    
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var distanceLabel: UILabel!
    
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
        distanceLabel.text = ""
    }
    
    /**
     Set the style of the cell with a background color determined by the log feel
     */
    func setStyle() {
        self.layer.borderWidth = 2
        self.layer.borderColor = UIColor(0xAAAAAA).cgColor
        self.layer.cornerRadius = 1
        self.backgroundColor = UIColor(Constants.getFeelColor(5))
    }
}
