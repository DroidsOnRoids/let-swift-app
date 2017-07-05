//
//  SpeakerLecturesTableViewCell.swift
//  LetSwift
//
//  Created by Marcin Chojnacki on 29.06.2017.
//  Copyright © 2017 Droids On Roids. All rights reserved.
//

import UIKit

final class SpeakerLecturesTableViewCell: UITableViewCell, SpeakerLoadable {
    
    fileprivate enum Constants {
        static let singleCardWidth: CGFloat = 16.0
        static let multipleCardWidth: CGFloat = 30.0
    }
    
    static let cellIdentifier = String(describing: SpeakerLecturesTableViewCell.self)
    
    let lectureDetailsObservable = Observable<Int?>(nil)
    
    @IBOutlet fileprivate weak var titleLabel: UILabel!
    @IBOutlet private weak var collectionView: UICollectionView!
    
    private let disposeBag = DisposeBag()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setup()
    }
    
    private func setup() {
        collectionView.delegate = self
        collectionView.registerClass(SpeakerCardCollectionViewCell.self, forCellReuseIdentifier: SpeakerCardCollectionViewCell.cellIdentifier)
        collectionView.decelerationRate = UIScrollViewDecelerationRateFast
        removeSeparators()
        setupLocalization()
    }
    
    func load(with speaker: Speaker) {
        speaker.talks.bindable.bind(to: collectionView.item(with: SpeakerCardCollectionViewCell.cellIdentifier, cellType: SpeakerCardCollectionViewCell.self) ({ [weak self] index, element, cell in
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
