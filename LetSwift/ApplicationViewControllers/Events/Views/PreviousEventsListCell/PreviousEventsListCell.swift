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
        super.awakeFromNib()
        
        setup()
    }
    
    private func setup() {
        eventsCollectionView.register(UINib(nibName: PreviousEventCell.cellIdentifier, bundle: nil), forCellWithReuseIdentifier: PreviousEventCell.cellIdentifier)
        [1, 2, 3, 4, 5].bindable.bind(to: eventsCollectionView.item(with: PreviousEventCell.cellIdentifier, cellType: PreviousEventCell.self) ({ configuration in
            print(configuration)
        }))
    }
}

final class ReactiveCollectionViewDataSourceProxy: NSObject, UICollectionViewDataSource {

    private enum Constants {
        static let delegateAssociatedTag = UnsafeRawPointer(UnsafeMutablePointer<UInt8>.allocate(capacity: 1))
    }

    fileprivate var dataSourceMethods: UICollectionViewDataSource?

    class func assignedProxyFor(_ object: AnyObject) -> ReactiveCollectionViewDataSourceProxy? {
        return objc_getAssociatedObject(object, Constants.delegateAssociatedTag) as? ReactiveCollectionViewDataSourceProxy
    }

    class func assignProxy(_ proxy: AnyObject, to object: UICollectionView) {
        objc_setAssociatedObject(object, Constants.delegateAssociatedTag, proxy, .OBJC_ASSOCIATION_RETAIN)
    }

    class func currentDelegateFor(_ object: UICollectionView) -> UICollectionViewDataSource? {
        return object.dataSource
    }

    static func subscribeToProxy(collectionView: UICollectionView, datasource: UICollectionViewDataSource, binding: @escaping (ReactiveCollectionViewDataSourceProxy) -> ()) {
        let proxy = ReactiveCollectionViewDataSourceProxy.proxyForObject(collectionView)
        proxy.dataSourceMethods = datasource
        binding(proxy)
    }

    static func proxyForObject(_ object: UICollectionView) -> ReactiveCollectionViewDataSourceProxy {
        let maybeProxy = ReactiveCollectionViewDataSourceProxy.assignedProxyFor(object)

        let proxy: ReactiveCollectionViewDataSourceProxy
        if let existingProxy = maybeProxy {
            proxy = existingProxy
        } else {
            proxy = ReactiveCollectionViewDataSourceProxy.createProxy(for: object) as! ReactiveCollectionViewDataSourceProxy
            ReactiveCollectionViewDataSourceProxy.assignProxy(proxy, to: object)
        }

        let currentDelegate: AnyObject? = ReactiveCollectionViewDataSourceProxy.currentDelegateFor(object)

        if currentDelegate !== proxy {
            ReactiveCollectionViewDataSourceProxy.setCurrentDelegate(proxy, to: object)
        }
        return proxy
    }

    class func createProxy(for collectionView: UICollectionView) -> AnyObject {
        return collectionView.createDataSourceProxy()
    }

    class func setCurrentDelegate(_ delegate: UICollectionViewDataSource?, to collectionView: UICollectionView) {
        collectionView.dataSource = delegate
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return dataSourceMethods?.collectionView(collectionView, numberOfItemsInSection: section) ?? 0
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        return dataSourceMethods?.collectionView(collectionView ,cellForItemAt: indexPath) ?? UICollectionViewCell()
    }
}

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
