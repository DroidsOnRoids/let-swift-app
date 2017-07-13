//
//  SpeakerCardListCell.swift
//  LetSwift
//
//  Created by Marcin Chojnacki on 11.05.2017.
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

import UIKit

final class SpeakerCardTableViewCell: UITableViewCell {
    
    @IBOutlet weak var card: SpeakerCardView!
    
    private var speakerTapListener: (() -> Void)?
    private var readMoreTapListener: (() -> Void)?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        setup()
    }
    
    private func setup() {
        removeSeparators()

        card.addSpeakerTapTarget(target: self, action: #selector(speakerDidTap))
        card.addReadMoreTapTarget(target: self, action: #selector(readMoreDidTap))
    }

    func loadData(with model: Talk) {
        card.lectureSummary = model.description
        card.lectureTitle = model.title
        card.speakerName = model.speaker?.name
        card.speakerTitle = model.speaker?.job
        card.speakerImageURL = model.speaker?.avatar?.thumb
    }

    func addTapListeners(speaker: @escaping () -> Void, readMore: @escaping () -> Void) {
        speakerTapListener = speaker
        readMoreTapListener = readMore
    }
    
    @objc private func speakerDidTap() {
        speakerTapListener?()
    }
    
    @objc private func readMoreDidTap() {
        readMoreTapListener?()
    }
}
