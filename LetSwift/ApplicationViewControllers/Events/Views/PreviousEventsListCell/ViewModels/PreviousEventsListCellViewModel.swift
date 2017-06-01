//
//  PreviousEventsListCellViewModel.swift
//  LetSwift
//
//  Created by Kinga Wilczek on 05.05.2017.
//  Copyright © 2017 Droids On Roids. All rights reserved.
//

import Foundation

final class PreviousEventsListCellViewModel {
    
    private let disposeBag = DisposeBag()
    private var currentPage = 1

    var previousEventsObservable = Observable<[Event?]?>(nil)
    var cellDidTapWithIndexObservable = Observable<Int>(-1)
    var previousEventsRefreshObservable = Observable<Void>()

    weak var delegate: EventsViewControllerDelegate?

    init(previousEvents events: Observable<[Event?]?>, delegate: EventsViewControllerDelegate?) {
        self.previousEventsObservable = events
        self.delegate = delegate

        setup()
    }

    private func setup() {
        cellDidTapWithIndexObservable.subscribeNext { [weak self] index in
            guard let previousEvent = self?.previousEventsObservable.value?[safe: index] as? Event else { return }
            self?.delegate?.presentEventDetailsScreen(fromEventId: previousEvent.id)
        }
        .add(to: disposeBag)

        previousEventsRefreshObservable.subscribeNext { [weak self] in
            guard let weakSelf = self, let events = weakSelf.previousEventsObservable.value, !events.contains(where: { $0 == nil }) else { return }

            weakSelf.previousEventsObservable.next(events + [nil])
            weakSelf.getNextEventsPage()
        }
        .add(to: disposeBag)
    }

    private func getNextEventsPage() {
        NetworkProvider.shared.eventsList(with: currentPage) { [weak self] response in
            let currentEvents = (self?.previousEventsObservable.value)?.flatMap { $0 } ?? []

            guard case .success(let events) = response else {
                self?.previousEventsObservable.next(currentEvents)
                return
            }

            self?.currentPage += 1
            self?.previousEventsObservable.next(currentEvents + events.elements)
        }
    }
}
