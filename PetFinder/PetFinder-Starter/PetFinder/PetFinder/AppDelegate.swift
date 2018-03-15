//
//  AppDelegate.swift
//  PetFinder
//
//  Created by Luke Parham on 8/31/15.
//  Copyright © 2015 Luke Parham. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    var window: UIWindow?
    
    func application(_ application: UIApplication, willFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        return true
    }
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        return true
    }
    
    func applicationDidEnterBackground(_ application: UIApplication) {
        MatchedPetsManager.sharedManager.archivePets()
    }
    
    
    // 
    // Add two methods here to enable saving and restoring application state
    //
    func application(_ application: UIApplication, shouldSaveApplicationState coder: NSCoder) -> Bool{
        return true
    }
    
    func application(_ application: UIApplication, shouldRestoreApplicationState coder: NSCoder) -> Bool{
        return true
    }
    
}
