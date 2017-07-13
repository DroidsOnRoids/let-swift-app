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
    func presentLoginViewController(asPopupWindow: Bool)
}

final class AppCoordinator: Coordinator, AppCoordinatorDelegate, Startable {
    
    var rotationLocked = true {
        didSet {
            if rotationLocked {
                let key = UIInterfaceOrientation.portrait.rawValue
                UIDevice.current.setValue(key, forKey: "orientation")
            }
        }
    }
    
    fileprivate var initialEventsList: [Event]?
    
    fileprivate var shouldShowLoginScreen: Bool {
        return !(FacebookManager.shared.isLoggedIn || DefaultsManager.shared.isLoginSkipped)
    }
    
    func start() {
        navigationViewController.setNavigationBarHidden(true, animated: false)
        
        presentSplashScreen()
    }
    
    private func present(viewController: UIViewController, animated: Bool = true) {
        navigationViewController.setViewControllers([viewController], animated: animated)
    }
    
    fileprivate func presentSplashScreen() {
        let viewModel = SplashViewControllerViewModel(delegate: self)
        let viewController = SplashViewController(viewModel: viewModel)
        
        present(viewController: viewController, animated: false)
    }
    
    fileprivate func presentFirstAppController() {
        if !DefaultsManager.shared.isOnboardingCompleted {
            presentOnboardingViewController()
        } else if shouldShowLoginScreen {
            presentLoginViewController()
        } else {
            presentMainController()
        }
    }
    
    fileprivate func presentOnboardingViewController() {
        let viewModel = OnboardingViewControllerViewModel(delegate: self)
        let viewController = OnboardingViewController(viewModel: viewModel)
        
        present(viewController: viewController)
    }
    
    func presentLoginViewController(asPopupWindow: Bool = false) {
        let viewModel = LoginViewControllerViewModel(delegate: self)
        let viewController = LoginViewController(viewModel: viewModel)
        
        if asPopupWindow {
            navigationViewController.pushViewController(viewController, animated: true)
        } else {
            present(viewController: viewController)
        }
    }
    
    func pushOnRootNavigationController(_ viewController: UIViewController, animated: Bool) {
        navigationViewController.pushViewController(viewController, animated: animated)
    }
    
    fileprivate func presentMainController() {
        let coordinators = [
            EventsCoordinator(initialEventsList: initialEventsList, delegate: self),
            SpeakersCoordinator(delegate: self),
            ContactCoordinator(delegate: self)
        ]
        
        coordinators.forEach {
            ($0 as! Startable).start()
            self.childCoordinators.append($0)
        }

        let viewController = TabBarViewController(controllers: coordinators.map({ ($0).navigationViewController }))
        
        present(viewController: viewController, animated: false)
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
        if navigationViewController.viewControllers.count > 1 {
            navigationViewController.popViewController(animated: true)
        } else {
            presentMainController()
        }
    }
    
    func loginHasSkipped() {
        DefaultsManager.shared.isLoginSkipped = true
        
        if navigationViewController.viewControllers.count > 1 {
            navigationViewController.popViewController(animated: true)
        } else {
            presentMainController()
        }
    }
}
