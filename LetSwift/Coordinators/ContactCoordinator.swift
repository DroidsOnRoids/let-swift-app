//
//  ContactCoordinator.swift
//  LetSwift
//
//  Created by Kinga Wilczek on 21.04.2017.
//  Copyright © 2017 Droids On Roids. All rights reserved.
//

import UIKit

final class ContactCoordinator: Coordinator, Startable {

    fileprivate let delegate: AppCoordinatorDelegate

    init(navigationController: UINavigationController, delegate: AppCoordinatorDelegate) {
        self.delegate = delegate

        super.init(navigationController: navigationController)
    }
    
    func start() {
        let viewModel = ContactViewControllerViewModel()
        let controller = ContactViewController(viewModel: viewModel)
        controller.coordinatorDelegate = delegate

        navigationViewController.viewControllers = [controller]
    }
}
