//
//  SpeakersViewControllerViewModel.swift
//  LetSwift
//
//  Created by Kinga Wilczek on 14.06.2017.
//  Copyright © 2017 Droids On Roids. All rights reserved.
//

import Foundation
import Alamofire

final class SpeakersViewControllerViewModel {

    private enum Constants {
        static let speakersOrderCurrent = "current"
        static let speakersOrderLatest = "recent"
        static let speakersPerPage = 10
    }

    private let disposeBag = DisposeBag()
    private var currentPage = 1
    private var totalPage = -1
    private var pendingRequest: Request?

    var speakerLoadDataRequestObservable = Observable<Void>()
    var tableViewStateObservable: Observable<AppContentState>
    var checkIfLastSpeakerObservable = Observable<Int>(-1)
    var tryToLoadMoreDataObservable = Observable<Void>()
    var noMoreSpeakersToLoadObservable = Observable<Void>()
    var refreshDataObservable = Observable<Void>()

    weak var delegate: SpeakersViewControllerDelegate?
    var speakers = [Speaker]().bindable

    init(delegate: SpeakersViewControllerDelegate?) {
        self.delegate = delegate
        tableViewStateObservable = Observable<AppContentState>(.loading)

        setup()
    }

    private func setup() {
        speakerLoadDataRequestObservable.subscribeNext { [weak self] in
            self?.loadInitialData()
        }
        .add(to: disposeBag)

        checkIfLastSpeakerObservable.subscribeNext { [weak self] index in
            guard let weakSelf = self, weakSelf.speakers.values.count - 1 == index else { return }

            weakSelf.loadMoreData()
        }
        .add(to: disposeBag)

        tryToLoadMoreDataObservable.subscribeNext { [weak self] in
            self?.loadMoreData()
        }
        .add(to: disposeBag)

        refreshDataObservable.subscribeNext { [weak self] in
            self?.loadInitialData()
        }
        .add(to: disposeBag)
    }

    private func loadInitialData() {
        guard pendingRequest == nil else { return }

        pendingRequest = NetworkProvider.shared.speakersList(with: 1, perPage: Constants.speakersPerPage, query: "", order: Constants.speakersOrderCurrent) { [weak self] response in
            switch response {
            case let .success(responeObject):
                self?.speakers.values = []
                self?.speakers.append(responeObject.elements)
                self?.totalPage = responeObject.page.pageCount
                self?.currentPage = 1
                self?.loadLatestSpeakers()
            case .error:
                self?.tableViewStateObservable.next(.error)
                self?.refreshDataObservable.complete()
                self?.pendingRequest = nil
            }
        }
    }

    private func loadLatestSpeakers() {
        NetworkProvider.shared.speakersList(with: 1, perPage: Constants.speakersPerPage, order: Constants.speakersOrderLatest) { [weak self] response in
            switch response {
            case let .success(responseLatest):
                print("fetched do sth with this")
                self?.tableViewStateObservable.next(.content)
            case .error:
                self?.tableViewStateObservable.next(.error)
            }
            self?.refreshDataObservable.complete()
            self?.pendingRequest = nil
        }
    }

    private func loadMoreData() {
        guard pendingRequest == nil else { return }

        guard currentPage < totalPage || totalPage == -1 else {
            noMoreSpeakersToLoadObservable.next()
            return
        }

        pendingRequest = NetworkProvider.shared.speakersList(with: currentPage + 1, perPage: Constants.speakersPerPage, query: "", order: Constants.speakersOrderCurrent) { [weak self] response in
            switch response {
            case let .success(responeObject):
                self?.currentPage += 1
                self?.speakers.append(responeObject.elements)
                self?.totalPage = responeObject.page.pageCount
            default:
                self?.noMoreSpeakersToLoadObservable.next()
            }

            self?.pendingRequest = nil
        }
    }
}
