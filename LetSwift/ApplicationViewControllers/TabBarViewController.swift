//
//  TabBarViewController.swift
//  LetSwift
//
//  Created by Marcin Chojnacki on 21.04.2017.
//  Copyright © 2017 Droids On Roids. All rights reserved.
//

import UIKit

final class TabBarViewController: UITabBarController {
    
    private typealias TabData = (controller: UIViewController, imageInactive: UIImage, imageActive: UIImage)
    
    private enum Constants {
        static let offset: CGFloat = 5.0
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupTabBar()
    }
    
    private func setupTabBar() {
        tabBar.clipsToBounds = true
        tabBar.itemPositioning = .centered
        
        setupTabs()
    }
    
    private func setupTabs() {
        let tabViewControllers: [TabData] = [
            (controller: EventsViewController(), imageInactive: #imageLiteral(resourceName: "EventsInactive"), imageActive:#imageLiteral(resourceName: "EventsActive")),
            (controller: SpeakersViewController(), imageInactive: #imageLiteral(resourceName: "SpeakersInactive"), imageActive: #imageLiteral(resourceName: "SpeakersActive")),
            (controller: ContactViewController(), imageInactive: #imageLiteral(resourceName: "ContactInactive"), imageActive: #imageLiteral(resourceName: "ContactActive"))
        ]

        viewControllers = tabViewControllers.map { setupViewController(tabData: $0) }
    }
    
    private func setupViewController(tabData: TabData) -> UIViewController {
        tabData.controller.tabBarItem = UITabBarItem(title: nil, image: tabData.imageInactive, selectedImage: tabData.imageActive)
        tabData.controller.tabBarItem.imageInsets = UIEdgeInsetsMake(Constants.offset, 0.0, -Constants.offset, 0.0)
        
        return tabData.controller
    }
}
