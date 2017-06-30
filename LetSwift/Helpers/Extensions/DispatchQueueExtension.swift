//
//  DispatchQueueExtension.swift
//  LetSwift
//
//  Created by Kinga Wilczek on 28.06.2017.
//  Copyright © 2017 Droids On Roids. All rights reserved.
//

import Foundation

public extension DispatchQueue {

    private static var onceTracker = [String]()

    public class func once(token: String, block: ()-> ()) {
        objc_sync_enter(self)

        defer { objc_sync_exit(self) }

        if onceTracker.contains(token) { return }

        onceTracker.append(token)
        block()
    }
}
