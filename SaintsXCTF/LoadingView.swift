//
//  LoadingView.swift
//  SaintsXCTF
//
//  Created by Andy Jarombek on 10/1/17.
//  Copyright © 2017 Andy Jarombek. All rights reserved.
//

import UIKit
import os.log

/**
 Class when creates a storyboard view.  This view displays a loading spinner
 - Important:
 ## Extends the following class:
 - UIView: provides behavior for a generic rectangular view on a screen
 */
@IBDesignable
class LoadingView: UIView {
    
    static let logTag = OSLog(subsystem: "SaintsXCTF.App.LoadingView", category: "LoadingView")
    
    /**
     Initializer which sets up the view
     - parameters:
     - frame: the frame rectangle for the view
     */
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    /**
     Initializer which sets up the view and retrieves peristed data
     - parameters:
     - aDecoder: retrieves persisted data for the application
     */
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
    }
    
    /**
     Creates the spinner and sets the background color for the view
     */
    func setup() {
        os_log("Loading View Initialized", log: Utils.logTag, type: .debug)
        
        // Set the background and a spinner that is centered in the view
        self.backgroundColor = UIColor(0xBBBBBB, a: 0.5)
        
        let spinner = UIActivityIndicatorView(style: .large)
        spinner.frame = CGRect(x: 0, y: 0, width: 50, height: 50)
        spinner.center = self.center
        spinner.startAnimating()
        spinner.alpha = 0.5
        self.addSubview(spinner)
    }
}
