//
//  ReactiveTableViewDelegateProxy.swift
//  LetSwift
//
//  Created by Kinga Wilczek on 04.05.2017.
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

final class ReactiveTableViewDelegateProxy: NSObject, UITableViewDelegate {

    lazy var itemDidSelectObservable = Observable<IndexPath>(IndexPath(row: 0, section: 0))
    lazy var scrollViewWillEndDraggingObservable = Observable<UIScrollView?>(nil)
    lazy var scrollViewDidScrollObservable = Observable<UIScrollView?>(nil)

    private enum Constants {
        static let delegateAssociatedTag = UnsafeRawPointer(UnsafeMutablePointer<UInt8>.allocate(capacity: 1))
    }

    class func assignedProxyFor(_ object: AnyObject) -> ReactiveTableViewDelegateProxy? {
        return objc_getAssociatedObject(object, Constants.delegateAssociatedTag) as? ReactiveTableViewDelegateProxy
    }

    class func assignProxy(_ proxy: AnyObject, to object: UITableView) {
        objc_setAssociatedObject(object, Constants.delegateAssociatedTag, proxy, .OBJC_ASSOCIATION_RETAIN)
    }

    class func currentDelegateFor(_ object: UITableView) -> UITableViewDelegate? {
        return object.delegate
    }

    static func proxyForObject(_ object: UITableView) -> ReactiveTableViewDelegateProxy {
        let maybeProxy = ReactiveTableViewDelegateProxy.assignedProxyFor(object)

        let proxy: ReactiveTableViewDelegateProxy
        if let existingProxy = maybeProxy {
            proxy = existingProxy
        } else {
            proxy = ReactiveTableViewDelegateProxy.createProxy(for: object) as! ReactiveTableViewDelegateProxy
            ReactiveTableViewDelegateProxy.assignProxy(proxy, to: object)
        }

        let currentDelegate: AnyObject? = ReactiveTableViewDelegateProxy.currentDelegateFor(object)

        if currentDelegate !== proxy {
            ReactiveTableViewDelegateProxy.setCurrentDelegate(proxy, to: object)
        }
        return proxy
    }

    class func createProxy(for tableView: UITableView) -> AnyObject {
        return tableView.createDelegateProxy()
    }

    class func setCurrentDelegate(_ delegate: UITableViewDelegate?, to tableView: UITableView) {
        tableView.delegate = delegate
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        itemDidSelectObservable.next(indexPath)
    }

    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        scrollViewWillEndDraggingObservable.next(scrollView)
    }

    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        scrollViewDidScrollObservable.next(scrollView)
    }
}
