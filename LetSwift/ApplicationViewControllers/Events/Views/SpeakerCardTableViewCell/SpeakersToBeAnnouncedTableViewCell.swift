//
//  SpeakersToBeAnnouncedTableViewCell.swift
//  LetSwift
//
//  Created by Kinga Wilczek on 25.05.2017.
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

final class SpeakersToBeAnnouncedTableViewCell: UITableViewCell {

    @IBOutlet private weak var labelBackgroundView: UIView!
    @IBOutlet fileprivate weak var descriptionLabel: AppLabel!

    override func awakeFromNib() {
        super.awakeFromNib()

        setup()
    }

    private func setup() {
        labelBackgroundView.layer.shadowColor = UIColor.black.cgColor
        labelBackgroundView.layer.shadowOpacity = 0.1
        labelBackgroundView.layer.shadowOffset = CGSize(width: 0.0, height: 5.0)
        labelBackgroundView.layer.shadowRadius = 10.0

        setupLocalization()
    }
}

extension SpeakersToBeAnnouncedTableViewCell: Localizable {
    func setupLocalization() {
        descriptionLabel.text = localized("EVENTS_TO_BE_ANNOUNCED").uppercased()
    }
}
