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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        os_log("DetailsViewController Loaded.", log: logTag, type: .debug)
        
        // Set the navigation bar back button to a custom image
        navigationController?.navigationBar.backIndicatorImage = UIImage(named: "back")
        navigationController?.navigationBar.backIndicatorTransitionMaskImage = UIImage(named: "back")
        navigationController?.navigationBar.tintColor = UIColor(0x000000)
        navigationItem.title = "Edit Profile Picture"
        
        navigationItem.backBarButtonItem = UIBarButtonItem(title: " ", style:
            UIBarButtonItemStyle.plain, target: nil, action: nil)
        
        proPicView.layer.borderWidth = 2
        proPicView.layer.borderColor = UIColor(0xCCCCCC).cgColor
        proPicView.layer.cornerRadius = 1
        
        // If the user has a profile picture, display it
        if let profPicBase64 = user.profilepic {
            
            // Save the base64 encoding in case an invalid picture is entered
            originalBase64 = profPicBase64
            
            // Part of the base 64 encoding is html specific, remove this piece
            let index = profPicBase64.index(profPicBase64.startIndex, offsetBy: 23)
            let base64 = profPicBase64.substring(from: index)
            
            // Now decode the base 64 encoded string and convert it to an image
            let profPicData: Data = Data(base64Encoded: base64, options: .ignoreUnknownCharacters)!
            let profPic: UIImage = UIImage(data: profPicData)!
            
            // Set the original profile picture in case an invalid picture is entered
            originalPic = profPic
            
            // Display the profile picture image
            proPicView.image = profPic
        }
        
        // Set click listener to the profile picture view to upload a picture
        let propicClick = UITapGestureRecognizer(target: self, action: #selector(self.editProfilePicture(_:)))
        propicClick.delegate = self
        proPicView.addGestureRecognizer(propicClick)
    }
    
    // Edit the users profile picture
    func editProfilePicture(_ sender: UIView) {
        os_log("Editing Profile Picture", log: logTag, type: .debug)
        
        let imagePicker = UIImagePickerController()
        imagePicker.sourceType = .photoLibrary
        imagePicker.delegate = self
        
        self.present(imagePicker, animated: true, completion: nil)
    }
    
    // Called when an image is picked from the photo library
    func imagePickerController(_ picker: UIImagePickerController,
                               didFinishPickingMediaWithInfo info: [String : Any]) {
        // Get the picked image from info dictionary
        image = info[UIImagePickerControllerOriginalImage] as? UIImage
        
        proPicView.image = image
        dismiss(animated: true, completion: nil)
    }
    
    // If a new image is uploaded, save it to the API and go back to the edit profile page
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
            
            let imageData: Data = UIImagePNGRepresentation(newImage)!
            var proPicBase64: String = imageData.base64EncodedString()
            
            proPicBase64 = proPicBase64.replacingOccurrences(of: "\n", with: "")
            
            user.profilepic = "data:image/jpeg;base64," + proPicBase64
            
            APIClient.userPutRequest(withUsername: user.username, andUser: user) {
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
    
    // Picture upload cancelled, return to edit profile page
    @IBAction func cancelProPic(_ sender: UIButton) {
        os_log("Cancel Editing the Profile Picture", log: logTag, type: .debug)
        self.navigationController?.popViewController(animated: true)
    }
    
}
