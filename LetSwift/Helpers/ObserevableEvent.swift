//
//  ObserevableEvent.swift
//  LetSwift
//
//  Created by Kinga Wilczek on 04.05.2017.
//  Copyright © 2017 Droids On Roids. All rights reserved.
//

import Foundation

struct ObservableEvent<T> {
    typealias Event = Observable<T>

    private let event: Observable<T>

    init(event: Event) {
        self.event = event
    }

    func subscribe(_ observer: @escaping (T) -> ()) {
        event.subscribe(onNext: observer)
    }
}