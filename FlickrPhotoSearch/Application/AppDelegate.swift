//
//  AppDelegate.swift
//  FlickrPhotoSearch
//
//  Created by Tarun S on 01/07/18.
//  Copyright © 2018 Uber. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    var window: UIWindow?
    var applicationController: ApplicationController?
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        
        let navigationController = window!.rootViewController as! UINavigationController
        applicationController = ApplicationController(navigationController: navigationController)
        applicationController?.coordinator.start()
        
        return true
    }
}

