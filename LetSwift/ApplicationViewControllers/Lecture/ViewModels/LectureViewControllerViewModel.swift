//
//  LectureViewControllerViewModel.swift
//  LetSwift
//
//  Created by Marcin Chojnacki on 22.05.2017.
//  Copyright © 2017 Droids On Roids. All rights reserved.
//

import Foundation

final class LectureViewControllerViewModel {
    
    weak var delegate: LectureViewControllerDelegate?
    
    let shouldAllowTappingSpeaker: Observable<Bool>?
    let talkObservable: Observable<Talk>
    
    init(with talk: Talk, delegate: LectureViewControllerDelegate?) {
        self.delegate = delegate
        shouldAllowTappingSpeaker = Observable<Bool>(delegate != nil)
        talkObservable = Observable<Talk>(talk)
        setup()
    }
    
    @objc func speakerCellTapped() {
        delegate?.presentSpeakerDetailsScreen()
    }
    
    private func setup() {
        // TODO: implement
    }
}
