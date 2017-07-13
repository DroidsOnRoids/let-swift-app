//
//  DebugMenu.swift
//  LetSwift
//
//  Created by Marcin Chojnacki on 20.04.2017.
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

fileprivate struct DebugMenu {
    
    private let alertController: UIAlertController
    
    private let actions = [
        ("Clear all data", clearDataAction),
        ("Reset onboarding", resetOnboardingAction),
        ("Reset login skip", resetLoginSkipAction),
        ("Facebook logout", facebookLogoutAction),
        ("Crash app", crashAppAction)
    ]

    init() {
        alertController = UIAlertController(title: nil, message: "Debug menu", preferredStyle: .actionSheet)
        setupActions()
    }
    
    private func setupActions() {
        actions.forEach { title, handler in
            alertController.addAction(UIAlertAction(title: title, style: .default, handler: { _ in
                handler(self)()
            }))
        }
        
        alertController.addAction(UIAlertAction(title: "Close", style: .cancel))
    }
    
    func present(on viewController: UIViewController?) {
        if let viewController = viewController {
            viewController.present(alertController, animated: true)
        }
    }
    
    private func clearDataAction() {
        DefaultsManager.shared.clearDefaults()
    }
    
    private func resetOnboardingAction() {
        DefaultsManager.shared.isOnboardingCompleted = false
        DefaultsManager.shared.synchronize()
    }
    
    private func resetLoginSkipAction() {
        DefaultsManager.shared.isLoginSkipped = false
        DefaultsManager.shared.synchronize()
    }
    
    private func facebookLogoutAction() {
        FacebookManager.shared.logOut()
    }
    
    private func crashAppAction() {
        fatalError("Crashed manually from debug menu")
    }
}

extension UIWindow {
    open override func motionEnded(_ motion: UIEventSubtype, with event: UIEvent?) {
        if motion == .motionShake {
            DebugMenu().present(on: rootViewController)
        }
    }
}
