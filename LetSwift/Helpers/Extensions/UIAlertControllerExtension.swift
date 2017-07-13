//
//  UIAlertControllerExtension.swift
//  LetSwift
//
//  Created by Kinga Wilczek on 20.06.2017.
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

extension UIAlertController {
    static var anyViewController: UIViewController? {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return nil }
        return appDelegate.window?.rootViewController
    }

    static func showSettingsAlert() {
        let alertController = UIAlertController(title: localized("EVENTS_NOTIFICATIONS_TITILE"), message: localized("EVENTS_NOTIFICATIONS_MESSAGE"), preferredStyle: .alert)

        let settingsAction = UIAlertAction(title: localized("EVENTS_NOTIFICATIONS_SETTINGS"), style: .default) { _ in
            guard let settingsUrl = URL(string: UIApplicationOpenSettingsURLString) else { return }

            if UIApplication.shared.canOpenURL(settingsUrl) {
                UIApplication.shared.openURL(settingsUrl)
            }
        }

        alertController.addAction(settingsAction)
        alertController.addAction(UIAlertAction(title: localized("EVENTS_NOTIFICATIONS_CANCEL"), style: .cancel, handler: nil))

        anyViewController?.present(alertController, animated: true)
    }
}
