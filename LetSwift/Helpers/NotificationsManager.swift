//
//  NotificationsManager.swift
//  LetSwift
//
//  Created by Marcin Chojnacki on 04.05.2017.
//  Copyright © 2017 Droids On Roids. All rights reserved.
//

import UIKit

struct NotificationManager {
    
    let date: Date?
    
    private func ensurePermissions() {
        UIApplication.shared.registerUserNotificationSettings(UIUserNotificationSettings(types: .alert, categories: nil))
    }
    
    private var notifications: [UILocalNotification] {
        guard let date = date else { return [] }
        return UIApplication.shared.scheduledLocalNotifications?.filter { $0.fireDate == date } ?? []
    }
    
    var isNotificationActive: Bool {
        return !notifications.isEmpty
    }
    
    func succeededScheduleNotification(withMessage message: String) -> Bool {
        guard let date = date, !isNotificationActive else { return false }
        
        ensurePermissions()

        let notification = UILocalNotification()
        notification.alertBody = message
        notification.fireDate = date
        
        UIApplication.shared.scheduleLocalNotification(notification)
        
        return isNotificationActive
    }
    
    func cancelNotification() {
        notifications.forEach {
            UIApplication.shared.cancelLocalNotification($0)
        }
    }
}
