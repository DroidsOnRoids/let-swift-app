//
//  LatestSpeakersTableViewCell.swift
//  LetSwift
//
//  Created by Kinga Wilczek on 14.06.2017.
//  Copyright © 2017 Droids On Roids. All rights reserved.
//

import UIKit

class LatestSpeakersTableViewCell: UITableViewCell {

    @IBOutlet private weak var latestCollectionView: UICollectionView!
    @IBOutlet private weak var LatestSpeakersTitleLabel: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()

        latestCollectionView.registerCells([LatestSpeakerCollectionViewCell.self])

        ["sth", "sth"].bindable.bind(to: latestCollectionView.item(with: LatestSpeakerCollectionViewCell.cellIdentifier, cellType: LatestSpeakerCollectionViewCell.self) ({ index, element, cell in
            //TODO: fill with data
        }))

        let attributedString = NSMutableAttributedString(string: LatestSpeakersTitleLabel.text!)
        attributedString.addAttribute(NSKernAttributeName, value: CGFloat(0.7), range: NSRange(location: 0, length: attributedString.length))
        LatestSpeakersTitleLabel.attributedText = attributedString
    }
}
