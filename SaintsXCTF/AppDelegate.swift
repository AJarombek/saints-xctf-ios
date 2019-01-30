//
//  AppDelegate.swift
//  SaintsXCTF
//
//  Created by Andy Jarombek on 3/28/17.
//  Copyright © 2017 Andy Jarombek. All rights reserved.
//

import UIKit
import IQKeyboardManagerSwift

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        print(#function)
        
        IQKeyboardManager.shared.enable = true
        IQKeyboardManager.shared.enableAutoToolbar = true
        
        // Set the color of the status bar for the app
        UINavigationBar.appearance().clipsToBounds = true
        let statusBar: UIView = UIApplication.shared.value(forKey: "statusBar") as! UIView
        statusBar.backgroundColor = UIColor(0x990000, a: 1)
        UIApplication.shared.statusBarStyle = .lightContent
        
        let navigationBarAppearance = UINavigationBar.appearance()
        navigationBarAppearance.titleTextAttributes = [NSAttributedStringKey.foregroundColor:UIColor(0xFFFFFF)]
        
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

