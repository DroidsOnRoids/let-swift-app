//
//  EventsViewController.swift
//  LetSwift
//
//  Created by Marcin Chojnacki, Kinga Wilczek on 21.04.2017.
//  Copyright © 2017 Droids On Roids. All rights reserved.
//

import UIKit

final class EventsViewController: AppViewController {

    @IBOutlet private weak var tableView: UITableView!
    
    private var viewModel: EventsViewControllerViewModel!

    convenience init(viewModel: EventsViewControllerViewModel) {
        self.init()
        self.viewModel = viewModel
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        setup()
        tableView.estimatedRowHeight = 90
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.tableFooterView = UIView()
        tableView.register(UINib(nibName: "StaticImageTableViewCell", bundle: nil), forCellReuseIdentifier: "StaticImageTableViewCell")

        let bindableArray = ["Cos", "Cos", "nic", "Ale działa"].bindable
        bindableArray.bind(to: tableView.item(with: "StaticImageTableViewCell", cellType: UITableViewCell.self) ({ index, item, cell in
            print(index, item, cell)

        }))

        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 3) {
            bindableArray.append("Hehhe")
        }
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 4) {
            bindableArray.append("No")
        }
    }

    override func viewControllerTitleKey() -> String? {
        return "EVENTS_TITLE"
    }

    override func shouldShowUserIcon() -> Bool {
        return true
    }

    override func shouldHideShadow() -> Bool {
        return true
    }

    private func setup() {
    }
}

//===============Reactive Table View================

extension Array {
    var bindable: BindableArray<Element> {
        return BindableArray<Element>(self)
    }
}

final class BindableArray<T> {

    private var values: [T]
    private var events = [([T]) -> (Int, T) -> ()]()

    init(_ values: [T]) {
        self.values = values
    }

    func bind(to event: @escaping ([T]) -> (Int, T) -> ()) {
        events.append(event)
        notify(event: event)
    }

    func append(_ element: T) {
        values.append(element)
        events.forEach({ $0(values)(values.count - 1, element) })
    }

    private func notify(event: ([T]) -> (Int, T) -> ()) {
        values.enumerated().forEach { index, element in
            event(values)(index, element)
        }
    }
}


extension UITableView {
    func item<Cell: UITableViewCell, T, S: Sequence>(with identifier: String, cellType: Cell.Type = Cell.self)
        -> (@escaping (Int, T, Cell) -> ())
        -> (_ source: S)
        -> (Int, T)
        -> () {
            return { cellFormer in
                return { source in
                    return { index, item in
                        let delegate = ReactiveTableViewDataSource<S> { tableView, index, element in
                            let cell = tableView.dequeueReusableCell(withIdentifier: identifier, for: IndexPath(row: index, section: 0)) as! Cell
                            cellFormer(index, item, cell)
                            return cell
                        }
                        delegate.tableView(self, observedElements: source) //maybe here proxy is needed
                    }
                }
            }
    }

    func createRxDataSourceProxy() -> ReactiveTableViewDataSourceProxy {
        return ReactiveTableViewDataSourceProxy()
    }
}

final class ReactiveTableViewDataSource<S: Sequence>: NSObject, UITableViewDataSource {

    typealias CellFormer = (UITableView, Int, S.Iterator.Element) -> UITableViewCell

    private var cellFormer: CellFormer

    private var items: [S.Iterator.Element] = []

    init(cellFormer: @escaping CellFormer) {
        self.cellFormer = cellFormer
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return cellFormer(tableView, indexPath.item, items[indexPath.row])
    }

    //Needs to reimplement
    func tableView(_ tableView: UITableView, observedElements: S) {
        items = observedElements.map({ $0 })
        print(items)
        tableView.reloadData()
    }
}

final class ReactiveTableViewDataSourceProxy: NSObject, UITableViewDataSource {

    fileprivate weak var dataSourceMethods: UITableViewDataSource?

//    public static func proxyForObject(_ object: UITableView) -> Self {
//
//        let maybeProxy = Self.assignedProxyFor(object) as? Self
//
//        let proxy: Self
//        if let existingProxy = maybeProxy {
//            proxy = existingProxy
//        }
//        else {
//            proxy = Self.createProxy(for: object) as! Self
//            Self.assignProxy(proxy, toObject: object)
//            assert(Self.assignedProxyFor(object) === proxy)
//        }
//
//        let currentDelegate: AnyObject? = Self.currentDelegateFor(object)
//
//        if currentDelegate !== proxy {
//            proxy.setForwardToDelegate(currentDelegate, retainDelegate: false)
//            assert(proxy.forwardToDelegate() === currentDelegate)
//            Self.setCurrentDelegate(proxy, toObject: object)
//            assert(Self.currentDelegateFor(object) === proxy)
//            assert(proxy.forwardToDelegate() === currentDelegate)
//        }
//        
//        return proxy
//    }

    class func createProxy(for tableView: UITableView) -> AnyObject {
        return tableView.createRxDataSourceProxy()
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
