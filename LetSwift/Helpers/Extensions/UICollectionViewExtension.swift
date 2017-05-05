//
//  UICollectionViewCell.swift
//  LetSwift
//
//  Created by Kinga Wilczek on 05.05.2017.
//  Copyright © 2017 Droids On Roids. All rights reserved.
//

import UIKit

extension UICollectionView {
    func item<Cell: UICollectionViewCell, T, S: Sequence>(with identifier: String, cellType: Cell.Type = Cell.self)
        -> (@escaping (Int, T, Cell) -> ())
        -> (_ source: S)
        -> () where T == S.Iterator.Element {
            return { cellFormer in
                return { source in
                    DispatchQueue.global(qos: .background).async {
                        let delegate = ReactiveCollectionViewDataSource<S> { collectionView, index, element in
                            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: identifier, for: IndexPath(row: index, section: 0)) as! Cell
                            cellFormer(index, element, cell)
                            return cell
                        }
                        ReactiveCollectionViewDataSourceProxy.subscribeToProxy(collectionView: self, datasource: delegate) { proxy in
                            delegate.collectionView(self, observedElements: source)
                        }
                    }
                }
            }
    }

    func items<S: Sequence>()
        -> (@escaping (UICollectionView, Int, S.Iterator.Element) -> UICollectionViewCell)
        -> (_ source: S)
        -> () {
            return { cellFormer in
                return { source in
                    DispatchQueue.global(qos: .background).async {
                        let delegate = ReactiveCollectionViewDataSource<S>(cellFormer: cellFormer)
                        ReactiveCollectionViewDataSourceProxy.subscribeToProxy(collectionView: self, datasource: delegate) { proxy in
                            delegate.collectionView(self, observedElements: source)
                        }
                    }
                }
            }
    }

    func createDataSourceProxy() -> ReactiveCollectionViewDataSourceProxy {
        return ReactiveCollectionViewDataSourceProxy()
    }
}
