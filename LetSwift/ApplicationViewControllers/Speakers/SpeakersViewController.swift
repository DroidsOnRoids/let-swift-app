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

    override var viewControllerTitleKey: String? {
        return "SPEAKERS_TITLE"
    }

    override var shouldShowUserIcon: Bool {
        return true
    }

    override var shouldHideShadow: Bool {
        return true
    }

    @IBOutlet private weak var tableView: AppTableView!
    @IBOutlet private weak var searchBar: UISearchBar!
    
    private let sadFaceView = SadFaceView()

    private let disposeBag = DisposeBag()
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
        let footerFrame = CGRect(x: 0.0, y: 0.0, width: view.bounds.width, height: 55.0)
        let spinner = SpinnerView(frame: footerFrame)
        spinner.image = #imageLiteral(resourceName: "WhiteSpinner")
        spinner.backgroundColor = .paleGrey
        tableView.tableFooterView = spinner

        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 60.0
        tableView.setHeaderColor(.paleGrey)
        tableView.backgroundColor = .paleGrey

        let headerView = LatestSpeakersHeaderView()
        headerView.translatesAutoresizingMaskIntoConstraints = false
        tableView.tableHeaderView = headerView
        headerView.widthAnchor.constraint(equalTo: tableView.widthAnchor).isActive = true

        searchBar.layer.borderWidth = 1.0
        searchBar.layer.borderColor = UIColor.paleGrey.cgColor
        searchBar.placeholder = localized("SPEAKERS_SEARCH_PLACEHOLDER")
        tableView.contentInset.top += 44

        tableView.registerCells([SpeakersTableViewCell.cellIdentifier])

        reactiveSetup()
    }
    
    private func reactiveSetup() {
        viewModel.speakers.bind(to: tableView.item(with: SpeakersTableViewCell.cellIdentifier, cellType: SpeakersTableViewCell.self) ({ [weak self] index, speaker, cell in
            cell.load(with: speaker)
            self?.viewModel.checkIfLastSpeakerObservable.next(index)
        }))

        viewModel.tableViewStateObservable.subscribeNext(startsWithInitialValue: true) { [weak self] state in
            switch state {
            case .content:
                self?.tableView.overlayView = nil
            case .error:
                self?.tableView.overlayView = self?.sadFaceView
            case .loading:
                self?.tableView.overlayView = SpinnerView()
            }
        }
        .add(to: disposeBag)

        viewModel.noMoreSpeakersToLoad.subscribeNext { [weak self] in
            self?.tableView.tableFooterView = nil
        }
        .add(to: disposeBag)

        viewModel.speakerLoadDataRequestObservable.next()
    }
}
