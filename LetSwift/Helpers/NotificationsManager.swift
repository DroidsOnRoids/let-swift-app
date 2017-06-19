//
//  NotificationsManager.swift
//  LetSwift
//
//  Created by Marcin Chojnacki on 04.05.2017.
//  Copyright © 2017 Droids On Roids. All rights reserved.
//

import UIKit
import UserNotifications

struct NotificationManager {
    
    let date: Date?
    
    private var notifications: [UILocalNotification] {
        guard let date = date else { return [] }
        return UIApplication.shared.scheduledLocalNotifications?.filter { $0.fireDate == date } ?? []
    }

    private var permissionsGranted: Bool {
        guard let notificationSettings = UIApplication.shared.currentUserNotificationSettings else { return false }
        return notificationSettings.types == .alert
    }

    var isNotificationActive: Bool {
        return !notifications.isEmpty
    }

    func succeededScheduleNotification(withMessage message: String, completionHandler: @escaping (Bool, Bool) -> ()) {
        guard let date = date, !isNotificationActive else { return }
        
        ensurePermissions { grantedPermissions in
            DispatchQueue.main.async {
                if grantedPermissions {
                    let notification = UILocalNotification()
                    notification.alertBody = message
                    notification.fireDate = date
                    notification.timeZone = NSTimeZone.default

                    UIApplication.shared.scheduleLocalNotification(notification)
                }

                completionHandler(self.isNotificationActive, grantedPermissions)
            }
        }
    }

    private func ensurePermissions(completionHandler: @escaping (Bool) -> ()) {
        if #available(iOS 10.0, *) {
            UNUserNotificationCenter.current().requestAuthorization(options: [.alert]) { granted, _ in
                if !DefaultsManager.shared.notificationsPromptShowed && granted {
                    completionHandler(granted)
                } else if DefaultsManager.shared.notificationsPromptShowed {
                    completionHandler(granted)
                }

                DefaultsManager.shared.notificationsPromptShowed = true
            }
        } else {
            if !DefaultsManager.shared.notificationsPromptShowed {
                NotificationCenter.default.addObserver(forName: NSNotification.Name(rawValue: "Did"), object: nil, queue: nil) { _ in
                    DefaultsManager.shared.notificationsPromptShowed = true
                    NotificationCenter.default.removeObserver(self, name: NSNotification.Name(rawValue: "Did"), object: nil)

                    if self.permissionsGranted {
                        completionHandler(self.permissionsGranted)
                    }
                }
                UIApplication.shared.registerUserNotificationSettings(UIUserNotificationSettings(types: .alert, categories: nil))
            } else {
                completionHandler(permissionsGranted)
            }
        }
    }
    
    func cancelNotification() {
        notifications.forEach {
            UIApplication.shared.cancelLocalNotification($0)
        }
    }
}
