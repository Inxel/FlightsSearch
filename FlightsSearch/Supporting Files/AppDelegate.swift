//
//  AppDelegate.swift
//  FlightsSearch
//
//  Created by Artyom Zagoskin on 27.04.2021.
//

import UIKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    var window: UIWindow?
    private var appCoordinator: AppCoordinator = AppCoordinator()

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        window = UIWindow(frame: UIScreen.main.bounds)
        appCoordinator.start()
        window?.rootViewController = appCoordinator.rootViewController
        window?.makeKeyAndVisible()
        return true
    }

}

