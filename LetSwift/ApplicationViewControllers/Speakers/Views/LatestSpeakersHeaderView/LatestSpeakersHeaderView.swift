//
//  LatestSpeakersHeaderView.swift
//  LetSwift
//
//  Created by Kinga Wilczek on 26.06.2017.
//  Copyright © 2017 Droids On Roids. All rights reserved.
//

import UIKit

final class LatestSpeakersHeaderView: DesignableView {

    private let mockedSpeakers: [Speaker] = Speaker.from(MockLoader.speakersMock!)!

    @IBOutlet private weak var latestCollectionView: UICollectionView!
    @IBOutlet private weak var latestSpeakersTitleLabel: UILabel!

    override func loadViewFromNib() {
        super.loadViewFromNib()

        setup()
    }

    private func setup() {
        latestCollectionView.collectionViewLayout = AppCollectionViewFlowLayout(with: 180.0)
        latestCollectionView.registerCells([LatestSpeakerCollectionViewCell.self])

        latestSpeakersTitleLabel.text = localized("SPEAKERS_LATEST_TITLE").uppercased()
        latestSpeakersTitleLabel.attributedText = latestSpeakersTitleLabel.text?.attributed(withSpacing: 0.7)

        reactiveSetup()
    }

    private func reactiveSetup() {
        Array(mockedSpeakers[0..<5]).bindable.bind(to: latestCollectionView.item(with: LatestSpeakerCollectionViewCell.cellIdentifier, cellType: LatestSpeakerCollectionViewCell.self) ({ index, element, cell in
            cell.load(with: element)
        }))
    }
}
