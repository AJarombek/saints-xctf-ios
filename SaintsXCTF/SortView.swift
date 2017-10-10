//
//  SortView.swift
//  SaintsXCTF
//
//  Created by Andy Jarombek on 10/9/17.
//  Copyright © 2017 Andy Jarombek. All rights reserved.
//

import UIKit

class SortView: UIView {
    
    @IBOutlet var view: UIView!
    @IBOutlet weak var runButton: UIButton!
    @IBOutlet weak var bikeButton: UIButton!
    @IBOutlet weak var swimButton: UIButton!
    @IBOutlet weak var otherButton: UIButton!
    @IBOutlet weak var rangeSortField: UITextField!

    class func instantiateFromNib() -> UIView {
        return UINib(nibName: "SortView", bundle: nil).instantiate(withOwner: nil, options: nil)[0] as! UIView
    }
}
