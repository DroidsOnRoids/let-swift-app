//
//  UICollectionViewCell.swift
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

extension UICollectionView: NibPresentable {
    func item<Cell: UICollectionViewCell, T, S: Sequence>(with identifier: String, cellType: Cell.Type = Cell.self)
        -> (((Int, T, Cell) -> ())?)
        -> (_ source: S)
        -> () where T == S.Iterator.Element {
            return { cellFormer in
                return { source in
                    let delegate = ReactiveCollectionViewDataSource<S> { collectionView, index, element in
                        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: identifier, for: IndexPath(row: index, section: 0)) as! Cell
                        cellFormer?(index, element, cell)
                        return cell
                    }
                    ReactiveCollectionViewDataSourceProxy.subscribeToProxy(collectionView: self, datasource: delegate) { _ in
                        delegate.collectionView(self, observedElements: source)
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
                    let delegate = ReactiveCollectionViewDataSource<S>(cellFormer: cellFormer)
                    ReactiveCollectionViewDataSourceProxy.subscribeToProxy(collectionView: self, datasource: delegate) { _ in
                        delegate.collectionView(self, observedElements: source)
                    }
                }
            }
    }

    func createDataSourceProxy() -> ReactiveCollectionViewDataSourceProxy {
        return ReactiveCollectionViewDataSourceProxy()
    }

    func createDelegateProxy() -> ReactiveCollectionViewDelegateProxy {
        return ReactiveCollectionViewDelegateProxy()
    }

    var delegateProxy: ReactiveCollectionViewDelegateProxy {
        return ReactiveCollectionViewDelegateProxy.proxyForObject(self)
    }

    var itemDidSelectObservable: ObservableEvent<IndexPath> {
        return ObservableEvent(event: delegateProxy.itemDidSelectObservable)
    }

    var scrollViewDidScrollObservable: ObservableEvent<UIScrollView?> {
        return ObservableEvent(event: delegateProxy.scrollViewDidScrollObservable)
    }

    var scrollViewWillEndDraggingObservable: ObservableEvent<Void> {
        return ObservableEvent(event: delegateProxy.scrollViewWillEndDraggingObservable)
    }

    var scrollViewWillBeginDraggingObservable: ObservableEvent<Void> {
        return ObservableEvent(event: delegateProxy.scrollViewWillBeginDraggingObservable)
    }

    @nonobjc func register(_ nib: UINib?, forCellReuseIdentifier identifier: String) {
        register(nib, forCellWithReuseIdentifier: identifier)
    }

    @nonobjc func register(_ cellClass: AnyClass?, forCellReuseIdentifier identifier: String) {
        register(cellClass, forCellWithReuseIdentifier: identifier)
    }
    
    func scrollToShow(itemAt indexPath: IndexPath, animated: Bool) {
        guard let cell = cellForItem(at: indexPath) else { return }
        let collectionLayout = collectionViewLayout as? UICollectionViewFlowLayout
        let cellSpacing = collectionLayout?.minimumInteritemSpacing ?? 0.0
        
        scrollRectToVisible(cell.frame.insetBy(dx: -cellSpacing, dy: -cellSpacing), animated: animated)
    }
    
    // MARK: Custom card pagination
    private var cellWidth: CGFloat {
        guard let currentIndexPath = indexPathsForVisibleItems.first else { return 0.0 }
        
        let exampleCell = cellForItem(at: currentIndexPath)
        let cellWidth = exampleCell?.bounds.width ?? bounds.width
        
        return cellWidth
    }
    
    private var cellMargin: CGFloat {
        let flowLayout = collectionViewLayout as? UICollectionViewFlowLayout
        let spacing = flowLayout?.minimumInteritemSpacing ?? 0.0
        
        return spacing
    }
    
    func offsetWithPagination(target: CGFloat) -> CGPoint {
        let fullCellSize = cellWidth + cellMargin
        let nearestPageOffset = max((target / fullCellSize).rounded(), 0.0) * fullCellSize
        
        let maxOffset = contentSize.width - bounds.width
        let newOffset = min(max(nearestPageOffset - cellMargin, 0.0), maxOffset)
        
        return CGPoint(x: newOffset, y: contentOffset.y)
    }
}
