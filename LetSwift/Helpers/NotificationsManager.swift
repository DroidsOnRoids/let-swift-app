//
//  NotificationsManager.swift
//  LetSwift
//
//  Created by Marcin Chojnacki on 04.05.2017.
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
                    notification.timeZone = .current

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
                NotificationCenter.default.addObserver(forName: .didRegisterNotificationSettings, object: nil, queue: nil) { _ in
                    DefaultsManager.shared.notificationsPromptShowed = true
                    NotificationCenter.default.removeObserver(self, name: .didRegisterNotificationSettings, object: nil)

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
