//
//  UserJWT.swift
//  SaintsXCTF
//
//  Created by Andrew Jarombek on 4/21/21.
//  Copyright © 2021 Andy Jarombek. All rights reserved.
//

import Foundation
import os.log

class UserJWT {
    
    static let logTag = OSLog(subsystem: "SaintsXCTF.App.UserJWT", category: "UserJWT")
    
    // Hold the JWT to be saved to the filesystem
    static var jwt: String = ""
    
    // Get the url to the document directory where the jwt object is stored
    static let jwtArchiveURL: URL = {
        UserJWT.getDocumentsDirectory().appendingPathComponent("jwt.archive")
    }()
    
    /**
     On initialization, check to see if an archived JWT exists
     */
    init() {
        if let nsData = NSData(contentsOf: UserJWT.jwtArchiveURL) {
            do {
                let data: Data = Data(referencing: nsData)
                if let archivedJWT = try NSKeyedUnarchiver.unarchiveTopLevelObjectWithData(data) as? String {
                    UserJWT.jwt = archivedJWT
                }
            } catch {
                os_log("Error getting JWT URL data", log: UserJWT.logTag, type: .debug)
                return
            }
        }
    }
    
    /**
     Get the directory in the filesystem to write JWT data to
     - returns: filesystem URL to hold the JWT data
     */
    static func getDocumentsDirectory() -> URL {
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        return paths[0]
    }
    
    /**
     Save the JWT to the filesystem
     - returns: `true` if the JWT was successfully saved, `false` otherwise
     */
    static func saveJWT() -> Bool {
        os_log("Saving items to %@", log: UserJWT.logTag, type: .debug, jwtArchiveURL.path)
        
        do {
            let data: Data = try NSKeyedArchiver.archivedData(withRootObject: UserJWT.jwt, requiringSecureCoding: false)
            try data.write(to: UserJWT.jwtArchiveURL)
            return true
        } catch {
            os_log("Error saving JWT", log: UserJWT.logTag, type: .debug)
            return false
        }
    }
    
    /**
     Remove the JWT from the filesystem
     - returns: `true` if the JWT was successfully removed, `false` otherwise
     */
    static func removeJWT() -> Bool {
        os_log("Removing JWT from storage", log: UserJWT.logTag, type: .debug)
        
        do {
            let data: Data = try NSKeyedArchiver.archivedData(withRootObject: "", requiringSecureCoding: false)
            try data.write(to: UserJWT.jwtArchiveURL)
            return true
        } catch {
            os_log("Error removing JWT", log: UserJWT.logTag, type: .debug)
            return false
        }
    }
}
