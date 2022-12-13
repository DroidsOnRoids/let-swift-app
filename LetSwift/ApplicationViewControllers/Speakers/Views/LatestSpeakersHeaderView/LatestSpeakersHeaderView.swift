//
//  LatestSpeakersHeaderView.swift
//  LetSwift
//
//  Created by Kinga Wilczek on 26.06.2017.
//  Copyright © 2017 Droids On Roids. All rights reserved.
//
//  Licensed under the Apache License, Version 2.0 (the "License");
//  you may not use this file except in compliance with the License.
//  You may obtain a copy of the License at
//
//       http://www.apache.org/licenses/LICENSE-2.0
//
//  Unless required by applicable law or agreed to in writing, software
//  distributed under the License is distributed on an "AS IS" BASIS,
//  WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
//  See the License for the specific language governing permissions and
//  limitations under the License.
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

        latestSpeakersTitleLabel.text = localized("SPEAKERS_LATEST_TITLE")
            .replacingPlaceholders(with: EventBranding.current.name)
            .uppercased()

        reactiveSetup()
    }

    private func reactiveSetup() {
        viewModel?.latestSpeakers.bind(to: latestCollectionView.item(with: LatestSpeakerCollectionViewCell.cellIdentifier, cellType: LatestSpeakerCollectionViewCell.self)({ _, element, cell in
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
