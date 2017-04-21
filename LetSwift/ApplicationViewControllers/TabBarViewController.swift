//
//  TabBarViewController.swift
//  LetSwift
//
//  Created by Marcin Chojnacki on 21.04.2017.
//  Copyright © 2017 Droids On Roids. All rights reserved.
//

import UIKit

final class TabBarViewController: UITabBarController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupTabBar()
        setupTabs()
    }
    
    private func setupTabBar() {
        tabBar.clipsToBounds = true
        tabBar.itemPositioning = .centered
    }
    
    private func setupTabs() {
        addTab(for: EventsViewController(), imageInactive: #imageLiteral(resourceName: "EventsInactive"), imageActive: #imageLiteral(resourceName: "EventsActive"))
        addTab(for: SpeakersViewController(), imageInactive: #imageLiteral(resourceName: "SpeakersInactive"), imageActive: #imageLiteral(resourceName: "SpeakersActive"))
        addTab(for: ContactViewController(), imageInactive: #imageLiteral(resourceName: "ContactInactive"), imageActive: #imageLiteral(resourceName: "ContactActive"))
    }
    
    private func addTab(for viewController: UIViewController, imageInactive: UIImage, imageActive: UIImage) {
        let offset: CGFloat = 5.0
        
        viewController.tabBarItem = UITabBarItem(title: nil, image: imageInactive, selectedImage: imageActive)
        viewController.tabBarItem.imageInsets = UIEdgeInsetsMake(offset, 0.0, -offset, 0.0)
        
        if viewControllers != nil {
            viewControllers!.append(viewController)
        } else {
            viewControllers = [viewController]
        }
    }
}
