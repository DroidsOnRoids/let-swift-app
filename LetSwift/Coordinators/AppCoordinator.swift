//
//  AppCoordinator.swift
//  LetSwift
//
//  Created by Marcin Chojnacki, Kinga Wilczek on 13.04.2017.
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

protocol AppCoordinatorDelegate: class {
    var rotationLocked: Bool { get set }
    
    func presentLoginViewController()
}

final class AppCoordinator: AppCoordinatorDelegate, Startable {
    
    typealias ChildCoordinator = Startable & Navigable
    
    var rotationLocked = true {
        didSet {
            if rotationLocked {
                let key = UIInterfaceOrientation.portrait.rawValue
                UIDevice.current.setValue(key, forKey: "orientation")
            }
        }
    }
    
    private let window: UIWindow
    private var initialEventsList: [Event]?
    private var childCoordinators = [ChildCoordinator]()
    
    private var shouldShowOnboardingScreen: Bool {
        guard !UIApplication.isInTestMode else { return true }

        return !DefaultsManager.shared.isOnboardingCompleted
    }
    
    private var shouldShowLoginScreen: Bool {
        guard !UIApplication.isInTestMode else { return true }

        return !(FacebookManager.shared.isLoggedIn || DefaultsManager.shared.isLoginSkipped)
    }
    
    private var hasAppStarted: Bool {
        return window.rootViewController is UITabBarController
    }
    
    init(window: UIWindow? = nil) {
        self.window = window ?? UIWindow()
        self.window.tintColor = .brandingColor
    }
    
    func start() {
        presentSplashScreen()
        window.makeKeyAndVisible()
    }
    
    private func presentSplashScreen() {
        let viewModel = SplashViewControllerViewModel(delegate: self)
        let viewController = SplashViewController(viewModel: viewModel)
        
        window.rootViewController = viewController
    }
    
    private func presentFirstAppController() {
        if shouldShowOnboardingScreen {
            presentOnboardingViewController()
        } else if shouldShowLoginScreen {
            presentLoginViewController()
        } else {
            presentMainController()
        }
    }
    
    private func presentOnboardingViewController() {
        let viewModel = OnboardingViewControllerViewModel(delegate: self)
        let viewController = OnboardingViewController(viewModel: viewModel)
        
        window.rootViewController = viewController
    }
    
    func presentLoginViewController() {
        let viewModel = LoginViewControllerViewModel(delegate: self)
        let viewController = LoginViewController(viewModel: viewModel)

        window.rootViewController?.present(viewController, animated: true)
    }
    
    private func presentMainController() {
        childCoordinators = [
            EventsCoordinator(delegate: self, initialEventsList: initialEventsList),
            SpeakersCoordinator(delegate: self),
            ContactCoordinator(delegate: self)
        ]
        childCoordinators.forEach { $0.start() }
        
        let tabBarController = TabBarViewController(controllers: childCoordinators.map { $0.navigationController })
        window.rootViewController = tabBarController
    }
}

extension AppCoordinator: SplashViewControllerDelegate {
    func initialLoadingHasFinished(events: [Event]?) {
        initialEventsList = events
        
        presentFirstAppController()
    }
}

extension AppCoordinator: OnboardingViewControllerCoordinatorDelegate {
    func onboardingHasCompleted() {
        DefaultsManager.shared.isOnboardingCompleted = true

        shouldShowLoginScreen ? presentLoginViewController() : presentMainController()
    }
}

extension AppCoordinator: LoginViewControllerDelegate {
    func facebookLoginCompleted() {
        dismissLoginViewController()
    }
    
    func loginHasSkipped() {
        DefaultsManager.shared.isLoginSkipped = true
        
        dismissLoginViewController()
    }
    
    private func dismissLoginViewController() {
        window.rootViewController?.dismiss(animated: true)
        
        if !hasAppStarted {
            presentMainController()
        }
    }
}
