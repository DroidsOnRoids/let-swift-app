//
//  ReactiveTableViewDataSourceProxy.swift
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

final class ReactiveTableViewDataSourceProxy: NSObject, UITableViewDataSource {

    private enum Constants {
        static let delegateAssociatedTag = UnsafeRawPointer(UnsafeMutablePointer<UInt8>.allocate(capacity: 1))
    }

    fileprivate var dataSourceMethods: UITableViewDataSource?

    class func assignedProxyFor(_ object: AnyObject) -> ReactiveTableViewDataSourceProxy? {
        return objc_getAssociatedObject(object, Constants.delegateAssociatedTag) as? ReactiveTableViewDataSourceProxy
    }

    class func assignProxy(_ proxy: AnyObject, to object: UITableView) {
        objc_setAssociatedObject(object, Constants.delegateAssociatedTag, proxy, .OBJC_ASSOCIATION_RETAIN)
    }

    class func currentDelegateFor(_ object: UITableView) -> UITableViewDataSource? {
        return object.dataSource
    }

    static func subscribeToProxy(tableView: UITableView, datasource: UITableViewDataSource, binding: @escaping (ReactiveTableViewDataSourceProxy) -> ()) {
        let proxy = ReactiveTableViewDataSourceProxy.proxyForObject(tableView)
        proxy.dataSourceMethods = datasource
        binding(proxy)
    }

    static func proxyForObject(_ object: UITableView) -> ReactiveTableViewDataSourceProxy {
        let maybeProxy = ReactiveTableViewDataSourceProxy.assignedProxyFor(object)

        let proxy: ReactiveTableViewDataSourceProxy
        if let existingProxy = maybeProxy {
            proxy = existingProxy
        } else {
            proxy = ReactiveTableViewDataSourceProxy.createProxy(for: object) as! ReactiveTableViewDataSourceProxy
            ReactiveTableViewDataSourceProxy.assignProxy(proxy, to: object)
        }

        let currentDelegate: AnyObject? = ReactiveTableViewDataSourceProxy.currentDelegateFor(object)

        if currentDelegate !== proxy {
            ReactiveTableViewDataSourceProxy.setCurrentDelegate(proxy, to: object)
        }
        return proxy
    }

    class func createProxy(for tableView: UITableView) -> AnyObject {
        return tableView.createDataSourceProxy()
    }

    class func setCurrentDelegate(_ delegate: UITableViewDataSource?, to tableView: UITableView) {
        tableView.dataSource = delegate
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataSourceMethods?.tableView(tableView, numberOfRowsInSection: section) ?? 0
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return dataSourceMethods?.tableView(tableView, cellForRowAt: indexPath) ?? UITableViewCell()
    }
}
