//
//  SpeakerLecturesTableViewCell.swift
//  LetSwift
//
//  Created by Marcin Chojnacki on 29.06.2017.
//  Copyright © 2017 Droids On Roids. All rights reserved.
//

import UIKit

class SpeakerLecturesTableViewCell: UITableViewCell, SpeakerLoadable {
    
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
    
    // MARK: Custom CollectionView pagination
    fileprivate func cellWidth(for collectionView: UICollectionView) -> CGFloat {
        guard let currentIndexPath = collectionView.indexPathsForVisibleItems.first else { return 0.0 }
        
        let exampleCell = collectionView.cellForItem(at: currentIndexPath)
        let cellWidth = exampleCell?.bounds.width ?? collectionView.bounds.width
        
        return cellWidth
    }
    
    fileprivate func cellMargin(for collectionView: UICollectionView) -> CGFloat {
        let flowLayout = collectionView.collectionViewLayout as? UICollectionViewFlowLayout
        let spacing = flowLayout?.minimumInteritemSpacing ?? 0.0
        
        return spacing
    }
    
    fileprivate func closestMultiplicity(of: CGFloat, to: CGFloat) -> CGFloat {
        let multiplicityCount = max((to / of).rounded(), 0.0)
        return multiplicityCount * of
    }
    
    fileprivate func offsetWithPagination(for collectionView: UICollectionView, target: CGFloat) -> CGPoint {
        let myCellWidth = cellWidth(for: collectionView)
        let myCellMargin = cellMargin(for: collectionView)
        let multiplicity = closestMultiplicity(of: myCellWidth + myCellMargin, to: target)
        
        let maxOffset = collectionView.contentSize.width - collectionView.bounds.width
        let newOffset = min(max(multiplicity - myCellMargin, 0.0), maxOffset)
        
        return CGPoint(x: newOffset, y: collectionView.contentOffset.y)
    }
}

extension SpeakerLecturesTableViewCell: Localizable {
    func setupLocalization() {
        titleLabel.text = localized("SPEAKERS_PARTICIPATED_IN").uppercased()
    }
}

extension SpeakerLecturesTableViewCell: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let sizeOffset: CGFloat = collectionView.numberOfItems(inSection: 0) > 1 ? 30.0 : 16.0
        return CGSize(width: UIScreen.main.bounds.width - sizeOffset, height: collectionView.bounds.height)
    }
    
    /*func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        guard let collectionView = scrollView as? UICollectionView else { return }
        collectionView.setContentOffset(offsetWithPagination(for: collectionView, target: collectionView.contentOffset.x), animated: true)
    }*/
    
    func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
        guard let collectionView = scrollView as? UICollectionView else { return }
        targetContentOffset.pointee = offsetWithPagination(for: collectionView, target: collectionView.contentOffset.x)
    }
}
