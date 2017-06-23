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
        case speakers = "SpeakersTableViewCell"
    }

    private var allCells: [EventCellIdentifier] {
        return [.latestSpeakers, .speakers]
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
        tableView.tableFooterView = UIView()
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 60.0
        tableView.setHeaderColor(.paleGrey)
        tableView.tableHeaderView = searchBar
        tableView.backgroundColor = .paleGrey
        tableView.setFooterColor(.white)

        searchBar.layer.borderWidth = 1.0
        searchBar.layer.borderColor = UIColor.paleGrey.cgColor
        searchBar.placeholder = localized("SPEAKERS_SEARCH_PLACEHOLDER")

        tableView.registerCells(allCells.map { $0.rawValue })

        reactiveSetup()
    }
    
    private func reactiveSetup() {
        bindableCells.bind(to: tableView.items() ({ [weak self] tableView, index, element in
            let indexPath = IndexPath(row: index, section: 0)
            let cell = tableView.dequeueReusableCell(withIdentifier: element.rawValue, for: indexPath)
            self?.dispatchCellSetup(element: element, cell: cell, index: index)

            return cell
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

        viewModel.currentNumberOfSpeaker.subscribeNext { [weak self] speakersNumber in
            guard speakersNumber >= 0 else { return }

            self?.bindableCells.remove(updated: false) { $0 == .speakers }
            self?.bindableCells.append([EventCellIdentifier](repeating: .speakers, count: speakersNumber))
        }
        .add(to: disposeBag)

        viewModel.speakerLoadDataRequestObservable.next()
    }

    private func dispatchCellSetup(element: EventCellIdentifier, cell: UITableViewCell, index: Int) {
        switch element {
        case .latestSpeakers:
            setupLatestSpeakers(cell: cell as! LatestSpeakersTableViewCell)
        case .speakers:
            setupSpeakers(cell: cell as! SpeakersTableViewCell, for: index)
        }
    }

    private func setupSpeakers(cell: SpeakersTableViewCell, for index: Int) {
        viewModel.speakerWithIndexResponseObservable.subscribeNext { incomingIndex, speaker in
            guard let speaker = speaker, incomingIndex == index - 1  else { return }

            cell.load(with: speaker)
        }
        .add(to: disposeBag)

        viewModel.speakerWithIndexRequestObservable.next(index - 1)
    }

    private func setupLatestSpeakers(cell: LatestSpeakersTableViewCell) {
        cell.removeSeparators()
    }
}
