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
}
