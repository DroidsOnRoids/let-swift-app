//
//  AppCoordinator.swift
//  LetSwift
//
//  Created by Marcin Chojnacki, Kinga Wilczek on 13.04.2017.
//  Copyright © 2017 Droids On Roids. All rights reserved.
//

import UIKit

final class AppCoordinator: Coordinator, Startable {
    
    fileprivate var shouldShowLoginScreen: Bool {
        return !(FacebookManager.shared.isLoggedIn || DefaultsManager.shared.isLoginSkipped)
    }
    
    func start() {
        navigationViewController.setNavigationBarHidden(true, animated: false)
        
        presentFirstAppController()
    }
    
    private func present(viewController: UIViewController, animated: Bool = true) {
        navigationViewController.setViewControllers([viewController], animated: animated)
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
    
    fileprivate func presentLoginViewController() {
        let viewModel = LoginViewControllerViewModel(delegate: self)
        let viewController = LoginViewController(viewModel: viewModel)
        
        present(viewController: viewController)
    }
    
    fileprivate func presentMainController() {
        let coordinators = [
            EventsCoordinator(navigationController: UINavigationController()),
            SpeakersCoordinator(navigationController: UINavigationController()),
            ContactCoordinator(navigationController: UINavigationController())
        ]
        
        coordinators.forEach {
            ($0 as! Startable).start()
            self.childCoordinators.append($0)
        }

        let viewController = TabBarViewController(controllers: coordinators.map({ ($0).navigationViewController }))
        
        present(viewController: viewController)
    }
}

extension AppCoordinator: OnboardingViewControllerCoordinatorDelegate {
    func onboardingHasCompleted() {
        DefaultsManager.shared.isOnboardingCompleted = true

        shouldShowLoginScreen ? presentLoginViewController() : presentMainController()
    }
}

extension AppCoordinator: LoginViewControllerCoordinatorDelegate {
    func facebookLoginCompleted() {
        presentMainController()
    }
    
    func loginHasSkipped() {
        DefaultsManager.shared.isLoginSkipped = true
        
        presentMainController()
    }
}
