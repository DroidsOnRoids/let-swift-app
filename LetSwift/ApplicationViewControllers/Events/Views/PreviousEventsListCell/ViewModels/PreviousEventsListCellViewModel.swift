//
//  PreviousEventsListCellViewModel.swift
//  LetSwift
//
//  Created by Kinga Wilczek on 05.05.2017.
//  Copyright © 2017 Droids On Roids. All rights reserved.
//

import Foundation
import Alamofire

final class PreviousEventsListCellViewModel {
    
    private let disposeBag = DisposeBag()
    private var currentPage = 1
    private var totalPage = -1

    let previousEventsObservable: Observable<[Event?]?>
    let cellDidTapWithIndexObservable = Observable<Int>(-1)
    let morePreviousEventsRequestObervable = Observable<Void>()
    let morePreviousEventsRequestCanceledObservable = Observable<Void>()
    let morePreviousEventsRequestSentObservable = Observable<Int>(-1)
    let morePreviousEventsAvilabilityObservable = Observable<Bool>(true)
    let refreshObservable: Observable<Void>
    let shouldScrollToFirstObservable = Observable<Void>()

    weak var delegate: EventsViewControllerDelegate?

    private weak var morePreviousEventsRequest: Request?
    lazy private var morePreviousEventsDebouncer: Debouncer = Debouncer(delay: 0.1, callback: self.getNextEventsPage)

    private var isLastPage: Bool {
        return !(currentPage < totalPage || totalPage == -1)
    }

    init(previousEvents events: Observable<[Event?]?>, refreshObservable refresh: Observable<Void>, delegate: EventsViewControllerDelegate?) {
        previousEventsObservable = events
        refreshObservable = refresh
        self.delegate = delegate

        setup()
    }

    private func setup() {
        cellDidTapWithIndexObservable.subscribeNext { [weak self] index in
            guard let previousEvent = self?.previousEventsObservable.value?[safe: index] as? Event else { return }
            self?.delegate?.presentEventDetailsScreen(fromEventId: previousEvent.id)
        }
        .add(to: disposeBag)

        morePreviousEventsRequestObervable.subscribeNext { [weak self] in
            guard let weakSelf = self, !weakSelf.isLastPage else { return }

            if weakSelf.morePreviousEventsRequest == nil {
                weakSelf.morePreviousEventsDebouncer.call()
            }
        }
        .add(to: disposeBag)

        morePreviousEventsRequestCanceledObservable.subscribeNext { [weak self] in
            let currentEvents = self?.previousEventsObservable.value ?? []
            self?.previousEventsObservable.next(currentEvents)
        }
        .add(to: disposeBag)

        refreshObservable.subscribeCompleted { [weak self] in
            self?.currentPage = 1
            self?.shouldScrollToFirstObservable.next()
            self?.morePreviousEventsAvilabilityObservable.next(true)
        }
        .add(to: disposeBag)
    }

    private func getNextEventsPage() {
        morePreviousEventsRequest = NetworkProvider.shared.eventsList(with: currentPage + 1) { [weak self] response in
            let currentEvents = self?.previousEventsObservable.value ?? []
            self?.morePreviousEventsRequest = nil
            
            guard case .success(let events) = response else {
                self?.previousEventsObservable.next(currentEvents)
                return
            }

            self?.totalPage = events.page.pageCount
            self?.currentPage += 1

            self?.previousEventsObservable.next(currentEvents + events.elements)
            self?.morePreviousEventsRequestSentObservable.next(currentEvents.count)

            if self?.currentPage == self?.totalPage {
                self?.morePreviousEventsAvilabilityObservable.next(false)
            }
        }
    }
}
