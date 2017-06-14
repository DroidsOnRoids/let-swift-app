//
//  SpeakersViewController.swift
//  LetSwift
//
//  Created by Marcin Chojnacki on 21.04.2017.
//  Copyright © 2017 Droids On Roids. All rights reserved.
//

import UIKit

protocol SpeakersViewControllerDelegate: class {
}

final class SpeakersViewController: AppViewController {

    private enum EventCellIdentifier: String {
        case latestSpeakers = "LatestSpeakersTableViewCell"
    }

    private var allCells: [EventCellIdentifier] {
        return [.latestSpeakers]
    }

    private lazy var bindableCells: BindableArray<EventCellIdentifier> = self.allCells.bindable

    override var viewControllerTitleKey: String? {
        return "SPEAKERS_TITLE"
    }

    override var shouldShowUserIcon: Bool {
        return true
    }

    override var shouldHideShadow: Bool {
        return true
    }

    @IBOutlet private weak var searchBar: UISearchBar!
    @IBOutlet private weak var tableView: UITableView!

    private var viewModel: SpeakersViewControllerViewModel!

    convenience init(viewModel: SpeakersViewControllerViewModel) {
        self.init()
        self.viewModel = viewModel
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        setup()
    }

    private func setup() {
        tableView.tableFooterView = UIView()
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 60.0
        tableView.setFooterColor(.paleGrey)
        tableView.setHeaderColor(.paleGrey)

        searchBar.layer.borderWidth = 1
        searchBar.layer.borderColor = UIColor.paleGrey.cgColor

        tableView.registerCells(allCells.map { $0.rawValue })

        reactiveSetup()
    }
    
    private func reactiveSetup() {
        bindableCells.bind(to: tableView.items() ({ tableView, index, element in
            let indexPath = IndexPath(row: index, section: 0)
            let cell = tableView.dequeueReusableCell(withIdentifier: element.rawValue, for: indexPath)

            return cell
        }))
    }
}
