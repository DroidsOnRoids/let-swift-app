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
        showSpinner()

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

        tableView.registerCells([SpeakersTableViewCell.cellIdentifier])

        reactiveSetup()
    }

    private func showSpinner() {
        let footerFrame = CGRect(x: 0.0, y: 0.0, width: view.bounds.width, height: 55.0)
        let spinner = SpinnerView(frame: footerFrame)
        spinner.image = #imageLiteral(resourceName: "WhiteSpinner")
        spinner.backgroundColor = .paleGrey
        tableView.tableFooterView = spinner
    }
    
    private func reactiveSetup() {
        viewModel.speakers.bind(to: tableView.item(with: SpeakersTableViewCell.cellIdentifier, cellType: SpeakersTableViewCell.self) ({ [weak self] index, speaker, cell in
            cell.load(with: speaker)
            self?.viewModel.checkIfLastSpeakerObservable.next(index)
        }))

        viewModel.tableViewStateObservable.subscribeNext(startsWithInitialValue: true) { [weak self] state in
            guard let weakSelf = self else { return }

            switch state {
            case .content:
                weakSelf.tableView.contentInset.top += weakSelf.searchBar.bounds.height
                weakSelf.tableView.setContentOffset(CGPoint(x: 0, y: -(64.0 + weakSelf.tableView.contentInset.top)), animated: false)
                weakSelf.tableView.overlayView = nil
            case .error:
                weakSelf.tableView.overlayView = weakSelf.sadFaceView
            case .loading:
                weakSelf.tableView.overlayView = SpinnerView()
            }
        }
        .add(to: disposeBag)

        viewModel.noMoreSpeakersToLoadObservable.subscribeNext { [weak self] in
            guard let spinnerView = self?.tableView.tableFooterView as? SpinnerView else { return }

            UIView.animate(withDuration: 0.25,
                           animations: {
                                spinnerView.transform = CGAffineTransform(translationX: 0.0, y: 50.0)
                            },
                           completion: { _ in
                                self?.tableView.tableFooterView = nil
                            })
        }
        .add(to: disposeBag)

        viewModel.speakerLoadDataRequestObservable.next()

        tableView.scrollViewWillEndDraggingObservable.subscribeNext { [weak self] scrollView in
            guard let scrollView = scrollView else { return }

            let checkIfTableViewEnd: () -> Bool = {
                let offset = scrollView.contentOffset
                let bounds = scrollView.bounds
                let size = scrollView.contentSize
                let inset = scrollView.contentInset
                let y = offset.y + bounds.size.height + inset.bottom
                let height = size.height
                let distance: CGFloat = 10.0

                return y > height + distance
            }

            if checkIfTableViewEnd() {
                self?.showSpinner()
                self?.viewModel.tryToLoadMoreDataObservable.next()
            }
        }
        .add(to: disposeBag)
    }
}
