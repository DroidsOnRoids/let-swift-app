//
//  AppDelegate.swift
//  LetSwift
//
//  Created by Marcin Chojnacki on 07.04.2017.
//  Copyright © 2017 Droids On Roids. All rights reserved.
//
//  Licensed under the Apache License, Version 2.0 (the "License");
//  you may not use this file except in compliance with the License.
//  You may obtain a copy of the License at
//
//       http://www.apache.org/licenses/LICENSE-2.0
//
//  Unless required by applicable law or agreed to in writing, software
//  distributed under the License is distributed on an "AS IS" BASIS,
//  WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
//  See the License for the specific language governing permissions and
//  limitations under the License.
//

import UIKit
import HockeySDK
import FBSDKCoreKit
import SDWebImage
import AlamofireNetworkActivityIndicator

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
        setupNetworkIndicator()

        setupHockeyApp()
        
        FBSDKApplicationDelegate.sharedInstance()
            .application(application, didFinishLaunchingWithOptions: launchOptions)
        
        SDWebImageManager.shared().imageCache.clearDisk()
        
        let navigationController = UINavigationController()
        appCoordinator = AppCoordinator(navigationController: navigationController)
        appCoordinator.start()
        
        window = UIWindow()
        window?.tintColor = .swiftOrange
        window?.rootViewController = navigationController
        window?.makeKeyAndVisible()

        return true
    }
    
    func application(_ application: UIApplication, supportedInterfaceOrientationsFor window: UIWindow?) -> UIInterfaceOrientationMask {
        return appCoordinator.rotationLocked ? .portrait : .allButUpsideDown
    }

    func application(_ app: UIApplication, open url: URL, options: [UIApplicationOpenURLOptionsKey : Any] = [:]) -> Bool {
        return FBSDKApplicationDelegate.sharedInstance()
            .application(app, open: url, options: options)
    }

    func application(_ application: UIApplication, didRegister notificationSettings: UIUserNotificationSettings) {
        NotificationCenter.default.post(name: .didRegisterNotificationSettings, object: nil)
    }

    private func setupNetworkIndicator() {
        NetworkActivityIndicatorManager.shared.isEnabled = true
        NetworkActivityIndicatorManager.shared.startDelay = 0.1
        NetworkActivityIndicatorManager.shared.completionDelay = 0.2
    }

    private func setupHockeyApp() {
        BITHockeyManager.shared().configure(withIdentifier: hockeyAppId)
        BITHockeyManager.shared().start()

        if !isDebugBuild {
            BITHockeyManager.shared().authenticator.authenticateInstallation()
        }
    }
}
