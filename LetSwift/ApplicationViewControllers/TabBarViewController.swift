//
//  TabBarViewController.swift
//  LetSwift
//
//  Created by Marcin Chojnacki on 21.04.2017.
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

final class TabBarViewController: UITabBarController {
    
    private typealias TabData = (imageInactive: UIImage, imageActive: UIImage)
    
    private enum Constants {
        static let offset: CGFloat = 5.0
    }
    
    convenience init(controllers: [UIViewController]) {
        self.init()
        
        setupTabs(controllers: controllers)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tabBar.itemPositioning = .centered
    }
    
    override func tabBar(_ tabBar: UITabBar, didSelect item: UITabBarItem) {
        NotificationCenter.default.post(name: .didSelectAppTapBarWithController, object: selectedViewController)
    }
    
    private func setupTabs(controllers: [UIViewController]) {
        viewControllers = controllers
        
        guard let tabControllers = viewControllers else { return }
        
        let tabImages: [TabData] = [
            (imageInactive: #imageLiteral(resourceName: "EventsInactive"), imageActive:#imageLiteral(resourceName: "EventsActive")),
            (imageInactive: #imageLiteral(resourceName: "SpeakersInactive"), imageActive: #imageLiteral(resourceName: "SpeakersActive")),
            (imageInactive: #imageLiteral(resourceName: "ContactInactive"), imageActive: #imageLiteral(resourceName: "ContactActive"))
        ]
        
        tabImages.enumerated().forEach { index, value in
            guard let controller = tabControllers[safe: index] else { return }
            
            controller.tabBarItem = UITabBarItem(title: nil, image: value.imageInactive, selectedImage: value.imageActive)
            controller.tabBarItem.imageInsets = UIEdgeInsets(top: Constants.offset, left: 0.0, bottom: -Constants.offset, right: 0.0)
            controller.tabBarItem.titlePositionAdjustment = UIOffset(horizontal: 0.0, vertical: 100.0)
        }
    }
}
