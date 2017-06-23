//
//  UICollectionViewCell.swift
//  LetSwift
//
//  Created by Kinga Wilczek on 05.05.2017.
//  Copyright © 2017 Droids On Roids. All rights reserved.
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
                    ReactiveCollectionViewDataSourceProxy.subscribeToProxy(collectionView: self, datasource: delegate) { proxy in
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
                    ReactiveCollectionViewDataSourceProxy.subscribeToProxy(collectionView: self, datasource: delegate) { proxy in
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

    func registerNib(_ nib: UINib?, forCellReuseIdentifier identifier: String) {
        register(nib, forCellWithReuseIdentifier: identifier)
    }

    func registerClass(_ cellClass: AnyClass?, forCellReuseIdentifier identifier: String) {
        register(cellClass, forCellWithReuseIdentifier: identifier)
    }
    
    func scrollToShow(itemAt indexPath: IndexPath, animated: Bool) {
        guard let cell = cellForItem(at: indexPath) else { return }
        let collectionLayout = collectionViewLayout as? UICollectionViewFlowLayout
        let cellSpacing = collectionLayout?.minimumInteritemSpacing ?? 0.0
        
        scrollRectToVisible(cell.frame.insetBy(dx: -cellSpacing, dy: -cellSpacing), animated: animated)
    }
}
