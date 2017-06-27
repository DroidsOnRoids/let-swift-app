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

    enum Constants {
        static let speakersOrderCurrent = "current"
    }

    typealias ResponseSpeaker = (index: Int, speaker: Speaker?)

    private let disposeBag = DisposeBag()
    private var currentPage = 1
    private var totalPage = -1
    private var pendingRequest: Request?

    var speakerLoadDataRequestObservable = Observable<Void>()
    var tableViewStateObservable: Observable<AppContentState>
    var checkIfLastSpeakerObservable = Observable<Int>(-1)
    var tryToLoadMoreData = Observable<Void>()
    var noMoreSpeakersToLoad = Observable<Void>()

    weak var delegate: SpeakersViewControllerDelegate?
    var speakers = [Speaker]().bindable

    init(delegate: SpeakersViewControllerDelegate?) {
        self.delegate = delegate
        tableViewStateObservable = Observable<AppContentState>(.loading)

        setup()
    }

    private func setup() {
        speakerLoadDataRequestObservable.subscribeNext {
            //TODO: establish number of speakers per page
            NetworkProvider.shared.speakersList(with: 1, perPage: 10, query: "", order: "current") { [weak self] response in
                switch response {
                case let .success(responeObject):
                    self?.speakers.values = []
                    self?.speakers.append(responeObject.elements)
                    self?.totalPage = responeObject.page.pageCount
                    self?.tableViewStateObservable.next(.content)
                    self?.currentPage = 1
                case .error:
                    self?.tableViewStateObservable.next(.error)
                }
            }
        }
        .add(to: disposeBag)

        checkIfLastSpeakerObservable.subscribeNext { [weak self] index in
            guard let weakSelf = self, weakSelf.speakers.values.count - 1 == index else { return }

            weakSelf.loadMoreData()
        }
        .add(to: disposeBag)

        tryToLoadMoreData.subscribeNext { [weak self] in
            self?.loadMoreData()
        }
        .add(to: disposeBag)
    }

    private func loadMoreData() {
        guard pendingRequest == nil else { return }

        guard currentPage < totalPage || totalPage == -1 else {
            noMoreSpeakersToLoad.next()
            return
        }

        pendingRequest = NetworkProvider.shared.speakersList(with: currentPage + 1, perPage: 10, query: "", order: Constants.speakersOrderCurrent) { [weak self] response in
            switch response {
            case let .success(responeObject):
                self?.currentPage += 1
                self?.speakers.append(responeObject.elements)
                self?.totalPage = responeObject.page.pageCount
            default:
                self?.noMoreSpeakersToLoad.next()
            }

            self?.pendingRequest = nil
        }
    }
}
