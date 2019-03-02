//
//  CommentTableViewCell.swift
//  SaintsXCTF
//
//  Created by Andy Jarombek on 8/31/17.
//  Copyright © 2017 Andy Jarombek. All rights reserved.
//

import UIKit

class CommentTableViewCell: UITableViewCell {
    
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var contentLabel: UITextView!
    
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
        
        contentLabel.text = ""
        dateLabel.text = ""
        nameLabel.text = ""
    }
}
