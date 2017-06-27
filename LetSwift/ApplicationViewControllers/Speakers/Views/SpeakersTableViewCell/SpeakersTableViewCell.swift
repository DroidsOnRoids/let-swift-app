//
//  SpeakersTableViewCell.swift
//  LetSwift
//
//  Created by Kinga Wilczek on 22.06.2017.
//  Copyright © 2017 Droids On Roids. All rights reserved.
//

import UIKit

final class SpeakersTableViewCell: UITableViewCell {

    static let cellIdentifier = String(describing: SpeakersTableViewCell.self)

    @IBOutlet private weak var speakerNameLabel: UILabel!
    @IBOutlet private weak var speakerJobLabel: UILabel!
    @IBOutlet private weak var speakerAvatarImageView: UIImageView!

    override func prepareForReuse() {
        super.prepareForReuse()

        speakerNameLabel.text = ""
        speakerJobLabel.text = ""
        speakerAvatarImageView.image = #imageLiteral(resourceName: "SpeakerPlaceholder")
    }

    func load(with speaker: Speaker) {
        speakerNameLabel.text = speaker.name
        speakerJobLabel.text = speaker.job
        speakerAvatarImageView.sd_setImage(with: speaker.avatar?.thumb, placeholderImage: #imageLiteral(resourceName: "SpeakerPlaceholder"))
    }
}
