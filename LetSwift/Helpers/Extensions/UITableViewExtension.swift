//
//  UITableViewExtension.swift
//  LetSwift
//
//  Created by Kinga Wilczek, Marcin Chojnacki on 30.04.2017.
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
import ESPullToRefresh

extension UITableView: NibPresentable {
    func item<Cell: UITableViewCell, T, S: Sequence>(with identifier: String, cellType: Cell.Type = Cell.self)
        -> (@escaping (Int, T, Cell) -> ())
        -> (_ source: S)
        -> () where T == S.Iterator.Element {
            return { cellFormer in
                return { source in
                    let delegate = ReactiveTableViewDataSource<S> { tableView, index, element in
                        let cell = tableView.dequeueReusableCell(withIdentifier: identifier, for: IndexPath(row: index, section: 0)) as! Cell
                        cellFormer(index, element, cell)
                        return cell
                    }
                    ReactiveTableViewDataSourceProxy.subscribeToProxy(tableView: self, datasource: delegate) { proxy in
                        delegate.tableView(self, observedElements: source)
                    }
                }
            }
    }

    func items<S: Sequence>()
        -> (@escaping (UITableView, Int, S.Iterator.Element) -> UITableViewCell)
        -> (_ source: S, _ updated: Bool)
        -> () {
            return { cellFormer in
                return { source, shouldUpdate in
                    let delegate = ReactiveTableViewDataSource<S>(cellFormer: cellFormer)
                    ReactiveTableViewDataSourceProxy.subscribeToProxy(tableView: self, datasource: delegate) { proxy in
                        delegate.tableView(self, observedElements: source, updated: shouldUpdate)
                    }
                }
            }
    }

    func createDataSourceProxy() -> ReactiveTableViewDataSourceProxy {
        return ReactiveTableViewDataSourceProxy()
    }

    func createDelegateProxy() -> ReactiveTableViewDelegateProxy {
        return ReactiveTableViewDelegateProxy()
    }

    var delegateProxy: ReactiveTableViewDelegateProxy {
        return ReactiveTableViewDelegateProxy.proxyForObject(self) 
    }

    var itemDidSelectObservable: ObservableEvent<IndexPath> {
        return ObservableEvent(event: delegateProxy.itemDidSelectObservable)
    }

    // MARK: Header and footer
    static var emptyFooter: UIView {
        return UIView(frame: CGRect(x: 0.0, y: 0.0, width: 0.0, height: 1.0))
    }
    
    private func createHeaderFooterView(_ color: UIColor, negativeOffset: Bool) -> UIView {
        let offset: CGFloat = 1000.0
        let offsetView = UIView()
        let colorView = UIView(frame: CGRect(x: 0.0, y: negativeOffset ? -offset : 0.0, width: max(bounds.width, bounds.height), height: offset))
        colorView.backgroundColor = color
        offsetView.addSubview(colorView)
        
        return offsetView
    }
    
    func setHeaderColor(_ color: UIColor) {
        tableHeaderView = createHeaderFooterView(color, negativeOffset: true)
    }
    
    func setFooterColor(_ color: UIColor) {
        let footerView = createHeaderFooterView(color, negativeOffset: false)
        tableFooterView = footerView
        
        sendSubview(toBack: footerView)
    }
    
    override open var delaysContentTouches: Bool {
        didSet {
            changeChildDelaysContentTouches()
        }
    }
    
    override open func awakeFromNib() {
        super.awakeFromNib()
        
        changeChildDelaysContentTouches()
    }
    
    private func changeChildDelaysContentTouches() {
        subviews.forEach {
            ($0 as? UIScrollView)?.delaysContentTouches = delaysContentTouches
        }
    }

    var scrollViewWillEndDraggingObservable: ObservableEvent<UIScrollView?> {
        return ObservableEvent(event: delegateProxy.scrollViewWillEndDraggingObservable)
    }

    var scrollViewDidScrollObservable: ObservableEvent<UIScrollView?> {
        return ObservableEvent(event: delegateProxy.scrollViewDidScrollObservable)
    }

    var isTableHeaderViewVisible: Bool {
        guard let tableHeaderView = tableHeaderView else { return false }
        
        return contentOffset.y < tableHeaderView.frame.size.height
    }
}
