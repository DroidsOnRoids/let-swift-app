//
//  LectureViewControllerViewModel.swift
//  LetSwift
//
//  Created by Marcin Chojnacki on 22.05.2017.
//  Copyright © 2017 Droids On Roids. All rights reserved.
//
//  Licensed under the Apache License, Version 2.0 (the "License");
//  you may not use this file except in compliance with the License.
//  You may obtain a copy of the License at
//
//       http://www.apache.org/licenses/LICENSE-2.0
//
//  Unless required by applicable law or agreed to in writing, software
//  distributed under the License is distributed on an "AS IS" BASIS,
//  WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
//  See the License for the specific language governing permissions and
//  limitations under the License.
//

import Foundation

final class LectureViewControllerViewModel {
    
    weak var delegate: SpeakerLectureFlowDelegate?
    
    let speakerAvatarURL: URL?
    let speakerName: String
    let speakerJob: String
    let eventDate: String
    let eventTime: String
    let lectureTitle: String
    let lectureSummary: String
    
    private let speakerId: Int?
    
    init(with talk: Talk, delegate: SpeakerLectureFlowDelegate?) {
        self.delegate = delegate
        
        self.speakerAvatarURL = talk.speaker?.avatar?.thumb
        self.speakerName = talk.speaker?.name ?? ""
        self.speakerJob = talk.speaker?.job ?? ""
        self.eventDate = talk.event?.date?.stringDateValue ?? ""
        self.eventTime = talk.event?.date?.stringTimeValue ?? ""
        self.lectureTitle = talk.title
        self.lectureSummary = talk.description ?? ""
        
        self.speakerId = talk.speaker?.id
    }
    
    @objc func speakerCellDidTap() {
        guard let speakerId = speakerId else { return }
        
        delegate?.presentSpeakerDetailsScreen(with: speakerId)
    }
}
