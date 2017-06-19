//
//  LatestSpeakersTableViewCell.swift
//  LetSwift
//
//  Created by Kinga Wilczek on 14.06.2017.
//  Copyright © 2017 Droids On Roids. All rights reserved.
//

import UIKit

final class LatestSpeakersTableViewCell: UITableViewCell {

    private let mockedSpeakers: [Speaker] = Speaker.from(MockLoader.speakersMock!)!

    @IBOutlet private weak var latestCollectionView: UICollectionView!
    @IBOutlet private weak var LatestSpeakersTitleLabel: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()

        setup()
    }

    private func setup() {
        latestCollectionView.registerCells([LatestSpeakerCollectionViewCell.self])

        LatestSpeakersTitleLabel.attributedText = LatestSpeakersTitleLabel.text?.attributed(withSpacing: 0.7)

        reactiveSetup()
    }

    private func reactiveSetup() {
        Array(mockedSpeakers[0..<5]).bindable.bind(to: latestCollectionView.item(with: LatestSpeakerCollectionViewCell.cellIdentifier, cellType: LatestSpeakerCollectionViewCell.self) ({ index, element, cell in
            cell.load(with: element)
        }))
    }
}
