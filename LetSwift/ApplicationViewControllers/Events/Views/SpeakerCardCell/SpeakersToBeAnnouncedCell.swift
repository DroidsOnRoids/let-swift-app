//
//  SpeakersToBeAnnouncedCell.swift
//  LetSwift
//
//  Created by Kinga Wilczek on 25.05.2017.
//  Copyright © 2017 Droids On Roids. All rights reserved.
//

import UIKit

final class SpeakersToBeAnnouncedCell: UITableViewCell {

    @IBOutlet private weak var labelBackgroundView: UIView!
    @IBOutlet fileprivate weak var descriptionLabel: UILabel!

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

extension SpeakersToBeAnnouncedCell: Localizable {
    func setupLocalization() {
        descriptionLabel.text = localized("EVENTS_TO_BE_ANNOUNCED").uppercased()
    }
}
