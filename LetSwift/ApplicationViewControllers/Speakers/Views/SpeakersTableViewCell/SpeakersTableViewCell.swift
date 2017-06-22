//
//  SpeakersTableViewCell.swift
//  LetSwift
//
//  Created by Kinga Wilczek on 22.06.2017.
//  Copyright © 2017 Droids On Roids. All rights reserved.
//

import UIKit

class SpeakersTableViewCell: UITableViewCell {

    @IBOutlet private weak var speakerNameLabel: UILabel!
    @IBOutlet private weak var speakerJobLabel: UILabel!
    @IBOutlet private weak var speakerAvatarImageView: UIImageView!

    override func awakeFromNib() {
        super.awakeFromNib()
    }

    func load(with speaker: Speaker) {
        speakerNameLabel.text = speaker.name
        speakerJobLabel.text = speaker.job
        speakerAvatarImageView.sd_setImage(with: speaker.avatar?.thumb, placeholderImage: #imageLiteral(resourceName: "SpeakerPlaceholder"))
    }
}
