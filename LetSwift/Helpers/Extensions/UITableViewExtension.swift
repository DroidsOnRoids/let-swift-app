//
//  UITableViewExtension.swift
//  LetSwift
//
//  Created by Kinga Wilczek, Marcin Chojnacki on 30.04.2017.
//  Copyright © 2017 Droids On Roids. All rights reserved.
//

import UIKit
import ESPullToRefresh

extension UITableView {
    // MARK: Reactive extensions
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
    private func setHeaderOrFooterColor(_ color: UIColor, header: Bool) {
        let offset: CGFloat = 1000.0
        let offsetView = UIView()
        let colorView = UIView(frame: CGRect(x: 0.0, y: header ? -offset : 0.0, width: max(bounds.width, bounds.height), height: offset))
        colorView.backgroundColor = color
        offsetView.addSubview(colorView)
        
        if header {
            tableHeaderView = offsetView
        } else {
            tableFooterView = offsetView
        }
        
        sendSubview(toBack: offsetView)
    }
    
    func setHeaderColor(_ color: UIColor) {
        setHeaderOrFooterColor(color, header: true)
    }
    
    func setFooterColor(_ color: UIColor) {
        setHeaderOrFooterColor(color, header: false)
    }
    
    // MARK: Pull to refresh
    func addPullToRefresh(callback: @escaping () -> ()) {
        es_addPullToRefresh(animator: PullToRefreshAnimator(), handler: callback)
    }
    
    func finishPullToRefresh() {
        es_stopPullToRefresh(ignoreDate: true, ignoreFooter: true)
    }
    
    // MARK: Delays content touches fix
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
}
