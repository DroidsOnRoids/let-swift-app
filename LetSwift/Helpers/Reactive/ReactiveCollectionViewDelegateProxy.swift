//
//  ReactiveCollectionViewDelegateProxy.swift
//  LetSwift
//
//  Created by Kinga Wilczek on 08.05.2017.
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

final class ReactiveCollectionViewDelegateProxy: NSObject, UICollectionViewDelegate {

    lazy var itemDidSelectObservable = Observable<IndexPath>(IndexPath(row: 0, section: 0))
    lazy var scrollViewDidScrollObservable = Observable<UIScrollView?>(nil)
    lazy var scrollViewWillEndDraggingObservable = Observable<Void>()
    lazy var scrollViewWillBeginDraggingObservable = Observable<Void>()

    private enum Constants {
        static let delegateAssociatedTag = UnsafeRawPointer(UnsafeMutablePointer<UInt8>.allocate(capacity: 1))
    }

    class func assignedProxyFor(_ object: AnyObject) -> ReactiveCollectionViewDelegateProxy? {
        return objc_getAssociatedObject(object, Constants.delegateAssociatedTag) as? ReactiveCollectionViewDelegateProxy
    }

    class func assignProxy(_ proxy: AnyObject, to object: UICollectionView) {
        objc_setAssociatedObject(object, Constants.delegateAssociatedTag, proxy, .OBJC_ASSOCIATION_RETAIN)
    }

    class func currentDelegateFor(_ object: UICollectionView) -> UICollectionViewDelegate? {
        return object.delegate
    }

    static func proxyForObject(_ object: UICollectionView) -> ReactiveCollectionViewDelegateProxy {
        let maybeProxy = ReactiveCollectionViewDelegateProxy.assignedProxyFor(object)

        let proxy: ReactiveCollectionViewDelegateProxy
        if let existingProxy = maybeProxy {
            proxy = existingProxy
        } else {
            proxy = ReactiveCollectionViewDelegateProxy.createProxy(for: object) as! ReactiveCollectionViewDelegateProxy
            ReactiveCollectionViewDelegateProxy.assignProxy(proxy, to: object)
        }

        let currentDelegate: AnyObject? = ReactiveCollectionViewDelegateProxy.currentDelegateFor(object)

        if currentDelegate !== proxy {
            ReactiveCollectionViewDelegateProxy.setCurrentDelegate(proxy, to: object)
        }
        return proxy
    }

    class func createProxy(for collectionView: UICollectionView) -> AnyObject {
        return collectionView.createDelegateProxy()
    }

    class func setCurrentDelegate(_ delegate: UICollectionViewDelegate?, to collectionView: UICollectionView) {
        collectionView.delegate = delegate
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        itemDidSelectObservable.next(indexPath)
    }

    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        scrollViewDidScrollObservable.next(scrollView)
    }

    func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
        scrollViewWillEndDraggingObservable.next()
    }

    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        scrollViewWillBeginDraggingObservable.next()
    }
}
