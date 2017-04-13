//
//  Coordinator.swift
//  LetSwift
//
//  Created by Marcin Chojnacki, Kinga Wilczek on 13.04.2017.
//  Copyright © 2017 Droids On Roids. All rights reserved.
//

import UIKit

class Coordinator {
    
    var childCoordinators = [Coordinator]()
    var navigationViewController: UINavigationController
    
    init(navigationController: UINavigationController) {
        self.navigationViewController = navigationController
    }
}
