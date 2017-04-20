//
//  AppCoordinator.swift
//  LetSwift
//
//  Created by Marcin Chojnacki, Kinga Wilczek on 13.04.2017.
//  Copyright © 2017 Droids On Roids. All rights reserved.
//

final class AppCoordinator: Coordinator {
    
    func start() {
        navigationViewController.setNavigationBarHidden(true, animated: false)
        
        presentOnboardingViewController()
    }
    
    fileprivate func presentOnboardingViewController() {
        if !DefaultsManager.shared.isOnboardingCompleted {
            let viewModel = OnboardingViewControllerViewModel(delegate: self)
            let viewController = OnboardingViewController(viewModel: viewModel)
            
            navigationViewController.pushViewController(viewController, animated: false)
        } else {
            presentLoginViewController()
        }
    }
    
    fileprivate func presentLoginViewController() {
        let viewModel = LoginViewControllerViewModel(delegate: self)
        let viewController = LoginViewController(viewModel: viewModel)
        
        navigationViewController.pushViewController(viewController, animated: true)
    }
}

extension AppCoordinator: OnboardingViewControllerDelegate {
    func dismissOnboardingViewController() {
        DefaultsManager.shared.isOnboardingCompleted = true

        presentLoginViewController()
    }
}

extension AppCoordinator: LoginViewControllerDelegate {
}
