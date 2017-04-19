//
//  AppCoordinator.swift
//  LetSwift
//
//  Created by Marcin Chojnacki, Kinga Wilczek on 13.04.2017.
//  Copyright © 2017 Droids On Roids. All rights reserved.
//

final class AppCoordinator: Coordinator {
    
    func start() {
        let viewModel = OnboardingViewControllerViewModel(delegate: self)
        let viewController = OnboardingViewController(viewModel: viewModel)
        
        navigationViewController.setNavigationBarHidden(true, animated: false)
        navigationViewController.pushViewController(viewController, animated: false)
    }
}

extension AppCoordinator: OnboardingViewControllerDelegate {
    func dismissOnboardingViewController() {
        let viewModel = LoginViewControllerViewModel(delegate: self)
        let viewController = LoginViewController(viewModel: viewModel)
        
        navigationViewController.pushViewController(viewController, animated: true)
    }
}

extension AppCoordinator: LoginViewControllerDelegate {
}
