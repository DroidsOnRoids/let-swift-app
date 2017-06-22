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
        //TODO: in some way pass through speakers data and latest speakers data
        let mockedSpeakers: [Speaker] = Speaker.from(MockLoader.speakersMock!)!
        let controller = SpeakersViewController(viewModel: SpeakersViewControllerViewModel(speakers: mockedSpeakers, delegate: self))
        controller.coordinatorDelegate = delegate

        navigationViewController.viewControllers = [controller]
    }
}

extension SpeakersCoordinator: SpeakersViewControllerDelegate { }
