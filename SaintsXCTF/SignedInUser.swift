//
//  SignedInUser.swift
//  SaintsXCTF
//
//  Created by Andy Jarombek on 8/13/17.
//  Copyright © 2017 Andy Jarombek. All rights reserved.
//

import UIKit
import os.log

class SignedInUser {
    
    static let logTag = OSLog(subsystem: "SaintsXCTF.App.SignedInUser", category: "SignedInUser")
    
    static var user = User()
    
    // Get the url to the document directory where we will store the user object
    static let userArchiveURL: URL = {
        let documentsDirectories = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        let documentDirectory = documentsDirectories.first!
        return documentDirectory.appendingPathComponent("user.archive")
    }()
    
    // On initialization, check to see if an archived user exists
    init() {
        if let archivedUser = NSKeyedUnarchiver.unarchiveObject(withFile:
                        SignedInUser.userArchiveURL.path) as? User {
            
            SignedInUser.user = archivedUser
        }
    }
    
    // Save the user to the filesystem
    static func saveUser() -> Bool {
        os_log("Saving items to %@", log: SignedInUser.logTag, type: .debug, userArchiveURL.path)
        return NSKeyedArchiver.archiveRootObject(SignedInUser.user, toFile: userArchiveURL.path)
    }
    
    // Remove the user in the filesystem by overwriting the old user with an empty one
    static func removeUser() -> Bool {
        os_log("Removing user from storage", log: SignedInUser.logTag, type: .debug)
        user = User()
        return NSKeyedArchiver.archiveRootObject(SignedInUser.user, toFile: userArchiveURL.path)
    }
}
