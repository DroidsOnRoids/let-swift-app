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
        
        presentFirstAppController()
    }
    
    fileprivate func presentFirstAppController() {
        !DefaultsManager.shared.isOnboardingCompleted ? presentOnboardingViewController() : presentLoginViewController()
    }
    
    fileprivate func presentOnboardingViewController() {
        let viewModel = OnboardingViewControllerViewModel(delegate: self)
        let viewController = OnboardingViewController(viewModel: viewModel)
        
        navigationViewController.pushViewController(viewController, animated: false)
    }
    
    fileprivate func presentLoginViewController() {
        let viewModel = LoginViewControllerViewModel(delegate: self)
        let viewController = LoginViewController(viewModel: viewModel)
        
        navigationViewController.pushViewController(viewController, animated: true)
    }
}

extension AppCoordinator: OnboardingViewControllerDelegate {
    func continueButtonDidTap() {
        DefaultsManager.shared.isOnboardingCompleted = true

        presentLoginViewController()
    }
}

extension AppCoordinator: LoginViewControllerDelegate {
}
