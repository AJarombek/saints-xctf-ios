//
//  SortView.swift
//  SaintsXCTF
//
//  Created by Andy Jarombek on 10/9/17.
//  Copyright © 2017 Andy Jarombek. All rights reserved.
//

import UIKit

/**
 A custom UIView that contains the sort parameters for different log statistics
 */
class SortView: UIView {
    
    @IBOutlet weak var runButton: UIButton!
    @IBOutlet weak var bikeButton: UIButton!
    @IBOutlet weak var swimButton: UIButton!
    @IBOutlet weak var otherButton: UIButton!
    @IBOutlet weak var rangeSortField: UITextField!

    /**
     Create a new SortView based on an interface builder Nib file
     - returns: an instance of SortView
     */
    class func instantiateFromNib() -> SortView {
        return UINib(nibName: "SortView", bundle: nil).instantiate(withOwner: nil, options: nil)[0] as! SortView
    }
    
    /**
     Stop displaying the visible picker for the range sort field
     */
    @objc
    func dismissPicker() {
        // Force the rangeSortField to resign as first responder
        self.endEditing(true)
        print("remove")
    }
}
