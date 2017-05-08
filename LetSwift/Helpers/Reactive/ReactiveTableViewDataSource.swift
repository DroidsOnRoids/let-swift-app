//
//  ReactiveTableViewDataSource.swift
//  LetSwift
//
//  Created by Kinga Wilczek on 04.05.2017.
//  Copyright © 2017 Droids On Roids. All rights reserved.
//

import UIKit

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

    func tableView(_ tableView: UITableView, observedElements: S) {
        items = observedElements.map{ $0 }

        DispatchQueue.main.async {
            tableView.reloadData()
        }
    }
}
