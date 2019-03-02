//
//  LogViewController.swift
//  SaintsXCTF
//
//  Created by Andy Jarombek on 8/12/17.
//  Copyright © 2017 Andy Jarombek. All rights reserved.
//

import UIKit
import os.log
import PopupDialog

/**
 Class controlling logic for the view displaying exercise logs.
 - Important:
 ## Implements the following class:
 - UIViewController: provides behavior shared between all classes that manage a view
 ## Implements the following protocols:
 - UITextViewDelegate: methods that change the behavior of a text view being edited
 - UIPickerViewDelegate: required class for a picker view to construct itself
 - UIPickerViewDataSource: provides the picker view with content
 */
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
    
    var user: User!
    
    var editingLog: Bool = false
    var logPassed: Log? = nil
    var indexPassed: Int? = nil
    
    let distanceRegex = "^[0-9]{0,3}(\\.[0-9]{1,2})?$"
    let minuteRegex = "^[0-9]{1,5}$"
    let secondRegex = "^[0-9]{1,2}$"
    let userTagRegex = "@[a-zA-Z0-9]+"
    
    var currentDate = "09/16/2017"
    
    let logTypes = ["Run", "Bike", "Swim", "Other"]
    let logMetrics = ["Miles", "Kilometers", "Meters"]
    
    let logTag = OSLog(subsystem: "SaintsXCTF.App.LogViewController", category: "LogViewController")
    
    /**
     Invoked when the LogViewController loads
     */
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
        
        submitButton.setTitleColor(UIColor(0x990000), for: .normal)
        cancelButton.setTitleColor(UIColor(0xAAAAAA), for: .normal)
        
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
        
        // Hide the colored cursor when the date, type, and metric is selected
        dateField.tintColor = .clear
        typeField.tintColor = .clear
        metricField.tintColor = .clear
        
        // Create a view to hold the date picker and the done button
        let inputView = UIView(frame: CGRect(x: 0, y: 0, width: self.view.frame.width, height: 240))
        
        // Create and add the date picker
        datePickerView = UIDatePicker(frame: CGRect(x: 0, y: 40, width: 0, height: 0))
        datePickerView.datePickerMode = UIDatePicker.Mode.date
        datePickerView.addTarget(self, action: #selector(handleDatePicker(_:)), for: UIControl.Event.valueChanged)
        
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
        
        // Set the current date to be displayed in the dateField
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MM/dd/yyyy"
        currentDate = dateFormatter.string(from: Date())
        dateField.text = currentDate
        
        // Set the user for the created logs to the signed in user
        user = SignedInUser.user
        
        // Check if we are editing an existing log.  If so, fill in the existing fields
        if editingLog {
            setFields()
        }
    }
    
    /**
     When the feel stepper is clicked, display the feel description
     - parameters:
     - sender: the stepper view that invoked this function (feelStepper)
     */
    @IBAction func feelChanged(_ sender: UIStepper) {
        let value = Int(sender.value) - 1
        feelDescriptionField.text = Constants.getFeelDescription(value)
        view.layer.backgroundColor = UIColor(Constants.getFeelColor(value)).cgColor
    }
    
    /**
     Stop displaying the visible picker
     */
    @objc func dismissPicker() {
        view.endEditing(true)
    }
    
    /**
     Show the date in the date picker in the text field
     - parameters:
     - sender: the date picker view that invoked this function (datePickerView)
     */
    @objc func handleDatePicker(_ sender: UIDatePicker) {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MM/dd/yyyy"
        dateField.text = dateFormatter.string(from: sender.date)
    }
    
    /**
     When beginning to edit the textview, remove the placeholder and prepare view for user input
     - parameters:
     - textView: the text view that is in focus (descriptionField)
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
     - textView: the text view that was removed from focus (descriptionField)
     */
    func textViewDidEndEditing(_ textView: UITextView) {
        if textView.text.isEmpty {
            textView.text = "Description"
            textView.textColor = UIColor.lightGray
        }
    }
    
    /**
     Return the number of components in the UIPicker
     - parameters:
     - pickerView: either the type or metric picker views
     */
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    /**
     Return the number of rows in the given UIPicker
     - parameters:
     - pickerView: either the type or metric picker views
     - component: unused
     */
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if pickerView == typePicker {
            return logTypes.count
        } else if pickerView == metricPicker {
            return logMetrics.count
        } else {
            return 0
        }
    }
    
    /**
     Return the title for the row that is to be shown in the UIPicker
     - parameters:
     - pickerView: either the type or metric picker views
     - row: the integer index for a row in the picker view
     - component: unused
     */
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        if pickerView == typePicker {
            return logTypes[row]
        } else if pickerView == metricPicker {
            return logMetrics[row]
        } else {
            return nil
        }
    }
    
    /**
     Dislay the picked value from the UIPicker
     - parameters:
     - pickerView: either the type or metric picker views
     - row: the integer index for a row selected in the picker view
     - component: unused
     */
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if pickerView == typePicker {
            typeField.text = logTypes[row]
        } else if pickerView == metricPicker {
            metricField.text = logMetrics[row]
        }
    }
    
    /**
     If we are editing an existing log, set all the fields from the existing log
     */
    func setFields() {
        nameField.text = logPassed?.name ?? ""
        locationField.text = logPassed?.location ?? ""
        
        if let date: String = logPassed?.date {
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "yyyy-MM-dd"
            let date = dateFormatter.date(from: date)!
            dateFormatter.dateFormat = "MM/dd/yyyy"
            let dateString = dateFormatter.string(from: date)
            dateField.text = dateString
        }
        
        typeField.text = logPassed?.type?.capitalizingFirstLetter() ?? ""
        distanceField.text = "\(logPassed?.distance ?? 0)"
        metricField.text = logPassed?.metric.capitalizingFirstLetter() ?? ""
        
        minutesField.text = ""
        secondsField.text = ""
        
        let feelValue: Int = (logPassed?.feel)! - 1
        feelStepper.value = Double(feelValue + 1)
        feelDescriptionField.text = Constants.getFeelDescription(Int(feelValue))
        view.layer.backgroundColor = UIColor(Constants.getFeelColor(Int(feelValue))).cgColor
        
        let descriptionValue: String = logPassed?.log_description ?? ""
        if !descriptionValue.isEmpty {
            descriptionField.text = descriptionValue
            descriptionField.textColor = UIColor.black
        } else {
            descriptionField.text = "Description"
            descriptionField.textColor = UIColor.lightGray
        }
        
        errorField.text = ""
    }
    
    /**
     Reset all the fields in the log input to the default values
     */
    func resetFields() {
        nameField.text = ""
        locationField.text = ""
        dateField.text = currentDate
        typeField.text = "Run"
        distanceField.text = ""
        metricField.text = "Miles"
        minutesField.text = ""
        secondsField.text = ""
        feelStepper.value = 6
        feelDescriptionField.text = Constants.getFeelDescription(5)
        view.layer.backgroundColor = UIColor(Constants.getFeelColor(5)).cgColor
        descriptionField.text = "Description"
        descriptionField.textColor = UIColor.lightGray
        descriptionField.resignFirstResponder()
        errorField.text = ""
    }
    
    /**
     When the user clicks cancel, reset all the fields to their default values
     - parameters:
     - sender: the cancel button (cancelButton)
     */
    @IBAction func cancelLog(_ sender: UIButton) {
        resetFields()
    }
    
    /**
     When the log is submitted, perform validation and if valid send to the API for creation.
     Otherwise display an error message.
     - parameters:
     - sender: the submit button (submitButton)
     */
    @IBAction func submitLog(_ sender: UIButton) {
        
        // Get the values from all of the textFields
        if let name = nameField.text?.trimmingCharacters(in: .whitespaces),
            let location = locationField.text?.trimmingCharacters(in: .whitespaces),
            let dateString = dateField.text?.trimmingCharacters(in: .whitespaces),
            let type = typeField.text?.trimmingCharacters(in: .whitespaces),
            var distance = distanceField.text?.trimmingCharacters(in: .whitespaces),
            let metric = metricField.text?.trimmingCharacters(in: .whitespaces),
            var minutes = minutesField.text?.trimmingCharacters(in: .whitespaces),
            var seconds = secondsField.text?.trimmingCharacters(in: .whitespaces),
            var description = descriptionField.text?.trimmingCharacters(in: .whitespaces) {
            
            // If the description field holds a placeholder, return an empty description
            if descriptionField.textColor == UIColor.lightGray {
                description = ""
            }
            
            // Name is a required field
            if name.isEmpty {
                errorField.text = "A Log Name Must Be Entered"
                nameField.changeStyle(.error)
                return
            } else {
                nameField.changeStyle(.none)
            }
            
            // Make sure the date isnt in the future
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "MM/dd/yyyy"
            let date = dateFormatter.date(from: dateString)!
            
            if date > Date() {
                errorField.text = "Date Cannot Be In the Future"
                dateField.changeStyle(.error)
                return
            } else {
                dateField.changeStyle(.none)
            }
            
            // And make sure the date isnt before 2016
            let oldestDate = dateFormatter.date(from: "01/01/2016")!
            
            if date < oldestDate {
                errorField.text = "Date Must be After Jan. 1st, 2016"
                dateField.changeStyle(.error)
                return
            } else {
                dateField.changeStyle(.none)
            }
            
            // One of the following must be entered: minutes, seconds, distance
            if distance.isEmpty && seconds.isEmpty && minutes.isEmpty {
                errorField.text = "No Distance or Time Entered"
                distanceField.changeStyle(.error)
                minutesField.changeStyle(.error)
                secondsField.changeStyle(.error)
                return
            }
            
            var distanceFilledOut = false
            
            // Make sure the distance is properly inputted
            if distance.range(of: distanceRegex, options: .regularExpression) == nil {
                
                if distance.isEmpty {
                    distanceField.changeStyle(.none)
                    distance = "0"
                } else {
                    // If the distance doesnt match + isnt empty and the minutes and seconds aren't filled in
                    // there is an error: and invalid distance was entered
                    errorField.text = "Invalid Distance Entered"
                    distanceField.changeStyle(.error)
                    return
                }
            } else {
                distanceFilledOut = true
            }
            
            // Make sure the minutes are properly inputted
            if minutes.range(of: minuteRegex, options: .regularExpression) == nil {
                    
                if minutes.isEmpty {
                    minutesField.changeStyle(.none)
                    minutes = "0"
                } else {
                        
                    // If the minutes doesnt match + isnt empty there is an error
                    errorField.text = "Invalid Minutes Entered"
                    minutesField.changeStyle(.error)
                    return
                }
                    
            } else {
                if seconds.range(of: secondRegex, options: .regularExpression) == nil {
                    // If the minutes are entered but seconds arent, there is an error
                    errorField.text = "Seconds Must Be Entered"
                    secondsField.changeStyle(.error)
                    return
                } else {
                    minutesField.changeStyle(.none)
                }
            }
            
            // Make sure the seconds are properly inputted
            if seconds.range(of: secondRegex, options: .regularExpression) == nil {
                
                if seconds.isEmpty {
                    
                    if distanceFilledOut {
                        secondsField.changeStyle(.none)
                        seconds = "0"
                    } else {
                        
                        // If the seconds dont match + isnt empty + dsitance isnt filled out there is an error
                        errorField.text = "Time or Distance Must Be Entered"
                        distanceField.changeStyle(.error)
                        minutesField.changeStyle(.error)
                        secondsField.changeStyle(.error)
                        return
                    }
                    
                } else {
                    // If the seconds dont match + isnt empty there is an error
                    errorField.text = "Invalid Seconds Must Be Entered"
                    secondsField.changeStyle(.error)
                    return
                }
                
            } else {
                secondsField.changeStyle(.none)
            }
            
            // Get the feel from the stepper
            let feel = Int(feelStepper.value)
            
            // Format the Date for MySQL
            dateFormatter.dateFormat = "yyyy-MM-dd"
            let formattedDate = dateFormatter.string(from: date)
            
            // Get the time from minutes and seconds
            let time = Utils.toTime(withMinutes: minutes, andSeconds: seconds)
            
            // Get the mileage from the distance and metric
            let miles = Utils.toMiles(fromMetric: metric, withDistance: distance)
            let milesString = "\(miles)"
            
            // Get the pace from the miles and time
            let pace = Utils.getMilePace(withMiles: milesString, andMinutes: minutes, andSeconds: seconds)
            
            // If you reach this point, everything is in a valid state
            // Now we want to build the Log obejct to be sent off to the API
            let log = Log()
            log.name = name
            log.username = user.username
            log.first = user.first
            log.last = user.last
            log.location = location
            log.date = formattedDate
            log.type = type.lowercased()
            log.distance = Double(distance)
            log.miles = Double(milesString)
            log.pace = pace
            log.metric = metric.lowercased()
            log.time = time
            log.feel = feel
            log.log_description = description
            
            os_log("Log Passed Validation: %@", log: logTag, type: .debug, log.description)
            
            if !self.editingLog {
                
                // Submit the new log to the API
                APIClient.logPostRequest(withLog: log) {
                    (newlog) -> Void in
                    
                    os_log("New Log Submitted to API.", log: self.logTag, type: .debug)
                    
                    // Build the popup dialog to be displayed
                    let title = "New Log Created"
                    
                    let button = DefaultButton(title: "Continue") {
                        self.resetFields()
                        
                        self.editingLog = false
                        self.indexPassed = nil
                        self.logPassed = nil
                        os_log("Continue and Reset Log Inputs.", log: self.logTag, type: .debug)
                    }
                    
                    let popup = PopupDialog(title: title, message: nil)
                    popup.addButton(button)
                    
                    self.present(popup, animated: true, completion: nil)
                }
            } else {
                
                log.log_id = logPassed?.log_id
                
                // Submit the edited log to the API
                APIClient.logPutRequest(withLogID: log.log_id!, andLog: log) {
                    (newlog) -> Void in
                    
                    os_log("Updated Log Submitted to API.", log: self.logTag, type: .debug)
                    
                    // Build the popup dialog to be displayed
                    let title = "Existing Log Updated"
                    
                    let button = DefaultButton(title: "Continue") {
                        self.resetFields()
                        
                        self.editingLog = false
                        self.indexPassed = nil
                        self.logPassed = nil
                        os_log("Continue and Reset Log Inputs.", log: self.logTag, type: .debug)
                    }
                    
                    let popup = PopupDialog(title: title, message: nil)
                    popup.addButton(button)
                    
                    self.present(popup, animated: true, completion: nil)
                }
            }
            
        } else {
            errorField.text = "An Unexpected Error Occurred"
            return
        }
    }
    
    /**
     Set a limit on the description input.
     - parameters:
     - textView: the description text view (descriptionField)
     - range: unused
     - text: the text input from the user
     */
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange,
                  replacementText text: String) -> Bool {
        let str = textView.text + text
        
        if str.count <= 1000 {
            return true
        }
        
        let start = str.startIndex
        let end = str.index(str.startIndex, offsetBy: 1000)
        textView.text = String(str[start...end])
        return false
    }
}
