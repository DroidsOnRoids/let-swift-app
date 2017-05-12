//
//  BindabableArray.swift
//  LetSwift
//
//  Created by Kinga Wilczek on 04.05.2017.
//  Copyright © 2017 Droids On Roids. All rights reserved.
//

import Foundation

final class BindableArray<T> {

    var values: [T]
    private var events = [([T], Bool) -> ()]()

    init(_ values: [T]) {
        self.values = values
    }

    func bind(to event: @escaping ([T]) -> () ) {
        let convertedFunc: ([T], Bool) -> () = { (passedValues, updates) in
            event(passedValues)
        }
        events.append(convertedFunc)
        notify(event: convertedFunc)
    }

    func bind(to event: @escaping ([T], Bool) -> ()) {
        events.append(event)
        notify(event: event)
    }

    func append(_ element: T, updated: Bool = true) {
        values.append(element)
        events.forEach({ $0(values, updated) })
    }

    func remove(at index: Int, updated: Bool = true) {
        values.remove(at: index)
        events.forEach({ $0(values, updated) })
    }

    private func notify(event: ([T], Bool) -> ()) {
        values.enumerated().forEach { index, element in
            event(values, true)
        }
    }
}
