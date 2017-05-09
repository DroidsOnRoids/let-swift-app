//
//  NotificationCenterExtension.swift
//  LetSwift
//
//  Created by Kinga Wilczek on 08.05.2017.
//  Copyright © 2017 Droids On Roids. All rights reserved.
//

import Foundation

extension NotificationCenter {
    func notification(_ name: Notification.Name?, object: AnyObject? = nil) -> Observable<Notification?> {
        let observable = Observable<Notification?>(nil)
        addObserver(forName: name, object: object, queue: nil) { notification in
            observable.next(notification)
        }
        
        return observable
    }
}
