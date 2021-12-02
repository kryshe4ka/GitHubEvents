//
//  AppDelegate.swift
//  GitHubEvents
//
//  Created by Liza Kryshkovskaya on 3.11.21.
//

import CoreData
import UIKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    var window: UIWindow?
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.

        let window = UIWindow()
        let viewController = EventListViewController()
        let navigationController = UINavigationController(rootViewController: viewController)
        window.rootViewController = navigationController
        self.window = window
        window.makeKeyAndVisible()
        
        return true
    }
}
