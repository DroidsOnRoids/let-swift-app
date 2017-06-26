//
//  SpeakersViewControllerViewModel.swift
//  LetSwift
//
//  Created by Kinga Wilczek on 14.06.2017.
//  Copyright © 2017 Droids On Roids. All rights reserved.
//

import Foundation

final class SpeakersViewControllerViewModel {

    typealias ResponseSpeaker = (index: Int, speaker: Speaker?)

    private let disposeBag = DisposeBag()
    private var currentPage = 1
    private var totalPage = -1

    var speakerLoadDataRequestObservable = Observable<Void>()
    var tableViewStateObservable: Observable<AppContentState>
    var checkIfLastSpeakerObservable = Observable<Int>(-1)
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
            NetworkProvider.shared.speakersList(with: 1, perPage: 10, query: "") { [weak self] response in
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
            guard let weakSelf = self, weakSelf.currentPage < weakSelf.totalPage || weakSelf.totalPage == -1 else {
                self?.noMoreSpeakersToLoad.next()
                return
            }

            guard weakSelf.speakers.values.count - 1 == index else { return }

            NetworkProvider.shared.speakersList(with: weakSelf.currentPage + 1, perPage: 10, query: "") { response in
                switch response {
                case let .success(responeObject):
                    weakSelf.currentPage += 1
                    weakSelf.speakers.append(responeObject.elements)
                    weakSelf.totalPage = responeObject.page.pageCount
                default: break //TODO: remember about error
                }
            }
        }
        .add(to: disposeBag)
    }


}
