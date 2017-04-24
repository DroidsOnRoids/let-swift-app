//
//  TabBarViewController.swift
//  LetSwift
//
//  Created by Marcin Chojnacki on 21.04.2017.
//  Copyright © 2017 Droids On Roids. All rights reserved.
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
        
        setupTabBar()
    }
    
    private func setupTabBar() {
        tabBar.clipsToBounds = true
        tabBar.itemPositioning = .centered
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
            controller.tabBarItem.imageInsets = UIEdgeInsetsMake(Constants.offset, 0.0, -Constants.offset, 0.0)
            controller.tabBarItem.titlePositionAdjustment = UIOffset(horizontal: 0, vertical: 100)
        }
    }
}
