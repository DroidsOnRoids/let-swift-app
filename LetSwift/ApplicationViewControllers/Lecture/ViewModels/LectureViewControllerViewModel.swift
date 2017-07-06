//
//  LectureViewControllerViewModel.swift
//  LetSwift
//
//  Created by Marcin Chojnacki on 22.05.2017.
//  Copyright © 2017 Droids On Roids. All rights reserved.
//

import Foundation

final class LectureViewControllerViewModel {
    
    weak var delegate: SpeakerLectureFlowDelegate?
    
    let talkObservable: Observable<Talk>
    
    init(with talk: Talk, delegate: SpeakerLectureFlowDelegate?) {
        self.delegate = delegate
        talkObservable = Observable<Talk>(talk)
    }
    
    @objc func speakerCellTapped() {
        guard let speakerId = talkObservable.value.speaker?.id else { return }
        delegate?.presentSpeakerDetailsScreen(with: speakerId)
    }
}
