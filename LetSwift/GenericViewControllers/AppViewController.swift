//
//  AppViewController.swift
//  LetSwift
//
//  Created by Marcin Chojnacki on 24.04.2017.
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

class AppViewController: UIViewController {
    
    weak var coordinatorDelegate: AppCoordinatorDelegate?
    
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

        if shouldShowUserIcon {
            navigationItem.rightBarButtonItem = UIBarButtonItem(image: #imageLiteral(resourceName: "UserIcon"), style: .plain, target: self, action: nil)
            navigationItem.rightBarButtonItem?.tintColor = .black
            
            navigationItem.rightBarButtonItem?.target = self
            navigationItem.rightBarButtonItem?.action = #selector(userIconTapped(_:))
        }
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
