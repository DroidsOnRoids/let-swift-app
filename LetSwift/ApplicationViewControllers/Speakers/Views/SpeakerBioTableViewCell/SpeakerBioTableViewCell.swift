//
//  SpeakerBioTableViewCell.swift
//  LetSwift
//
//  Created by Marcin Chojnacki on 28.06.2017.
//  Copyright © 2017 Droids On Roids. All rights reserved.
//

import UIKit

final class SpeakerBioTableViewCell: UITableViewCell {

    static let cellIdentifier = String(describing: SpeakerBioTableViewCell.self)
    
    @IBOutlet fileprivate weak var aboutLabel: UILabel!
    @IBOutlet private weak var bioLabel: UILabel!
    
    fileprivate var aboutFormat = "%@"
    
    var speakerName: String? {
        didSet {
            if let speakerName = speakerName {
                aboutLabel.text = String(format: aboutFormat, speakerName)
            } else {
                aboutLabel.text = nil
            }
        }
    }
    
    var speakerBio: String? {
        get {
            return bioLabel.text
        }
        set {
            bioLabel.attributedText = newValue?.attributed(withSpacing: 0.9)
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setup()
    }
    
    private func setup() {
        setupLocalization()
    }
}

extension SpeakerBioTableViewCell: Localizable {
    func setupLocalization() {
        aboutFormat = localized("SPEAKERS_ABOUT")
    }
}
