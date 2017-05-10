//
//  AppViewController.swift
//  LetSwift
//
//  Created by Marcin Chojnacki on 24.04.2017.
//  Copyright © 2017 Droids On Roids. All rights reserved.
//

import UIKit

class AppViewController: UIViewController {
    
    var coordinatorDelegate: AppCoordinatorDelegate?
    
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
        
        navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
        
        if let navTitle = navigationItem.title {
            navigationItem.titleView = setupTitleLabel(withTitle: navTitle)
        }
        
        if shouldShowUserIcon {
            navigationItem.rightBarButtonItem = UIBarButtonItem(image: #imageLiteral(resourceName: "UserIcon"), style: .plain, target: self, action: nil)
            navigationItem.rightBarButtonItem?.tintColor = .black
            
            navigationItem.rightBarButtonItem?.target = self
            navigationItem.rightBarButtonItem?.action = #selector(userIconTapped(_:))
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
    
    @objc private func logOutTapped() {
        FacebookManager.shared.logOut()
    }
    
    @objc private func userIconTapped(_ sender: UIBarButtonItem) {
        if FacebookManager.shared.isLoggedIn {
            guard let senderButton = sender.value(forKey: "view") as? UIView else { return }
            let popover = PopoverViewController()
            let anchor = CGPoint(x: senderButton.center.x + 7.0, y: senderButton.center.y + 36.0)
            
            popover.setupPopover(anchor: anchor, title: localized("GENERAL_LOGOUT"), arrowPosition: 0.9, action: #selector(logOutTapped)).presentPopover(on: self)
        } else {
            coordinatorDelegate?.presentLoginViewController(asPopupWindow: true)
        }
    }
}
