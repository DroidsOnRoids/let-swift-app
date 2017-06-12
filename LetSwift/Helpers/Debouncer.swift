//
//  Debouncer.swift
//  LetSwift
//
//  Created by Kinga Wilczek on 12.06.2017.
//  Copyright © 2017 Droids On Roids. All rights reserved.
//

import Foundation

class Debouncer: NSObject {
    var callback: (() -> ())
    var delay: Double
    weak var timer: Timer?

    init(delay: Double, callback: @escaping (() -> ())) {
        self.delay = delay
        self.callback = callback
    }

    func call() {
        timer?.invalidate()
        let nextTimer = Timer.scheduledTimer(timeInterval: delay, target: self, selector: #selector(fireNow), userInfo: nil, repeats: false)
        timer = nextTimer
    }

    func fireNow() {
        self.callback()
    }
}
