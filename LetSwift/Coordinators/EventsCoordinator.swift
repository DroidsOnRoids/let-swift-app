//
//  EventsCoordinator.swift
//  LetSwift
//
//  Created by Kinga Wilczek on 21.04.2017.
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

final class EventsCoordinator: Startable, Navigable {
    
    private weak var delegate: AppCoordinatorDelegate?

    let navigationController = UINavigationController()

    private let initialEventsList: [Event]?
    
    init(delegate: AppCoordinatorDelegate?, initialEventsList: [Event]?) {
        self.delegate = delegate
        self.initialEventsList = initialEventsList
    }
    
    func start() {
        let viewModel = EventsViewControllerViewModel(events: initialEventsList, delegate: self)
        let viewController = EventsViewController(viewModel: viewModel)
        viewController.coordinatorDelegate = delegate
        
        navigationController.viewControllers = [viewController]
    }
}

extension EventsCoordinator: EventsViewControllerDelegate {
    func presentEventDetailsScreen(fromViewModel viewModel: EventsViewControllerViewModel) {
        let viewController = EventDetailsViewController(viewModel: viewModel)
        
        navigationController.pushViewController(viewController, animated: true)
        
        if let event = viewModel.lastEventObservable.value {
            analyticsHelper.reportOpenEventDetails?(id: event.id, name: event.title)
        }
    }
    
    func presentEventDetailsScreen(fromEventId eventId: Int) {
        let viewModel = EventsViewControllerViewModel(eventId: eventId, delegate: self)
        let viewController = EventDetailsViewController(viewModel: viewModel)
        viewController.coordinatorDelegate = delegate
        
        navigationController.pushViewController(viewController, animated: true)
    }
    
    func presentPhotoGalleryScreen(with photos: [Photo], eventId: Int?) {
        let viewModel = PhotoGalleryViewControllerViewModel(photos: photos, eventId: eventId, delegate: self)
        let viewController = PhotoGalleryViewController(viewModel: viewModel)

        navigationController.pushViewController(viewController, animated: true)
    }
}

extension EventsCoordinator: PhotoGalleryViewControllerDelegate {
    func presentPhotoSliderScreen(with viewModel: PhotoGalleryViewControllerViewModel) {
        let viewController = PhotoSliderViewController(viewModel: viewModel)
        viewController.coordinatorDelegate = delegate
        
        navigationController.present(viewController, animated: true)
    }
}
