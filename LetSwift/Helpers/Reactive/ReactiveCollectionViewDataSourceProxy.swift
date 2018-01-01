//
//  ReactiveCollectionViewDataSourceProxy.swift
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

final class ReactiveCollectionViewDataSourceProxy: NSObject, UICollectionViewDataSource {

    private enum Constants {
        static let delegateAssociatedTag = UnsafeRawPointer(UnsafeMutablePointer<UInt8>.allocate(capacity: 1))
    }

    private var dataSourceMethods: UICollectionViewDataSource?

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
        return dataSourceMethods?.collectionView(collectionView, cellForItemAt: indexPath) ?? UICollectionViewCell()
    }
}
