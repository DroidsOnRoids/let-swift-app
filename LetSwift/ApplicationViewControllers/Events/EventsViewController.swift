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

        let bindableArray = ["Cos", "Cos", "nic", "Ale działa", "Cos", "nic", "Ale działa", "Cos", "nic", "Ale działa", "Cos", "nic", "Ale działa", "Cos", "nic", "Ale działa", "Cos", "nic", "Ale działa", "Cos", "nic", "Ale działa", "Cos", "nic", "Ale działa", "Cos", "nic", "Ale działa", "Cos", "nic", "Ale działa", "Cos", "nic", "Ale działa", "Cos", "nic", "Ale działa", "Cos", "nic", "Ale działa", "Cos", "nic", "Ale działa", "Cos", "nic", "Ale działa", "Cos", "nic", "Ale działa", "Cos", "nic", "Ale działa", "Cos", "nic", "Ale działa", "Cos", "nic", "Ale działa", "Cos", "nic", "Ale działa", "Cos", "nic", "Ale działa", "Cos", "nic", "Ale działa", "Cos", "nic", "Ale działa", "Cos", "nic", "Ale działa", "Cos", "nic", "Ale działa", "Cos", "nic", "Ale działa", "Cos", "nic", "Ale działa", "Cos", "nic", "Ale działa", "Cos", "nic", "Ale działa", "Cos", "nic", "Ale działa"].bindable
        bindableArray.bind(to: tableView.item(with: "StaticImageTableViewCell", cellType: StaticImageTableViewCell.self) ({ index, item, cell in
            if index % 2 == 0 {
                cell.reflectiveImageView.image = #imageLiteral(resourceName: "EventsActive")
            } else {
                cell.reflectiveImageView.image = #imageLiteral(resourceName: "OnboardingMeetups")
            }
            cell.someName.text = item
        }))

        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 10) {
            bindableArray.append("Hehhe")
        }
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 15) {
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
    private var events = [([T]) -> ()]()

    init(_ values: [T]) {
        self.values = values
    }

    func bind(to event: @escaping ([T]) -> ()) {
        events.append(event)
        notify(event: event)
    }

    func append(_ element: T) {
        values.append(element)
        events.forEach({ $0(values) })
    }

    private func notify(event: ([T]) -> ()) {
        values.enumerated().forEach { index, element in
            event(values)
        }
    }
}


extension UITableView {
    func item<Cell: UITableViewCell, T, S: Sequence>(with identifier: String, cellType: Cell.Type = Cell.self)
        -> (@escaping (Int, T, Cell) -> ())
        -> (_ source: S)
        -> () where T == S.Iterator.Element {
            return { cellFormer in
                return { source in
                    DispatchQueue.global(qos: .background).async {
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
        DispatchQueue.main.async {
            tableView.reloadData()
        }
    }
}

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
