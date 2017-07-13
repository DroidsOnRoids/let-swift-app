//
//  ReactiveCollectionViewDataSource.swift
//  LetSwift
//
//  Created by Kinga Wilczek on 05.05.2017.
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
        items = observedElements.map { $0 }

        collectionView.reloadData()
    }
}
