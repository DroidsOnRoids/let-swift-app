//
//  SpeakersCoordinator.swift
//  LetSwift
//
//  Created by Kinga Wilczek on 21.04.2017.
//  Copyright © 2017 Droids On Roids. All rights reserved.
//

import UIKit

final class SpeakersCoordinator: Coordinator, Startable {

    fileprivate weak var delegate: AppCoordinatorDelegate?

    init(navigationController: UINavigationController = UINavigationController(), delegate: AppCoordinatorDelegate) {
        self.delegate = delegate

        super.init(navigationController: navigationController)
    }

    func start() {
        let controller = SpeakersViewController(viewModel: SpeakersViewControllerViewModel(delegate: self))
        controller.coordinatorDelegate = delegate

        navigationViewController.viewControllers = [controller]
    }
}

extension SpeakersCoordinator: SpeakersViewControllerDelegate {
    func presentSpeakerDetailsScreen(with id: Int) {
        let viewModel = SpeakerDetailsViewControllerViewModel(with: id, delegate: self)
        let viewController = SpeakerDetailsViewController(viewModel: viewModel)

        navigationViewController.pushViewController(viewController, animated: true)
    }
}

extension SpeakersCoordinator: SpeakerDetailsViewControllerDelegate {
    func presentLectureScreen(with talk: Talk) {
        let viewModel = LectureViewControllerViewModel(with: talk, delegate: self)
        let viewController = LectureViewController(viewModel: viewModel)
        
        navigationViewController.pushViewController(viewController, animated: true)
    }
}
