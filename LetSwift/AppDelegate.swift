//
//  AppDelegate.swift
//  LetSwift
//
//  Created by Marcin Chojnacki, Kinga Wilczek on 07.04.2017.
//  Copyright © 2017 Droids On Roids. All rights reserved.
//

import UIKit
import FBSDKCoreKit
import SDWebImage
import AlamofireNetworkActivityIndicator

#if !APP_STORE
import HockeySDK
#else
//TODO: insert fabric here
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

    private let hockeyAppId = "3cc4c0d1fd694100b2d187995356d5ef"

    var window: UIWindow?
    
    private var appCoordinator: AppCoordinator!

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        setupNetworkIndicator()

        #if !APP_STORE
        setupHockeyApp()
        #else
        //TODO: insert fabric setup here
        #endif
    
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

    #if !APP_STORE
    private func setupHockeyApp() {
        BITHockeyManager.shared().configure(withIdentifier: hockeyAppId)
        BITHockeyManager.shared().start()

        if appCompilationCondition == .release {
            BITHockeyManager.shared().authenticator.authenticateInstallation()
        }
    }
    #endif
}
