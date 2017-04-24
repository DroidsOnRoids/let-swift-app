//
//  ContactCoordinator.swift
//  LetSwift
//
//  Created by Kinga Wilczek on 21.04.2017.
//  Copyright © 2017 Droids On Roids. All rights reserved.
//

import Foundation

final class ContactCoordinator: Coordinator, Startable {
    
    func start() {
        let controller = ContactViewController()
        navigationViewController.viewControllers = [controller]
    }
}
