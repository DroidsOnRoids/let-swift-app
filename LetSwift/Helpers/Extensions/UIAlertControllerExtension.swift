//
//  UIAlertControllerExtension.swift
//  LetSwift
//
//  Created by Kinga Wilczek on 20.06.2017.
//  Copyright © 2017 Droids On Roids. All rights reserved.
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
