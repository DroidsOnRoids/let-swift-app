//
//  ReactiveCollectionViewDataSource.swift
//  LetSwift
//
//  Created by Kinga Wilczek on 05.05.2017.
//  Copyright © 2017 Droids On Roids. All rights reserved.
//

import UIKit

final class ReactiveCollectionViewDataSource<S: Sequence>: NSObject, UICollectionViewDataSource {

    typealias CellFormer = (UICollectionView, Int, S.Iterator.Element) -> UICollectionViewCell

    private var cellFormer: CellFormer

    private var items: [S.Iterator.Element] = []

    init(cellFormer: @escaping CellFormer) {
        self.cellFormer = cellFormer
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return items.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        return cellFormer(collectionView, indexPath.item, items[indexPath.row])
    }

    func collectionView(_ collectionView: UICollectionView, observedElements: S) {
        items = observedElements.map({ $0 })

        DispatchQueue.main.async {
            collectionView.reloadData()
        }
    }
}
