//
//  SpeakerCardHeaderCell.swift
//  LetSwift
//
//  Created by Marcin Chojnacki on 11.05.2017.
//  Copyright © 2017 Droids On Roids. All rights reserved.
//

import UIKit

final class SpeakerCardHeaderCell: UITableViewCell, Localizable {

    @IBOutlet private weak var speakersLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        setup()
    }
    
    private func setup() {
        removeSeparators()

        setupLocalization()
    }
    
    func setupLocalization() {
        speakersLabel.text = localized("SPEAKERS_TITLE").uppercased()
    }
}
