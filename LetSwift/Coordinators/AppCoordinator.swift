//
//  AppCoordinator.swift
//  LetSwift
//
//  Created by Marcin Chojnacki, Kinga Wilczek on 13.04.2017.
//  Copyright © 2017 Droids On Roids. All rights reserved.
//

import UIKit

final class AppCoordinator: Coordinator {
    
    func start() {
        navigationViewController.setNavigationBarHidden(true, animated: false)
        
        presentFirstAppController()
    }
    
    private func present(viewController: UIViewController, animated: Bool = true) {
        navigationViewController.setViewControllers([viewController], animated: animated)
    }
    
    fileprivate func presentFirstAppController() {
        DefaultsManager.shared.isOnboardingCompleted ? presentLoginViewController() : presentOnboardingViewController()
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
        let viewController = TabBarViewController()
        
        present(viewController: viewController)
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
