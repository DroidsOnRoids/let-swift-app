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

        let binbing = ReactiveTableViewObservable<String>().item(with: "sth", cellType: UITableViewCell.self)({ index, item, cell in
            print(index, item, cell)
        })
        ["Cos", "Cos", "nic", "Ale działa"].bindable.bind(to: binbing)
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
        setupDelegates()
    }

    private func setupDelegates() {
        tableView.delegate = self
        tableView.dataSource = self
    }
}

extension EventsViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 0
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return UITableViewCell()
    }
}

//extension UITableView {
//
//    var reactive: ReactiveTablewViewObservable {
//        return
//    }
//}

extension Array {
    var bindable: BindableArray<Element> {
        return BindableArray<Element>(self)
    }
}

final class BindableArray<T> {

    private var values: [T]
    private var events = [(Int, T) -> ()]()

    init(_ values: [T]) {
        self.values = values
    }

    func bind(to event: @escaping (Int, T) -> ()) {
        events.append(event)
        notify()
    }

    func append(_ element: T) {
        values.append(element)
        notify()
    }

    private func notify() {
        values.enumerated().forEach { index, element in
            events.forEach({ $0(index, element) })
        }
    }
}

final class ReactiveTableViewObservable<T>: NSObject, UITableViewDelegate, UITableViewDataSource {

    typealias CellFormer = (Int, UITableViewCell, T) -> UITableViewCell

    private var cellFormer: CellFormer?

    init(cellFormer: @escaping CellFormer) {
        self.cellFormer = cellFormer
    }

    override init() {

    }

    func item<Cell: UITableViewCell>(with identifier: String, cellType: Cell.Type = Cell.self)
        -> ( @escaping (Int, T, Cell) -> ())
        -> (Int, T)
        -> () {
            return { cellFormer in
                return { index, item in
//                    let cell = UITableView().dequeueReusableCell(withIdentifier: "Sth", for: IndexPath(row: index, section: 0)) as! Cell
                    let cell = UITableViewCell() as! Cell
                    cellFormer(index, item, cell)
                }
            }
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 0
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return UITableViewCell()
    }
}
