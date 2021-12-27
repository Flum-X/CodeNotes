//
//  AppDelegate.swift
//  MyWorkBook
//
//  Created by Flum on 2021/12/27.
//

import UIKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    @objc var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        
        window = UIWindow(frame: UIScreen.main.bounds)
        window?.rootViewController = UINavigationController(rootViewController: ViewController())
        window?.makeKeyAndVisible()
        return true
    }

}

