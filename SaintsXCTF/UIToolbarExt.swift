//
//  UIToolbarExt.swift
//  SaintsXCTF
//
//  Created by Andy Jarombek on 9/17/17.
//  Copyright © 2017 Andy Jarombek. All rights reserved.
//

import UIKit

/**
 Build an extension on UIToolbar.
 */
extension UIToolbar {
    
    /**
     Make a toolbar for a picker that has a 'Done' button.
     - parameters:
     - selector: the name of a method to call when the 'Done' button is clicked
     */
    func PickerToolbar(selector: Selector) -> UIToolbar {
        
        let toolbar = UIToolbar()
        
        toolbar.barStyle = UIBarStyle.default
        toolbar.isTranslucent = true
        toolbar.tintColor = UIColor.black
        toolbar.sizeToFit()
        
        let doneButton = UIBarButtonItem(title: "Done", style: UIBarButtonItem.Style.plain,
                                         target: self, action: selector)
        let spaceButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.flexibleSpace,
                                          target: nil, action: nil)
        
        toolbar.setItems([spaceButton, doneButton], animated: false)
        toolbar.isUserInteractionEnabled = true
        
        return toolbar
    }
}
