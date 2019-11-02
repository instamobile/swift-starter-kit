//
//  AppDelegate.swift
//  FirebaseStarterApp
//
//  Created by Florian Marcu on 2/21/19.
//  Copyright © 2019 Instamobile. All rights reserved.
//

import Firebase
import UIKit
import FacebookCore

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {

        FirebaseApp.configure()

        // Window setup
        window = UIWindow(frame: UIScreen.main.bounds)
        window?.rootViewController = UINavigationController(rootViewController: ATCClassicLandingScreenViewController(nibName: "ATCClassicLandingScreenViewController", bundle: nil))
        window?.makeKeyAndVisible()
        return true
    }
  
  func application(_ app: UIApplication, open url: URL, options: [UIApplication.OpenURLOptionsKey : Any] = [:]) -> Bool {
      return ApplicationDelegate.shared.application(app, open: url, options: options)
  }
}

