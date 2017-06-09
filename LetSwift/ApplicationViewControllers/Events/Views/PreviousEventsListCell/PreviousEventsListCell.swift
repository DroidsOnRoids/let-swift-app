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

        eventsCollectionView.registerCells([PreviousEventCell.self, LoadingCollectionViewCell.self])

        setupLocalization()
    }
    
    func setupLocalization() {
        previousTitleLabel.text = localized("EVENTS_PREVIOUS").uppercased()
    }

    private func reactiveSetup() {
        viewModel.previousEventsObservable.subscribeNext(startsWithInitialValue: true) { [weak self] events in
            guard let collectionView = self?.eventsCollectionView else { return }
            events?.bindable.bind(to: collectionView.items() ({ collectionView, index, element in
                let indexPath = IndexPath(row: index, section: 0)

                if let event = element {
                    let cell = collectionView.dequeueReusableCell(withReuseIdentifier: PreviousEventCell.cellIdentifier, for: indexPath) as! PreviousEventCell
                    cell.imageURL = event.coverImages.first?.thumb
                    cell.title = event.title
                    cell.date = event.date?.stringDateValue

                    return cell
                } else {
                    let cell = collectionView.dequeueReusableCell(withReuseIdentifier: LoadingCollectionViewCell.cellIdentifier, for: indexPath) as! LoadingCollectionViewCell
                    cell.animateSpinner()
                    
                    return cell
                }
            }))
        }
        .add(to: disposeBag)

        eventsCollectionView.itemDidSelectObservable.subscribeNext { [weak self] indexPath in
            self?.viewModel.cellDidTapWithIndexObservable.next(indexPath.item)
        }
        .add(to: disposeBag)

        eventsCollectionView.scrollViewDidScrollObservable.subscribeNext { [weak self] scrollView in
            guard let scrollView = scrollView else { return }
            let offset = scrollView.contentOffset
            let boundsWidth = scrollView.bounds.width
            let insets = scrollView.contentInset
            let y = offset.x + boundsWidth - insets.right
            let additonalSpace: CGFloat = 70.0

            if (y > scrollView.contentSize.width + additonalSpace) {
                self?.viewModel.previousEventsRefreshObservable.next()
            }
        }
        .add(to: disposeBag)

        viewModel.shouldScrollToFirstObservable.subscribeNext { [weak self] in
            self?.eventsCollectionView.scrollToItem(at: IndexPath(row: 0, section: 0), at: .right, animated: false)
        }
        .add(to: disposeBag)
    }
}
