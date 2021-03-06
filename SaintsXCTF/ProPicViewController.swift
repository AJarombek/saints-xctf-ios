//
//  ProPicViewController.swift
//  SaintsXCTF
//
//  Created by Andy Jarombek on 9/29/17.
//  Copyright © 2017 Andy Jarombek. All rights reserved.
//

import UIKit
import os.log
import PopupDialog

/**
 Controller for editing a users profile picture.
 - Important:
 ## Extends the following class:
 - UIViewController: provides behavior shared between all classes that manage a view
 
 ## Implements the following protocols:
 - UIGestureRecognizerDelegate: provides helper methods gor handling gestures (clicks,swipes,etc.)
 - UINavigationControllerDelegate: configure the behavior when navigating between controllers
 - UIImagePickerControllerDelegate: provides helper methods for using the image picker API
 */
class ProPicViewController: UIViewController, UIGestureRecognizerDelegate,
            UINavigationControllerDelegate, UIImagePickerControllerDelegate {
    
    let logTag = OSLog(subsystem: "SaintsXCTF.App.ProPicViewController",
                       category: "ProPicViewController")
    
    @IBOutlet weak var proPicView: UIImageView!
    @IBOutlet weak var saveButton: UIButton!
    @IBOutlet weak var cancelButton: UIButton!
    
    var user: User = User()
    var image: UIImage? = nil
    var originalPic: UIImage? = nil
    var originalBase64: String = ""
    
    /**
     Invoked when the ProPicViewController loads
     */
    override func viewDidLoad() {
        super.viewDidLoad()
        os_log("DetailsViewController Loaded.", log: logTag, type: .debug)
        
        // Set the navigation bar back button to a custom image
        navigationController?.navigationBar.backIndicatorImage = UIImage(named: "back")
        navigationController?.navigationBar.backIndicatorTransitionMaskImage = UIImage(named: "back")
        navigationController?.navigationBar.tintColor = UIColor(0xFFFFFF)
        navigationItem.title = "Edit Profile Picture"
        
        navigationItem.backBarButtonItem = UIBarButtonItem(title: " ", style:
            UIBarButtonItem.Style.plain, target: nil, action: nil)
        
        proPicView.layer.borderWidth = 2
        proPicView.layer.borderColor = UIColor(0xCCCCCC).cgColor
        proPicView.layer.cornerRadius = 1
        
        saveButton.setTitleColor(UIColor(0x990000), for: .normal)
        cancelButton.setTitleColor(UIColor(0xAAAAAA), for: .normal)
        
        // If the user has a profile picture, display it
        if let profilePictureName = user.profilepic_name {
            
            let url = URL(string: "\(UassetClient.baseUrl)/profile/\(user.username!)/\(profilePictureName)")
            
            DispatchQueue.global().async {
                let data = try? Data(contentsOf: url!)
                
                DispatchQueue.main.async {
                    // Display the profile picture image
                    self.proPicView.image = UIImage(data: data!)
                }
            }
        }
        
        // Set click listener to the profile picture view to upload a picture
        let propicClick = UITapGestureRecognizer(target: self, action: #selector(self.editProfilePicture(_:)))
        propicClick.delegate = self
        proPicView.addGestureRecognizer(propicClick)
    }
    
    /**
     Edit the users profile picture
     - parameters:
     - sender: the view that invoked this function (proPicView)
     */
    @objc func editProfilePicture(_ sender: UIView) {
        os_log("Editing Profile Picture", log: logTag, type: .debug)
        
        let imagePicker = UIImagePickerController()
        imagePicker.sourceType = .photoLibrary
        imagePicker.delegate = self
        
        self.present(imagePicker, animated: true, completion: nil)
    }
    
    /**
     Called when an image is picked from the photo library
     - parameters:
     - picker: the controller managing the image picker
     - info: contains the original picture and edit picture that were picked
     */
    func imagePickerController(_ picker: UIImagePickerController,
                               didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        // Local variable inserted by Swift 4.2 migrator.
        let info = convertFromUIImagePickerControllerInfoKeyDictionary(info)

        // Get the picked image from info dictionary
        image = info[convertFromUIImagePickerControllerInfoKey(UIImagePickerController.InfoKey.originalImage)] as? UIImage
        
        proPicView.image = image
        dismiss(animated: true, completion: nil)
    }
    
    /**
     If a new image is uploaded, save it to the API and go back to the edit profile page
     - parameters:
     - sender: the view that invoked this function (saveButton)
     */
    @IBAction func saveProPic(_ sender: UIButton) {
        os_log("Save the Profile Picture", log: logTag, type: .debug)
        
        if let newImage: UIImage = image {
            
            // Add a loading overlay to the profile picture on upload
            var overlay: UIView?
            overlay = LoadingView(frame: CGRect(x: 0, y: 0, width: 150, height: 150))
            proPicView.addSubview(overlay!)
            
            // Temporarily disable the save and cancel buttons
            saveButton.isEnabled = false
            cancelButton.isEnabled = false
            
            let imageData: Data = newImage.pngData()!
            var proPicBase64: String = imageData.base64EncodedString()
            
            proPicBase64 = proPicBase64.replacingOccurrences(of: "\n", with: "")
            
            user.profilepic = "data:image/jpeg;base64," + proPicBase64
            
            APIClient.userPutRequest(withUsername: user.username, andUser: user, fromController: self) {
                (nu) -> Void in
                
                if let newuser: User = nu {
                
                    os_log("New Profile Picture Uploaded", log: self.logTag, type: .debug)
                    
                    // Update the signed in users details
                    SignedInUser.user = newuser
                    
                    // Build the popup dialog to be displayed
                    let title = "Profile Picture Changed"
                    
                    // Actions to do when deleting a log
                    let continueButton = DefaultButton(title: "Continue") {
                        os_log("Continue to Edit Profile Page", log: self.logTag, type: .debug)
                        
                        // Re-enable buttons and remove loading overlay
                        overlay?.removeFromSuperview()
                        self.saveButton.isEnabled = true
                        self.cancelButton.isEnabled = true
                        
                        // Go back in the view controller hierarchy
                        self.navigationController?.popViewController(animated: true)
                    }
                    
                    // Display the popup before redirecting to edit profile page
                    let popup = PopupDialog(title: title, message: nil)
                    popup.addButton(continueButton)
                    
                    self.present(popup, animated: true, completion: nil)
                } else {
                    
                    os_log("Failed to Upload New Profile Picture", log: self.logTag, type: .error)
                    
                    // On failure, restore the original profile picture
                    self.proPicView.image = self.originalPic
                    self.user.profilepic = self.originalBase64
                    
                    // Build the popup dialog to be displayed
                    let title = "Profile Picture Not Changed"
                    let message = "The Size of the Picture Uploaded was Too Large"
                    
                    // Actions to do when acknowledging the error message
                    let continueButton = DefaultButton(title: "Continue") {
                        os_log("Continue to Edit Profile Page", log: self.logTag, type: .debug)
                        
                        // Re-enable buttons and remove loading overlay
                        overlay?.removeFromSuperview()
                        self.saveButton.isEnabled = true
                        self.cancelButton.isEnabled = true
                    }
                    
                    // Display the popup before redirecting to edit profile page
                    let popup = PopupDialog(title: title, message: message)
                    popup.addButton(continueButton)
                    
                    self.present(popup, animated: true, completion: nil)
                }
            }
        } else {
            self.navigationController?.popViewController(animated: true)
        }
    }
    
    /**
     Picture upload cancelled, return to edit profile page
     - parameters:
     - sender: the view that invoked this function (cancelButton)
     */
    @IBAction func cancelProPic(_ sender: UIButton) {
        os_log("Cancel Editing the Profile Picture", log: logTag, type: .debug)
        self.navigationController?.popViewController(animated: true)
    }
    
}

// Helper function inserted by Swift 4.2 migrator.
fileprivate func convertFromUIImagePickerControllerInfoKeyDictionary(_ input: [UIImagePickerController.InfoKey: Any]) -> [String: Any] {
	return Dictionary(uniqueKeysWithValues: input.map {key, value in (key.rawValue, value)})
}

// Helper function inserted by Swift 4.2 migrator.
fileprivate func convertFromUIImagePickerControllerInfoKey(_ input: UIImagePickerController.InfoKey) -> String {
	return input.rawValue
}
