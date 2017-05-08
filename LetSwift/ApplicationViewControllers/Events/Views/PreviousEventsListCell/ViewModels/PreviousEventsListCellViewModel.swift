//
//  PreviousEventsListCellViewModel.swift
//  LetSwift
//
//  Created by Kinga Wilczek on 05.05.2017.
//  Copyright © 2017 Droids On Roids. All rights reserved.
//

import Foundation

final class PreviousEventsListCellViewModel {

    var previousEvents = Observable<[Event]>([])
    var cellDidTapWithIndex = Observable<Int>(-1)

    weak var delegate: EventsViewControllerDelegate?

    init(previousEvenets events: [Event], delegate: EventsViewControllerDelegate?) {
        self.delegate = delegate
        previousEvents.next(events)

        setup()
    }

    private func setup() {
        cellDidTapWithIndex.subscribe(onNext: { [weak self] index in
            guard let previousEvent = self?.previousEvents.value[safe: index] else { return }
            self?.delegate?.collectionViewCellDidTap(with: previousEvent)
        })
    }
}
