//
//  SpeakerBioTableViewCell.swift
//  LetSwift
//
//  Created by Marcin Chojnacki on 28.06.2017.
//  Copyright © 2017 Droids On Roids. All rights reserved.
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
