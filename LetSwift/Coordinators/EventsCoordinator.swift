//
//  EventsCoordinator.swift
//  LetSwift
//
//  Created by Kinga Wilczek on 21.04.2017.
//  Copyright © 2017 Droids On Roids. All rights reserved.
//

import UIKit

final class EventsCoordinator: Coordinator, Startable {

    func start() {
        let viewModel = EventsViewControllerViewModel(lastEvent: EventsViewControllerViewModel.mockedEvent)
        let viewController = EventsViewController(viewModel: viewModel)
        
        navigationViewController.viewControllers = [viewController]
    }
}
