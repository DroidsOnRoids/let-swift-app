//
//  AppDelegate.swift
//  LetSwift
//
//  Created by Marcin Chojnacki on 07.04.2017.
//  Copyright © 2017 Droids On Roids. All rights reserved.
//

import UIKit
import HockeySDK

#if DEBUG
let isDebugBuild = true
#else
let isDebugBuild = false
#endif

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    private let hockeyAppId = "3cc4c0d1fd694100b2d187995356d5ef"

    var window: UIWindow?
    
    private var appCoordinator: AppCoordinator!

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        setupHockeyApp()

        let navigationController = UINavigationController()
        appCoordinator = AppCoordinator(navigationController: navigationController)
        appCoordinator.start()
        
        window = UIWindow()
        window?.tintColor = .swiftOrange
        window?.rootViewController = navigationController
        window?.makeKeyAndVisible()

        return true
    }

    private func setupHockeyApp() {
        BITHockeyManager.shared().configure(withIdentifier: hockeyAppId)
        BITHockeyManager.shared().start()

        if !isDebugBuild {
            BITHockeyManager.shared().authenticator.authenticateInstallation()
        }
    }
}
