//
//  LatestSpeakersHeaderView.swift
//  LetSwift
//
//  Created by Kinga Wilczek on 26.06.2017.
//  Copyright © 2017 Droids On Roids. All rights reserved.
//

import UIKit

final class LatestSpeakersHeaderView: DesignableView {

    private let disposeBag = DisposeBag()

    var viewModel: SpeakersViewControllerViewModel? {
        didSet {
            if let _ = viewModel {
                setup()
            }
        }
    }

    @IBOutlet private weak var latestCollectionView: UICollectionView!
    @IBOutlet private weak var latestSpeakersTitleLabel: AppLabel!

    private func setup() {
        latestCollectionView.delegate = self
        latestCollectionView.registerCells([LatestSpeakerCollectionViewCell.self])

        latestSpeakersTitleLabel.text = localized("SPEAKERS_LATEST_TITLE").uppercased()
        latestSpeakersTitleLabel.attributedText = latestSpeakersTitleLabel.text?.attributed(withSpacing: 0.7)

        reactiveSetup()
    }

    private func reactiveSetup() {
        viewModel?.latestSpeakers.bind(to: latestCollectionView.item(with: LatestSpeakerCollectionViewCell.cellIdentifier, cellType: LatestSpeakerCollectionViewCell.self) ({ index, element, cell in
            cell.load(with: element)
        }))
    }
}

extension LatestSpeakersHeaderView: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        viewModel?.latestSpeakerCellDidTapWithIndexObservable.next(indexPath.row)
        viewModel?.searchBarShouldResignFirstResponderObservable.next()
        
        collectionView.deselectItem(at: indexPath, animated: false)
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: UIScreen.main.bounds.width * 0.4, height: collectionView.bounds.height)
    }
}
