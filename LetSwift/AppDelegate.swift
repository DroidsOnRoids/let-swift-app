//
//  AppDelegate.swift
//  LetSwift
//
//  Created by Marcin Chojnacki on 07.04.2017.
//  Copyright © 2017 Droids On Roids. All rights reserved.
//

import UIKit
import HockeySDK

// TODO: find a better method to check build type (flag set by Bitrise?)
let isDebugBuild = true
let test = false

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    private let hockeyAppId = "3cc4c0d1fd694100b2d187995356d5ef"

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        setupHockeyApp()

        let navigationController = UINavigationController()
        let coordinator = AppCoordinator(navigationController: navigationController)
        coordinator.start()
        
        window = UIWindow()
        window?.tintColor = .swiftOrange
        window?.rootViewController = navigationController
        window?.makeKeyAndVisible()

        return true
    }

    private func setupHockeyApp() {
        BITHockeyManager.shared().configure(withIdentifier: hockeyAppId)
        BITHockeyManager.shared().start()
        BITHockeyManager.shared().authenticator.authenticateInstallation()
    }
}
