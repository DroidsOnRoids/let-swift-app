//
//  AppViewController.swift
//  LetSwift
//
//  Created by Marcin Chojnacki on 24.04.2017.
//  Copyright © 2017 Droids On Roids. All rights reserved.
//

import UIKit

class AppViewController: UIViewController {
    
    var viewControllerTitleKey: String? {
        return nil
    }
    
    var shouldShowUserIcon: Bool {
        return false
    }
    
    var shouldHideShadow: Bool {
        return false
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupNavigationBar()
    }

    private func setupNavigationBar() {
        title = localized(viewControllerTitleKey ?? "").uppercased()
        navigationController?.navigationBar.setValue(shouldHideShadow, forKey: "hidesShadow")
        
        if let navTitle = navigationItem.title {
            navigationItem.titleView = setupTitleLabel(withTitle: navTitle)
        }
        
        if shouldShowUserIcon {
            navigationItem.rightBarButtonItem = UIBarButtonItem(image: #imageLiteral(resourceName: "UserIcon"), style: .plain, target: self, action: nil)
            navigationItem.rightBarButtonItem?.tintColor = .black
        }
    }
    
    private func setupTitleLabel(withTitle title: String) -> UILabel {
        let titleLabel = UILabel()
        titleLabel.attributedText = title
            .attributed(withFont: .systemFont(ofSize: 15.0, weight: UIFontWeightSemibold))
            .with(color: .highlightedBlack)
            .with(spacing: 1.0)
        
        titleLabel.sizeToFit()
        
        return titleLabel
    }
}
