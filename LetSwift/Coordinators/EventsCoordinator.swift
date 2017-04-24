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
        let controller = EventsViewController()
        navigationViewController.viewControllers = [controller]
        
        setupNavigationBar(navigationViewController.navigationBar)
    }
    
    // TODO: Move this to common file
    private func setupNavigationBar(_ navigationBar: UINavigationBar) {
        navigationBar.setValue(true, forKey: "hidesShadow")
        navigationBar.barTintColor = .white
        
        navigationBar.titleTextAttributes = [
            NSFontAttributeName: UIFont.systemFont(ofSize: 15.0, weight: UIFontWeightSemibold)
            //NSKernAttributeName: 1.0
        ]
    }
}
