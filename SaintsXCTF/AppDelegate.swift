//
//  AppDelegate.swift
//  SaintsXCTF
//
//  Created by Andy Jarombek on 3/28/17.
//  Copyright © 2017 Andy Jarombek. All rights reserved.
//

import UIKit
import IQKeyboardManagerSwift

/**
 The app delegate executes when the application launches.  This class provides lifecycle hooks
 for the application.
 - Important:
 ## Extends the following class:
 - UIResponder: Provides event response abilities
 
 ## Implements the following protocols:
 - UIApplicationDelegate: Contains methods that respond to important application lifecycle events
 */
@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    /**
     Executed when the application launch process is almost done and the app is almost ready to run.
     - parameters:
     - application: An object representing the iOS app
     - launchOptions: Indicates the reason why the app was launched
     - returns: always true
     */
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        print(#function)
        
        IQKeyboardManager.shared.enable = true
        IQKeyboardManager.shared.enableAutoToolbar = true
        
        // Set the color of the status bar for the app
        UINavigationBar.appearance().clipsToBounds = true
        
        let navigationBarAppearance = UINavigationBar.appearance()
        navigationBarAppearance.titleTextAttributes = [NSAttributedString.Key.foregroundColor:UIColor(0xFFFFFF)]
        
        // Override point for customization after application launch.
        return true
    }

    func applicationWillResignActive(_ application: UIApplication) {
        print(#function)
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        print(#function)
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        print(#function)
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        print(#function)
    }

    func applicationWillTerminate(_ application: UIApplication) {
        print(#function)
    }
}
