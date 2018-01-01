//
//  SpeakerLecturesTableViewCell.swift
//  LetSwift
//
//  Created by Marcin Chojnacki on 29.06.2017.
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

final class SpeakerLecturesTableViewCell: UITableViewCell, SpeakerLoadable {
    
    private enum Constants {
        static let singleCardWidth: CGFloat = 16.0
        static let multipleCardWidth: CGFloat = 30.0
    }
    
    static let cellIdentifier = String(describing: SpeakerLecturesTableViewCell.self)
    
    var lectureDetailsObservable = Observable<Int?>(nil)
    
    @IBOutlet private weak var titleLabel: AppLabel!
    @IBOutlet private weak var collectionView: UICollectionView!
    
    private let disposeBag = DisposeBag()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setup()
    }
    
    private func setup() {
        collectionView.delegate = self
        collectionView.register(SpeakerCardCollectionViewCell.self, forCellReuseIdentifier: SpeakerCardCollectionViewCell.cellIdentifier)
        collectionView.decelerationRate = UIScrollViewDecelerationRateFast
        collectionView.canCancelContentTouches = true
        removeSeparators()
        setupLocalization()
    }
    
    func load(with speaker: Speaker) {
        lectureDetailsObservable = Observable<Int?>(nil)
        
        speaker.talks.bindable.bind(to: collectionView.item(with: SpeakerCardCollectionViewCell.cellIdentifier, cellType: SpeakerCardCollectionViewCell.self) ({ [weak self] _, element, cell in
            guard let weakSelf = self else { return }
            
            cell.load(with: speaker, talk: element)
            cell.lectureDetailsObservable
                .bindNext(to: weakSelf.lectureDetailsObservable)
                .add(to: weakSelf.disposeBag)
        }))
    }
}

extension SpeakerLecturesTableViewCell: Localizable {
    func setupLocalization() {
        titleLabel.text = localized("SPEAKERS_PARTICIPATED_IN").uppercased()
    }
}

extension SpeakerLecturesTableViewCell: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let sizeOffset: CGFloat = collectionView.numberOfItems(inSection: 0) > 1 ? Constants.multipleCardWidth : Constants.singleCardWidth
        return CGSize(width: UIScreen.main.bounds.width - sizeOffset, height: collectionView.bounds.height)
    }
    
    func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
        guard let collectionView = scrollView as? UICollectionView else { return }
        targetContentOffset.pointee = collectionView.offsetWithPagination(target: targetContentOffset.pointee.x)
    }
}
