//
//  EventsCoordinator.swift
//  LetSwift
//
//  Created by Kinga Wilczek on 21.04.2017.
//  Copyright © 2017 Droids On Roids. All rights reserved.
//

import UIKit

final class EventsCoordinator: Coordinator, Startable {
    
    fileprivate let delegate: AppCoordinatorDelegate
    fileprivate let initialEventsList: [Event]?
    
    init(navigationController: UINavigationController, initialEventsList: [Event]?, delegate: AppCoordinatorDelegate) {
        self.delegate = delegate
        self.initialEventsList = initialEventsList
        
        super.init(navigationController: navigationController)
    }
    
    func start() {
        // TODO: When event is not available we should pass it anyway instead of mocking
        let lastEvent = initialEventsList?.first ?? EventsViewControllerViewModel.mockedEvent
        let viewModel = EventsViewControllerViewModel(lastEvent: lastEvent, delegate: self)
        let viewController = EventsViewController(viewModel: viewModel)
        viewController.coordinatorDelegate = delegate
        
        navigationViewController.viewControllers = [viewController]
    }
}

extension EventsCoordinator: EventsViewControllerDelegate {
    func presentEventDetailsScreen(fromViewModel viewModel: EventsViewControllerViewModel) {
        let viewController = EventDetailsViewController(viewModel: viewModel)
        
        navigationViewController.pushViewController(viewController, animated: true)
    }
    
    func presentEventDetailsScreen(fromModel model: Event) {
        let viewModel = EventsViewControllerViewModel(lastEvent: model, delegate: self)
        let viewController = EventDetailsViewController(viewModel: viewModel)
        viewController.coordinatorDelegate = delegate
        
        navigationViewController.pushViewController(viewController, animated: true)
    }
    
    func presentSpeakerDetailsScreen() {
        let viewController = SpeakerDetailsViewController()
        
        navigationViewController.pushViewController(viewController, animated: true)
    }
    
    func presentLectureScreen() {
        let viewModel = LectureViewControllerViewModel(delegate: self)
        let viewController = LectureViewController(viewModel: viewModel)
        
        navigationViewController.pushViewController(viewController, animated: true)
    }

    func presentPhotoGalleryScreen(with photos: [Photo]) {
        let viewController = PhotoGalleryViewController()

        navigationViewController.pushViewController(viewController, animated: true)
    }
}
