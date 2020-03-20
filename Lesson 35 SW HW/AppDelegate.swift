//
//  AppDelegate.swift
//  Lesson 35 SW HW
//
//  Created by Marentilo on 08.03.2020.
//  Copyright © 2020 Marentilo. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        
        let tableView = ViewController()
        let search = UINavigationController(rootViewController: tableView)
        self.window?.rootViewController = search
        return true
    }

}

