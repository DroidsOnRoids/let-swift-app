//
//  AppDelegate.swift
//  LetSwift
//
//  Created by Marcin Chojnacki on 07.04.2017.
//  Copyright © 2017 Droids On Roids. All rights reserved.
//

import UIKit

// TODO: find a better method to check build type (flag set by Bitrise?)
let isDebugBuild = true

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        let onboardingController = OnboardingViewController()
        let mainNavigationController = UINavigationController(rootViewController: onboardingController)
        mainNavigationController.setNavigationBarHidden(true, animated: false)

        window = UIWindow(frame: UIScreen.main.bounds)
        window?.tintColor = .swiftOrange
        window?.rootViewController = mainNavigationController
        window?.makeKeyAndVisible()

        return true
    }
}
