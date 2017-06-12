//
//  Debouncer.swift
//  LetSwift
//
//  Created by Kinga Wilczek on 12.06.2017.
//  Copyright © 2017 Droids On Roids. All rights reserved.
//

import Foundation

final class Debouncer {
    private var callback: () -> ()
    private var delay: Double
    private weak var timer: Timer?

    init(delay: Double, callback: @escaping (() -> ())) {
        self.delay = delay
        self.callback = callback
    }

    func call() {
        timer?.invalidate()
        let nextTimer = Timer.scheduledTimer(timeInterval: delay, target: self, selector: #selector(fireNow), userInfo: nil, repeats: false)
        timer = nextTimer
    }

    @objc private func fireNow() {
        callback()
    }
}
