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
    @IBOutlet private weak var spinnerView: SpinnerView!
    @IBOutlet private weak var scrollViewTrailingConstraint: NSLayoutConstraint!

    private var isMoreEventsRequested = false
    private var isScrollViewDragging = false
    private let disposeBag = DisposeBag()

    var viewModel: PreviousEventsListCellViewModel! {
        didSet {
            if viewModel != nil && viewModel !== oldValue {
                reactiveSetup()
            }
        }
    }

    var isSpinnerVisibleOnScreen: Bool {
        return bounds.contains(convert(spinnerView.bounds, from: spinnerView))
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()

        setup()
    }
    
    private func setup() {
        separatorInset = UIEdgeInsets(top: 0.0, left: 0.0, bottom: 0.0, right: bounds.width)

        eventsCollectionView.registerCells([PreviousEventCell.self])

        spinnerView.image = #imageLiteral(resourceName: "WhiteSpinner")
        spinnerView.backgroundColor = .clear

        setupLocalization()
    }
    
    func setupLocalization() {
        previousTitleLabel.text = localized("EVENTS_PREVIOUS").uppercased()
    }

    private func reactiveSetup() {
        viewModel.previousEventsObservable.subscribeNext(startsWithInitialValue: true) { [weak self] events in
            self?.scrollViewMoveWithAnimation(about: 0.0)
            self?.spinnerView.animationActive = true

            guard let collectionView = self?.eventsCollectionView else { return }
            events?.bindable.bind(to: collectionView.item(with: PreviousEventCell.cellIdentifier, cellType: PreviousEventCell.self) ({ index, element, cell in
                cell.title = element?.title
                cell.date = element?.date?.stringDateValue
            }))
        }
        .add(to: disposeBag)

        eventsCollectionView.itemDidSelectObservable.subscribeNext { [weak self] indexPath in
            self?.viewModel.cellDidTapWithIndexObservable.next(indexPath.item)
        }
        .add(to: disposeBag)

        eventsCollectionView.scrollViewDidScrollObservable.subscribeNext { [weak self] scrollView in
            guard let scrollView = scrollView, let weakSelf = self else { return }

            let boundsWidth = scrollView.bounds.width
            let insets = scrollView.contentInset
            let y = scrollView.contentOffset.x + boundsWidth - insets.right
            let additonalSpace: CGFloat = 65.0
            let spinnerOffset = y - scrollView.contentSize.width

            UIView.animate(withDuration: 0.01) {
                self?.spinnerView.transform = CGAffineTransform(translationX: -spinnerOffset, y: 0.0)
            }

            if (y > scrollView.contentSize.width + additonalSpace) && !weakSelf.spinnerView.isHidden {
                if weakSelf.isScrollViewDragging {
                    weakSelf.isMoreEventsRequested = true
                } else {
                    weakSelf.scrollViewMoveWithAnimation(about: 60.0)
                    weakSelf.viewModel.morePreviousEventsRequestObervable.next()
                }
            }
        }
        .add(to: disposeBag)

        eventsCollectionView.scrollViewWillEndDraggingObservable.subscribeNext { [weak self] in
            guard let weakSelf = self else { return }

            weakSelf.isScrollViewDragging = false
            if weakSelf.isMoreEventsRequested && !weakSelf.spinnerView.isHidden && weakSelf.isSpinnerVisibleOnScreen {
                DispatchQueue.main.async {
                    weakSelf.scrollViewMoveWithAnimation(about: 60.0)
                }
                weakSelf.viewModel.morePreviousEventsRequestObervable.next()
                weakSelf.isMoreEventsRequested = false
            } else {
                weakSelf.scrollViewMoveWithAnimation(about: 0.0)
                weakSelf.viewModel.morePreviousEventsRequestCanceledObservable.next()
                weakSelf.isMoreEventsRequested = false
            }
        }
        .add(to: disposeBag)

        eventsCollectionView.scrollViewWillBeginDraggingObservable.subscribeNext { [weak self] in
            self?.isScrollViewDragging = true
        }
        .add(to: disposeBag)

        viewModel.shouldScrollToFirstObservable.subscribeNext { [weak self] in
            self?.restartCellState()
        }
        .add(to: disposeBag)

        viewModel.morePreviousEventsAvilabilityObservable.subscribeNext { [weak self] available in
            self?.spinner(enable: available)
        }
        .add(to: disposeBag)

        viewModel.morePreviousEventsRequestSentObservable.subscribeNext { [weak self] index in
            self?.eventsCollectionView.scrollToItem(at: IndexPath(row: index, section: 0), at: .centeredHorizontally, animated: true)
        }
        .add(to: disposeBag)
        
    }

    private func restartCellState() {
        eventsCollectionView.scrollToItem(at: IndexPath(row: 0, section: 0), at: .right, animated: false)
        spinnerView.isHidden = false
    }

    private func spinner(enable: Bool) {
        DispatchQueue.main.async {
            UIView.animate(withDuration: 0.25, animations: {
                self.scrollViewTrailingConstraint.constant = 0
                self.layoutIfNeeded()
            }, completion: { _ in
                self.spinnerView.isHidden = !enable
                self.scrollViewTrailingConstraint.constant = 0
            })
        }
    }

    private func scrollViewMoveWithAnimation(about space: CGFloat) {
        UIView.animate(withDuration: 0.25) {
            self.scrollViewTrailingConstraint.constant = space
            self.layoutIfNeeded()
        }
    }
}
