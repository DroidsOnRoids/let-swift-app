//
//  SpeakerHeaderTableViewCell.swift
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

final class SpeakerHeaderTableViewCell: UITableViewCell, SpeakerLoadable {
    
    private enum Constants {
        static let shadowInset: CGFloat = 10.0
        static let shadowOffset: CGFloat = 30.0
        static let shadowRadius: CGFloat = 15.0
    }
    
    static let cellIdentifier = String(describing: SpeakerHeaderTableViewCell.self)

    @IBOutlet private weak var avatarImageView: UIImageView!
    @IBOutlet private weak var nameLabel: AppLabel!
    @IBOutlet private weak var jobLabel: AppLabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setup()
    }
    
    func load(with speaker: Speaker) {
        avatarImageView.setImage(url: speaker.avatar?.thumb, errorPlaceholder: #imageLiteral(resourceName: "PhotoMock"))
        nameLabel.text = speaker.name
        jobLabel.text = speaker.job
            
        if !speaker.websites.isEmpty {
            removeSeparators()
        }
    }
    
    private func setup() {
        setupAvatarShadow()
    }
    
    private func setupAvatarShadow() {
        guard let shadowView = avatarImageView.superview else { return }
        
        let shadowRect = shadowView.bounds.insetBy(dx: Constants.shadowInset, dy: Constants.shadowOffset)
        shadowView.layer.shadowPath = UIBezierPath(rect: shadowRect).cgPath
        shadowView.addShadow(offset: CGSize(width: 0.0, height: Constants.shadowOffset), radius: Constants.shadowRadius)
    }
}
