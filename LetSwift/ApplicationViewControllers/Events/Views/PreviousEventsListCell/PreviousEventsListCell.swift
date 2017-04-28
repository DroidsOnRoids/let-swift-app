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
    
    override func awakeFromNib() {
        let cellIdentifier = "PreviousEventCell"
        eventsCollectionView.register(UINib(nibName: cellIdentifier, bundle: nil), forCellWithReuseIdentifier: cellIdentifier)
        eventsCollectionView.dataSource = self
    }
}

extension PreviousEventsListCell: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 5
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        return collectionView.dequeueReusableCell(withReuseIdentifier: "PreviousEventCell", for: indexPath)
    }
}
