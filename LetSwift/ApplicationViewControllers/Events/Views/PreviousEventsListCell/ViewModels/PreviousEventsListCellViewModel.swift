//
//  PreviousEventsListCellViewModel.swift
//  LetSwift
//
//  Created by Kinga Wilczek on 05.05.2017.
//  Copyright © 2017 Droids On Roids. All rights reserved.
//

import Foundation

final class PreviousEventsListCellViewModel {

    var previousEventsObservable = Observable<[Event]>([])
    var cellDidTapWithIndexObservable = Observable<Int>(-1)

    weak var delegate: EventsViewControllerDelegate?

    init(previousEvenets events: [Event], delegate: EventsViewControllerDelegate?) {
        self.delegate = delegate
        previousEventsObservable.next(events)

        setup()
    }

    private func setup() {
        cellDidTapWithIndexObservable.subscribeNext { [weak self] index in
            guard let previousEvent = self?.previousEventsObservable.value[safe: index] else { return }
            self?.delegate?.presentEventDetailsScreen(fromModel: previousEvent)
        }
    }
}
