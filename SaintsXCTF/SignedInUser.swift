//
//  SignedInUser.swift
//  SaintsXCTF
//
//  Created by Andy Jarombek on 8/13/17.
//  Copyright © 2017 Andy Jarombek. All rights reserved.
//

import UIKit
import os.log

/**
 Class with helper methods to save and remove the signed in user from the filesystem
 */
public class SignedInUser {
    
    static let logTag = OSLog(subsystem: "SaintsXCTF.App.SignedInUser", category: "SignedInUser")
    
    // Hold the user to be saved to the filesystem
    static var user = User()
    
    // Get the url to the document directory where we will store the user object
    static let userArchiveURL: URL = {
        SignedInUser.getDocumentsDirectory().appendingPathComponent("user.archive")
    }()
    
    /**
     On initialization, check to see if an archived user exists
     */
    init() {
        if let nsData = NSData(contentsOf: SignedInUser.userArchiveURL) {
            do {
                let data: Data = Data(referencing: nsData)
                if let archivedUser = try NSKeyedUnarchiver.unarchiveTopLevelObjectWithData(data) as? User {
                    SignedInUser.user = archivedUser
                }
            } catch {
                os_log("Error getting Signed In User URL data", log: SignedInUser.logTag, type: .debug)
                return
            }
        }
    }
    
    /**
     Get the directory in the filesystem to write the signed in user data to
     - returns: the filesystem URL to hold the user data
     */
    static func getDocumentsDirectory() -> URL {
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        return paths[0]
    }
    
    /**
     Save the user to the filesystem
     - returns: `true` if the user was successfully saved, `false` otherwise
     */
    static func saveUser() -> Bool {
        os_log("Saving items to %@", log: SignedInUser.logTag, type: .debug, userArchiveURL.path)
        
        do {
            let data: Data = try NSKeyedArchiver.archivedData(withRootObject: SignedInUser.user,
                                                              requiringSecureCoding: false)
            try data.write(to: SignedInUser.userArchiveURL)
            return true
        } catch {
            os_log("Error saving Signed In User", log: SignedInUser.logTag, type: .debug)
            return false
        }
    }
    
    /**
     Remove the user in the filesystem by overwriting the old user with an empty one
     - returns: `true` if the user was successfully removed, `false` otherwise
     */
    public static func removeUser() -> Bool {
        os_log("Removing user from storage", log: SignedInUser.logTag, type: .debug)
        
        // Create an empty user to overwrite the existing one
        user = User()
        
        do {
            let data: Data = try NSKeyedArchiver.archivedData(withRootObject: SignedInUser.user,
                                                              requiringSecureCoding: false)
            try data.write(to: SignedInUser.userArchiveURL)
            return true
        } catch {
            os_log("Error removing Signed In User", log: SignedInUser.logTag, type: .debug)
            return false
        }
    }
}
