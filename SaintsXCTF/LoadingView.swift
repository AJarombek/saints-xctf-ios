//
//  LoadingView.swift
//  SaintsXCTF
//
//  Created by Andy Jarombek on 10/1/17.
//  Copyright © 2017 Andy Jarombek. All rights reserved.
//

import UIKit
import os.log

@IBDesignable
class LoadingView: UIView {
    
    static let logTag = OSLog(subsystem: "SaintsXCTF.App.LoadingView", category: "LoadingView")
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
    }
    
    func setup() {
        os_log("Loading View Initialized", log: Utils.logTag, type: .debug)
        
        // Set the background and a spinner that is centered in the view
        self.backgroundColor = UIColor(0xBBBBBB, a: 0.5)
        
        let spinner = UIActivityIndicatorView(activityIndicatorStyle: .whiteLarge)
        spinner.frame = CGRect(x: 0, y: 0, width: 50, height: 50)
        spinner.center = self.center
        spinner.startAnimating()
        spinner.alpha = 0.5
        self.addSubview(spinner)
    }
}
