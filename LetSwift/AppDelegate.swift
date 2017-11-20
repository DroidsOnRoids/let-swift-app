//
//  AppDelegate.swift
//  LetSwift
//
//  Created by Marcin Chojnacki, Kinga Wilczek on 07.04.2017.
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
import FBSDKCoreKit
import SDWebImage
import AlamofireNetworkActivityIndicator
#if DEBUG
import SimulatorStatusMagic
#endif

#if DEBUG
let appCompilationCondition: AppCompilationConditions = .debug
#elseif APP_STORE
let appCompilationCondition: AppCompilationConditions = .appStore
#else
let appCompilationCondition: AppCompilationConditions = .release
#endif

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    
    private var appCoordinator: AppCoordinator!

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        setupNetworkIndicator()
        setupAppearance()
        analyticsHelper.setupAnalytics()
    
        FBSDKApplicationDelegate.sharedInstance()
            .application(application, didFinishLaunchingWithOptions: launchOptions)
        
        SDWebImageManager.shared().imageCache?.clearDisk()
        
#if DEBUG
        if UIApplication.isInTestMode {
            SDStatusBarManager.sharedInstance().enableOverrides()
        }
#endif
        
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

    private func setupAppearance() {
        UINavigationBar.appearance().titleTextAttributes = [
            .font: UIFont.systemFont(ofSize: 15.0, weight: UIFont.Weight.semibold),
            .foregroundColor: UIColor.highlightedBlack,
            .kern: 1.0
        ]
    }
}
