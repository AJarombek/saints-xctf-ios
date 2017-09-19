//
//  LogViewController.swift
//  SaintsXCTF
//
//  Created by Andy Jarombek on 8/12/17.
//  Copyright © 2017 Andy Jarombek. All rights reserved.
//

import UIKit
import os.log

class LogViewController: UIViewController, UITextViewDelegate, UIPickerViewDelegate, UIPickerViewDataSource {
    
    @IBOutlet weak var nameField: UITextField!
    @IBOutlet weak var locationField: UITextField!
    @IBOutlet weak var dateField: UITextField!
    @IBOutlet weak var typeField: UITextField!
    @IBOutlet weak var distanceField: UITextField!
    @IBOutlet weak var metricField: UITextField!
    @IBOutlet weak var minutesField: UITextField!
    @IBOutlet weak var secondsField: UITextField!
    @IBOutlet weak var feelStepper: UIStepper!
    @IBOutlet weak var feelDescriptionField: UITextField!
    @IBOutlet weak var descriptionField: UITextView!
    @IBOutlet weak var errorField: UITextView!
    @IBOutlet weak var submitButton: UIButton!
    @IBOutlet weak var cancelButton: UIButton!
    
    var typePicker: UIPickerView!
    var metricPicker: UIPickerView!
    var datePickerView: UIDatePicker!
    
    let distanceRegex = "^[0-9]{0,3}(\\.[0-9]{1,2})?$"
    let minuteRegex = "^[0-9]{1,5}$"
    let secondRegex = "^[0-9]{1,2}$"
    let userTagRegex = "@[a-zA-Z0-9]+"
    
    let currentDate = "08/16/2017"
    
    let logTypes = ["Run", "Bike", "Swim", "Other"]
    let logMetrics = ["Miles", "Kilometers", "Meters"]
    
    let logTag = OSLog(subsystem: "SaintsXCTF.App.LogViewController", category: "LogViewController")
    
    override func viewDidLoad() {
        super.viewDidLoad()
        os_log("LogViewController Loaded.", log: logTag, type: .debug)
        
        view.layer.backgroundColor = UIColor(Constants.getFeelColor(5)).cgColor
        
        descriptionField.text = "Description"
        descriptionField.textColor = UIColor.lightGray
        descriptionField.delegate = self
        
        // Add Styling to the log fields
        nameField.standardStyle()
        locationField.standardStyle()
        dateField.standardStyle()
        typeField.standardStyle()
        distanceField.standardStyle()
        metricField.standardStyle()
        minutesField.standardStyle()
        secondsField.standardStyle()
        
        feelStepper.tintColor = UIColor(0xCCCCCC)
        feelStepper.backgroundColor = UIColor.white
        feelStepper.layer.cornerRadius = 4
        
        descriptionField.layer.borderWidth = 2
        descriptionField.layer.borderColor = UIColor(0xCCCCCC).cgColor
        descriptionField.layer.cornerRadius = 1
        descriptionField.backgroundColor = UIColor.white
        
        // Set the settings for the log feel stepper
        feelStepper.minimumValue = 1
        feelStepper.maximumValue = 10
        feelStepper.wraps = false
        feelStepper.autorepeat = true
        feelStepper.value = 6
        
        // Create a view to hold the date picker and the done button
        let inputView = UIView(frame: CGRect(x: 0, y: 0, width: self.view.frame.width, height: 240))
        
        // Create and add the date picker
        datePickerView = UIDatePicker(frame: CGRect(x: 0, y: 40, width: 0, height: 0))
        datePickerView.datePickerMode = UIDatePickerMode.date
        datePickerView.addTarget(self, action: #selector(handleDatePicker(_:)), for: UIControlEvents.valueChanged)
        
        inputView.addSubview(datePickerView)
        dateField.inputView = inputView
        
        let toolBar = UIToolbar().PickerToolbar(selector: #selector(self.dismissPicker))
        dateField.inputAccessoryView = toolBar
        
        // Create a view to hold the type picker and the done button
        let typeInputView = UIView(frame: CGRect(x: 0, y: 0, width: self.view.frame.width, height: 240))
        
        // Set the picker view for type
        typePicker = UIPickerView(frame: CGRect(x: 0, y: 40, width: 0, height: 0))
        typePicker.delegate = self
        
        typeInputView.addSubview(typePicker)
        typeField.inputView = typePicker
        typeField.text = logTypes[0]
        
        let typeToolbar = UIToolbar().PickerToolbar(selector: #selector(self.dismissPicker))
        typeField.inputAccessoryView = typeToolbar
        
        // Create a view to hold the metric picker and the done button
        let metricInputView = UIView(frame: CGRect(x: 0, y: 0, width: self.view.frame.width, height: 240))
        
        // set the picker view for metric
        metricPicker = UIPickerView(frame: CGRect(x: 0, y: 40, width: 0, height: 0))
        metricPicker.delegate = self
        
        metricInputView.addSubview(metricPicker)
        metricField.inputView = metricPicker
        metricField.text = logMetrics[0]
        
        let metricToolbar = UIToolbar().PickerToolbar(selector: #selector(self.dismissPicker))
        metricField.inputAccessoryView = metricToolbar
    }
    
    // Remove the keyboard when tapping the background
    @IBAction func backgroundTapped(_ sender: UITapGestureRecognizer) {
        view.endEditing(true)
    }
    
    // When the feel stepper is clicked, display the feel description
    @IBAction func feelChanged(_ sender: UIStepper) {
        let value = Int(sender.value) - 1
        feelDescriptionField.text = Constants.getFeelDescription(value)
        view.layer.backgroundColor = UIColor(Constants.getFeelColor(value)).cgColor
    }
    
    // Stop displaying the visible picker
    func dismissPicker() {
        view.endEditing(true)
    }
    
    // Show the date in the date picker in the text field
    func handleDatePicker(_ sender: UIDatePicker) {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MM/dd/yyyy"
        dateField.text = dateFormatter.string(from: sender.date)
    }
    
    // When the user clicks cancel, reset all the fields to their default values
    @IBAction func cancelLog(_ sender: UIButton) {
        nameField.text = ""
        locationField.text = ""
        dateField.text = ""
        typeField.text = "Run"
        distanceField.text = ""
        metricField.text = "Miles"
        minutesField.text = ""
        secondsField.text = ""
        descriptionField.text = "Description"
        descriptionField.textColor = UIColor.lightGray
        errorField.text = ""
    }
    
    // When beginning to edit the textview, remove the placeholder and prepare view for user input
    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView.textColor == UIColor.lightGray {
            textView.text = ""
            textView.textColor = UIColor.black
        }
    }
    
    // When done editing textview, if the contents are empty restore the placeholder
    func textViewDidEndEditing(_ textView: UITextView) {
        if textView.text.isEmpty {
            textView.text = "Description"
            textView.textColor = UIColor.lightGray
        }
    }
    
    // Return the number of components in the UIPicker
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    // Return the number of rows in the given UIPicker
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if pickerView == typePicker {
            return logTypes.count
        } else if pickerView == metricPicker {
            return logMetrics.count
        } else {
            return 0
        }
    }
    
    // Return the title for the row that is to be shown in the UIPicker
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        if pickerView == typePicker {
            return logTypes[row]
        } else if pickerView == metricPicker {
            return logMetrics[row]
        } else {
            return nil
        }
    }
    
    // Dislay the picked value from the UIPicker
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if pickerView == typePicker {
            typeField.text = logTypes[row]
        } else if pickerView == metricPicker {
            metricField.text = logMetrics[row]
        }
    }
    
    @IBAction func submitLog(_ sender: UIButton) {
        
    }
}
