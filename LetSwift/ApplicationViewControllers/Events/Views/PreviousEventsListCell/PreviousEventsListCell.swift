//
//  PreviousEventsListCell.swift
//  LetSwift
//
//  Created by Marcin Chojnacki on 28.04.2017.
//  Copyright © 2017 Droids On Roids. All rights reserved.
//

import UIKit

final class PreviousEventsListCell: UITableViewCell {

    @IBOutlet private weak var eventsCollectionView: UICollectionView!

    var viewModel: PreviousEventsListCellViewModel! {
        didSet {
            reactiveSetup()
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        setup()
    }
    
    private func setup() {
        eventsCollectionView.register(UINib(nibName: PreviousEventCell.cellIdentifier, bundle: nil), forCellWithReuseIdentifier: PreviousEventCell.cellIdentifier)
    }

    private func reactiveSetup() {
        if viewModel != nil {
            viewModel.previousEvents.subscribe(startsWithInitialValue: true) { [weak self] events in
                guard let collectionView = self?.eventsCollectionView else { return }
                events.bindable.bind(to: collectionView.item(with: PreviousEventCell.cellIdentifier, cellType: PreviousEventCell.self) ({ configuration in
                }))
            }
        }
    }
}
