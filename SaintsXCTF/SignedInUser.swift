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
    
    let logTag = OSLog(subsystem: "SaintsXCTF.App.SignedInUser", category: "SignedInUser")
    
    static var user = User()
    
    // Get the url to the document directory where we will store the user object
    let userArchiveURL: URL = {
        let documentsDirectories = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        let documentDirectory = documentsDirectories.first!
        return documentDirectory.appendingPathComponent("user.archive")
    }()
    
    // On initialization, check to see if an archived user exists
    init() {
        if let archivedUser = NSKeyedUnarchiver.unarchiveObject(withFile: userArchiveURL.path) as? User {
            SignedInUser.user = archivedUser
        }
    }
    
    // Save the user to the filesystem
    func saveUser() -> Bool {
        os_log("Saving items to %@", log: OSLog.default, type: .debug, userArchiveURL.path)
        return NSKeyedArchiver.archiveRootObject(SignedInUser.user, toFile: userArchiveURL.path)
    }
}
