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
    private var speakers = [Speaker]()

    var speakerWithIndexRequestObservable = Observable<Int>(-1)
    var speakerWithIndexResponseObservable = Observable<ResponseSpeaker>(ResponseSpeaker(index: -1, speaker: nil))
    var speakerLoadDataRequestObservable = Observable<Void>()
    var currentNumberOfSpeaker = Observable<Int>(-1)
    var tableViewStateObservable: Observable<AppContentState>

    weak var delegate: SpeakersViewControllerDelegate?

    init(delegate: SpeakersViewControllerDelegate?) {
        self.delegate = delegate
        tableViewStateObservable = Observable<AppContentState>(.loading)

        setup()
    }

    private func setup() {
        speakerWithIndexRequestObservable.subscribeNext { [weak self] index in
            guard let weakSelf = self, let speaker = weakSelf.speakers[safe: index] else { return }

            weakSelf.speakerWithIndexResponseObservable.next((index, speaker))
        }
        .add(to: disposeBag)

        speakerLoadDataRequestObservable.subscribeNext {
            //TODO: establish number of speakers per page
            NetworkProvider.shared.speakersList(with: 1, perPage: 5, query: nil) { [weak self] response in
                switch response {
                case let .success(responeObject):
                    self?.speakers = responeObject.elements
                    self?.totalPage = responeObject.page.pageCount
                    self?.currentNumberOfSpeaker.next(self?.speakers.count ?? -1)
                    self?.tableViewStateObservable.next(.content)
                    self?.currentPage = 1
                case .error:
                    self?.tableViewStateObservable.next(.error)
                }
            }
        }
        .add(to: disposeBag)

    }


}
