//
//  ReportViewController.swift
//  SaintsXCTF
//
//  Created by Andy Jarombek on 3/2/19.
//  Copyright © 2019 Andy Jarombek. All rights reserved.
//

import UIKit
import os.log
import PopupDialog

/**
 Controller for filing reports to the application administrator.
 - Important:
 ## Extends the following class:
 - UIViewController: provides behavior shared between all classes that manage a view
 
 ## Implements the following protocols:
 - UITextViewDelegate: methods that change the behavior of a text view being edited
 */
class ReportViewController: UIViewController, UITextViewDelegate {
    
    let logTag = OSLog(subsystem: "SaintsXCTF.App.ReportViewController",
                       category: "ReportViewController")
    
    @IBOutlet weak var reportTextView: UITextView!
    @IBOutlet weak var submitButton: UIButton!
    
    var user: User = User()
    var submittingReport: Bool = false
    
    /**
     Invoked when the ReportViewController loads
     */
    override func viewDidLoad() {
        super.viewDidLoad()
        os_log("ReportViewController Loaded.", log: logTag, type: .debug)
        
        // Set the navigation bar back button to a custom image
        navigationController?.navigationBar.backIndicatorImage = UIImage(named: "back")
        navigationController?.navigationBar.backIndicatorTransitionMaskImage = UIImage(named: "back")
        navigationController?.navigationBar.tintColor = UIColor(0xFFFFFF)
        navigationItem.title = "File Report"
        
        navigationItem.backBarButtonItem = UIBarButtonItem(title: " ", style:
            UIBarButtonItem.Style.plain, target: nil, action: nil)
        
        reportTextView.standardStyle()
        submitButton.setTitleColor(UIColor(0x990000), for: .normal)
        
        reportTextView.text = "Send report to admin <andrew@jarombek.com>"
        reportTextView.textColor = UIColor.lightGray
        reportTextView.delegate = self
    }
    
    /**
     Submit a report to the application admin
     - parameters:
     - sender: the button that invoked this function (submitButton)
     */
    @IBAction func submitReport(_ sender: UIButton) {
        os_log("Submitting Report.", log: logTag, type: .debug)
        
        // Build the popup dialog to be displayed
        let title = "Report Submitted"
        
        let button = DefaultButton(title: "Continue") {
            self.resetField()
            
            self.submittingReport = false
            os_log("Continue and Reset Report Form.", log: self.logTag, type: .debug)
        }
        
        let popup = PopupDialog(title: title, message: nil)
        popup.addButton(button)
        
        self.present(popup, animated: true, completion: nil)
    }
    
    /**
     Reset the report form to its default value
     */
    func resetField() {
        reportTextView.text = "Send report to admin <andrew@jarombek.com>"
        reportTextView.textColor = UIColor.lightGray
    }
    
    /**
     When beginning to edit the textview, remove the placeholder and prepare view for user input
     - parameters:
     - textView: the text view that is in focus (reportTextView)
     */
    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView.textColor == UIColor.lightGray {
            textView.text = ""
            textView.textColor = UIColor.black
        }
    }
    
    /**
     When done editing textview, if the contents are empty restore the placeholder
     - parameters:
     - textView: the text view that was removed from focus (reportTextView)
     */
    func textViewDidEndEditing(_ textView: UITextView) {
        if textView.text.isEmpty {
            textView.text = "Send report to admin <andrew@jarombek.com>"
            textView.textColor = UIColor.lightGray
        }
    }
}
