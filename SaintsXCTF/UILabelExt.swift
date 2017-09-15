//
//  UILabelExt.swift
//  SaintsXCTF
//
//  Created by Andy Jarombek on 9/14/17.
//  Copyright © 2017 Andy Jarombek. All rights reserved.
//

import UIKit

extension UILabel {
    
    // Open acess level is accessable and overridable outside of the defining module
    override open func draw(_ rect: CGRect) {
        
        let insets = UIEdgeInsets(top: 2, left: 0, bottom: 2, right: 0)
        super.draw(UIEdgeInsetsInsetRect(rect, insets))
    }
}
