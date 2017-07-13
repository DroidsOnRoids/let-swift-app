//
//  SpeakerBioTableViewCell.swift
//  LetSwift
//
//  Created by Marcin Chojnacki on 28.06.2017.
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

final class SpeakerBioTableViewCell: UITableViewCell, SpeakerLoadable {

    static let cellIdentifier = String(describing: SpeakerBioTableViewCell.self)
    
    @IBOutlet fileprivate weak var aboutLabel: AppLabel!
    @IBOutlet private weak var bioLabel: AppLabel!
    
    fileprivate var aboutFormat = "%@"
    
    func load(with speaker: Speaker) {
        aboutLabel.text = speaker.firstName
        bioLabel.text = speaker.bio
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setup()
    }
    
    private func setup() {
        removeSeparators()
        setupLocalization()
    }
}

extension SpeakerBioTableViewCell: Localizable {
    func setupLocalization() {
        aboutFormat = localized("SPEAKERS_ABOUT")
    }
}
