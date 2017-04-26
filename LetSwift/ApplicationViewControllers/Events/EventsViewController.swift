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

        let bindableArray = ["Cos", "Cos", "nic", "Ale działa"].bindable
        bindableArray.bind(to: tableView.item(with: "sth", cellType: UITableViewCell.self) ({ index, item, cell in
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
                        print(source)
                        //                    let cell = UITableView().dequeueReusableCell(withIdentifier: "Sth", for: IndexPath(row: index, section: 0)) as! Cell
                        let cell = UITableViewCell() as! Cell
                        cellFormer(index, item, cell)
                    }
                }
            }
    }
}

final class ReactiveTableViewObservable<S: Sequence>: NSObject, UITableViewDelegate, UITableViewDataSource {

    typealias CellFormer = (Int, UITableViewCell, S.Iterator.Element) -> UITableViewCell

    private var cellFormer: CellFormer?

    init(cellFormer: @escaping CellFormer) {
        self.cellFormer = cellFormer
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 0
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return UITableViewCell()
    }
}
