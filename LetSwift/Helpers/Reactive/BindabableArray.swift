//
//  BindabableArray.swift
//  LetSwift
//
//  Created by Kinga Wilczek on 04.05.2017.
//  Copyright © 2017 Droids On Roids. All rights reserved.
//

import Foundation

final class BindableArray<T> {

    private var values: [T]
    private var events = [([T]) -> ()]()

    init(_ values: [T]) {
        self.values = values
    }

    func bind(to event: @escaping ([T]) -> ()) {
        events.append(event)
        notify(event: event)
    }

    func append(_ element: T) {
        values.append(element)
        events.forEach({ $0(values) })
    }

    private func notify(event: ([T]) -> ()) {
        values.enumerated().forEach { index, element in
            event(values)
        }
    }
}
