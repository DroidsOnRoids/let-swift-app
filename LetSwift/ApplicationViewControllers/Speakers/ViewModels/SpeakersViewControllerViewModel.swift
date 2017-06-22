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

    var speakerWithIndexRequestObservable = Observable<Int>(-1)
    var speakerWithIndexResponseObservable = Observable<ResponseSpeaker>(ResponseSpeaker(index: -1, speaker: nil))
    var speakersObservable: Observable<[Speaker]>

    weak var delegate: SpeakersViewControllerDelegate?

    init(speakers: [Speaker], delegate: SpeakersViewControllerDelegate?) {
        self.delegate = delegate
        speakersObservable = Observable<[Speaker]>(speakers)

        setup()
    }

    private func setup() {
        speakerWithIndexRequestObservable.subscribeNext { [weak self] index in
            guard let weakSelf = self, let speaker = weakSelf.speakersObservable.value[safe: index] else { return }

            weakSelf.speakerWithIndexResponseObservable.next((index, speaker))
        }
        .add(to: disposeBag)
    }
}
