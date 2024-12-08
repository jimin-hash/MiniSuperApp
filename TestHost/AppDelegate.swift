//
//  AppDelegate.swift
//  TestHost
//
//  Created by Jimin Park on 12/8/24.
//

import UIKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate {
    public var window: UIWindow?
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        let window = UIWindow(frame: UIScreen.main.bounds)
        self.window = window
        
        return true
    }
}

