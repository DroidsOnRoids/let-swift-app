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
    
    var isNotificationActive: Bool {
        return !notifications.isEmpty
    }
    
    func succeededScheduleNotification(withMessage message: String, completionHandler: @escaping (Bool) -> ()) {
        guard let date = date, !isNotificationActive else { return }

        let newNotificationState = isNotificationActive
        
        ensurePermissions { granted in
            let notification = UILocalNotification()
            notification.alertBody = message
            notification.fireDate = date
            notification.timeZone = NSTimeZone.default

            UIApplication.shared.scheduleLocalNotification(notification)

            completionHandler(newNotificationState)
        }
    }

    private func ensurePermissions(completionHandler: @escaping (Bool) -> ()) {
        guard !DefaultsManager.shared.notificationsPromptShowed else { return }

        if #available(iOS 10.0, *) {
            UNUserNotificationCenter.current().requestAuthorization(options: [.alert]) { granted, error in
                DefaultsManager.shared.notificationsPromptShowed = true

                completionHandler(granted)
            }
        } else {
            NotificationCenter.default.addObserver(forName: NSNotification.Name(rawValue: "Did"), object: nil, queue: nil) {
                _ in
                DefaultsManager.shared.notificationsPromptShowed = true
                NotificationCenter.default.removeObserver(self, name: NSNotification.Name(rawValue: "Did"), object: nil)

                //TODO: check again permissions
//                completionHandler(granted)
            }
            UIApplication.shared.registerUserNotificationSettings(UIUserNotificationSettings(types: .alert, categories: nil))
        }
    }
    
    func cancelNotification() {
        notifications.forEach {
            UIApplication.shared.cancelLocalNotification($0)
        }
    }
}
