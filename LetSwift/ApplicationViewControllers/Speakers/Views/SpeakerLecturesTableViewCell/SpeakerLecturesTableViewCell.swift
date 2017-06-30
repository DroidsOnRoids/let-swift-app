//
//  SpeakerLecturesTableViewCell.swift
//  LetSwift
//
//  Created by Marcin Chojnacki on 29.06.2017.
//  Copyright © 2017 Droids On Roids. All rights reserved.
//

import UIKit

class SpeakerLecturesTableViewCell: UITableViewCell {
    
    static let cellIdentifier = String(describing: SpeakerLecturesTableViewCell.self)
    
    @IBOutlet fileprivate weak var titleLabel: UILabel!
    @IBOutlet private weak var collectionView: UICollectionView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setup()
    }
    
    private func setup() {
        collectionView.delegate = self
        collectionView.registerClass(SpeakerCardCollectionViewCell.self, forCellReuseIdentifier: SpeakerCardCollectionViewCell.cellIdentifier)
        removeSeparators()
        
        setupLocalization()
        reactiveSetup()
    }
    
    private func reactiveSetup() {
        ["asdf", "sd", "dfwf"].bindable.bind(to: collectionView.item(with: SpeakerCardCollectionViewCell.cellIdentifier, cellType: SpeakerCardCollectionViewCell.self) ({ index, element, cell in
            //cell.load(with: element)
        }))
    }
}

extension SpeakerLecturesTableViewCell: Localizable {
    func setupLocalization() {
        titleLabel.text = localized("SPEAKERS_PARTICIPATED_IN").uppercased()
    }
}

extension SpeakerLecturesTableViewCell: UICollectionViewDelegateFlowLayout {
//    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
//        viewModel?.latestSpeakerCellDidTapWithIndexObservable.next(indexPath.row)
//    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let sizeOffset: CGFloat = collectionView.numberOfItems(inSection: 0) > 1 ? 30.0 : 16.0
        return CGSize(width: UIScreen.main.bounds.width - sizeOffset, height: collectionView.bounds.height)
    }
}
