//
//  PreviousEventsListCell.swift
//  LetSwift
//
//  Created by Marcin Chojnacki, Kinga Wilczek on 28.04.2017.
//  Copyright © 2017 Droids On Roids. All rights reserved.
//

import UIKit

final class PreviousEventsListCell: UITableViewCell, Localizable {

    @IBOutlet private weak var eventsCollectionView: UICollectionView!
    @IBOutlet private weak var previousTitleLabel: UILabel!
    
    private let disposeBag = DisposeBag()

    var viewModel: PreviousEventsListCellViewModel! {
        didSet {
            if viewModel != nil && viewModel !== oldValue {
                reactiveSetup()
            }
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        setup()
    }
    
    private func setup() {
        separatorInset = UIEdgeInsets(top: 0.0, left: 0.0, bottom: 0.0, right: bounds.width)
        
        eventsCollectionView.register(UINib(nibName: PreviousEventCell.cellIdentifier, bundle: nil), forCellWithReuseIdentifier: PreviousEventCell.cellIdentifier)

        setupLocalization()
    }
    
    func setupLocalization() {
        previousTitleLabel.text = localized("EVENTS_PREVIOUS").uppercased()
    }

    private func reactiveSetup() {
        viewModel.previousEventsObservable.subscribeNext(startsWithInitialValue: true) { [weak self] events in
            guard let collectionView = self?.eventsCollectionView else { return }
            events?.bindable.bind(to: collectionView.item(with: PreviousEventCell.cellIdentifier, cellType: PreviousEventCell.self) ({ index, element, cell in
                cell.title = element.title
                cell.date = element.date?.stringDateValue
            }))
        }
        .add(to: disposeBag)

        eventsCollectionView.itemDidSelectObservable.subscribeNext { [weak self] indexPath in
            self?.viewModel.cellDidTapWithIndexObservable.next(indexPath.item)
        }
        .add(to: disposeBag)
    }
}
