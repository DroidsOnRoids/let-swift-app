//
//  SpeakersViewController.swift
//  LetSwift
//
//  Created by Marcin Chojnacki, Kinga Wilczek on 21.04.2017.
//  Copyright © 2017 Droids On Roids. All rights reserved.
//
//  Licensed under the Apache License, Version 2.0 (the "License");
//  you may not use this file except in compliance with the License.
//  You may obtain a copy of the License at
//
//       http://www.apache.org/licenses/LICENSE-2.0
//
//  Unless required by applicable law or agreed to in writing, software
//  distributed under the License is distributed on an "AS IS" BASIS,
//  WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
//  See the License for the specific language governing permissions and
//  limitations under the License.
//

import UIKit

final class SpeakersViewController: AppViewController {

    private enum Constants {
        static let offsetToken = "OffsetToken"
        static let headerOffset: CGFloat = 1000.0
    }

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
    @IBOutlet private weak var searchBar: ReactiveSearchBar!

    private let sadFaceView = SadFaceView()
    private let spinnerView = SpinnerView()
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

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)

        viewModel.searchBarShouldResignFirstResponderObservable.next()
    }
    
    private func setup() {
        showSpinner()

        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 60.0
        
        let headerView = LatestSpeakersHeaderView()
        headerView.viewModel = viewModel
        headerView.translatesAutoresizingMaskIntoConstraints = false
        tableView.tableHeaderView = headerView
        headerView.widthAnchor.constraint(equalTo: tableView.widthAnchor).isActive = true
        
        let colorView = UIView(frame: CGRect(x: 0.0, y: -Constants.headerOffset, width: max(tableView.bounds.width, tableView.bounds.height), height: Constants.headerOffset))
        colorView.backgroundColor = headerView.subviews.first?.backgroundColor
        headerView.addSubview(colorView)

        tableView.registerCells([SpeakersTableViewCell.cellIdentifier])

        setupPullToRefresh()
        reactiveSetup()
    }

    private func setupPullToRefresh() {
        addPullToRefresh()

        viewModel.refreshDataObservable.subscribeCompleted { [weak self] in
            self?.sadFaceView.scrollView?.finishPullToRefresh()
        }
        .add(to: disposeBag)
    }

    private func addPullToRefresh() {
        sadFaceView.scrollView?.addPullToRefresh { [weak self] in
            self?.viewModel.refreshDataObservable.next()
        }
    }

    private func removePullToRefresh() {
        sadFaceView.scrollView?.removePullToRefresh()
    }

    private func showSpinner() {
        let footerFrame = CGRect(x: 0.0, y: 0.0, width: view.bounds.width, height: 55.0)
        let spinner = SpinnerView(frame: footerFrame)
        spinner.image = #imageLiteral(resourceName: "GreyLoader")
        tableView.tableFooterView = spinner
    }
    
    private func collapseHeaderView() {
        tableView.tableHeaderView?.transform = CGAffineTransform(scaleX: 1.0, y: 0.001)
        tableView.tableHeaderView?.isHidden = true
    }
    
    private func reactiveSetup() {
        reactiveTableViewSetup()
        reactiveLoadingSetup()

        viewModel.errorViewStateObservable.subscribeNext { [weak self] state in
            switch state {
            case .requestFail:
                self?.addPullToRefresh()
                self?.sadFaceView.errorText = localized("GENERAL_SOMETHING_WENT_WRONG")
                self?.sadFaceView.isPullToRefreshVisible = true
            case .speakerNotFound:
                self?.removePullToRefresh()
                self?.sadFaceView.errorText = localized("SPEAKERS_NO_RESULTS_FOUND")
                self?.sadFaceView.isPullToRefreshVisible = false
            }
        }
        .add(to: disposeBag)

        viewModel.speakerLoadDataRequestObservable.next()

        reactiveSearchBarSetup()
    }

    private func reactiveLoadingSetup() {
        viewModel.errorOnLoadingMoreSpeakersObservable.subscribeNext { [weak self] in
            guard let spinnerView = self?.tableView.tableFooterView as? SpinnerView else { return }

            UIView.animate(withDuration: 0.25, animations: {
                spinnerView.transform = CGAffineTransform(translationX: 0.0, y: 50.0)
            }, completion: { _ in
                self?.tableView.tableFooterView = UITableView.emptyFooter
            })
        }
        .add(to: disposeBag)

        viewModel.noMoreSpeakersToLoadObservable.subscribeNext { [weak self] in
            self?.tableView.tableFooterView = UITableView.emptyFooter
        }
        .add(to: disposeBag)
    }

    private func reactiveSearchBarSetup() {
        searchBar.searchBarWillStartEditingObservable.subscribeNext { [weak self] in
            if self?.tableView.isTableHeaderViewVisible ?? false {
                UIView.animate(withDuration: 0.25, animations: {
                    self?.tableView.tableHeaderView?.alpha = 0.0
                }, completion: { _ in
                    self?.collapseHeaderView()
                    self?.tableView.beginUpdates()
                    self?.tableView.endUpdates()
                })
            } else {
                self?.tableView.tableHeaderView?.alpha = 0.0
                self?.collapseHeaderView() 
            }
        }
        .add(to: disposeBag)

        searchBar.searchBarCancelButtonClicked.subscribeNext { [weak self] in
            self?.tableView.tableHeaderView?.transform = .identity
            self?.tableView.tableHeaderView?.isHidden = false
            if self?.tableView.isTableHeaderViewVisible ?? false {
                UIView.animate(withDuration: 0.25) {
                    self?.tableView.tableHeaderView?.alpha = 1.0
                    self?.tableView.beginUpdates()
                    self?.tableView.endUpdates()
                }
            } else {
                self?.tableView.tableHeaderView?.alpha = 1.0
            }

            self?.viewModel.searchQueryObservable.next("")
            self?.viewModel.speakerLoadDataRequestObservable.next()
        }
        .add(to: disposeBag)

        searchBar.searchBarSearchButtonClickedObservable.subscribeNext { [weak self] query in
            self?.searchBar.enableCancelButton()
            self?.viewModel.searchQueryObservable.next(query)
            self?.viewModel.speakerLoadDataRequestObservable.next()
        }
        .add(to: disposeBag)

        viewModel.searchBarShouldResignFirstResponderObservable.subscribeNext { [weak self] in
            guard let weakSelf = self, weakSelf.searchBar.isFirstResponder else { return }

            weakSelf.tableView.reloadData()
            weakSelf.searchBar.resignFirstResponder()
            weakSelf.searchBar.enableCancelButton()
        }
        .add(to: disposeBag)

        searchBar.searchBarTextDidChangeObservable.subscribeNext { [weak self] query in
            self?.viewModel.searchQueryObservable.next(query)
            self?.viewModel.speakerLoadDataRequestObservable.next()
        }
        .add(to: disposeBag)
    }

    private func reactiveTableViewSetup() {
        viewModel.speakers.bind(to: tableView.item(with: SpeakersTableViewCell.cellIdentifier, cellType: SpeakersTableViewCell.self) ({ [weak self] index, speaker, cell in
            cell.load(with: speaker)
            self?.viewModel.checkIfLastSpeakerObservable.next(index)
        }))

        tableView.itemDidSelectObservable.subscribeNext { [weak self] index in
            self?.viewModel.speakerCellDidTapWithIndexObservable.next(index.row)
            self?.viewModel.searchBarShouldResignFirstResponderObservable.next()

            self?.tableView.deselectRow(at: index, animated: false)
        }
        .add(to: disposeBag)

        tableView.scrollViewDidScrollObservable.subscribeNext { [weak self] scrollView in
            guard let scrollView = scrollView, scrollView.isTracking else { return }

            self?.viewModel.searchBarShouldResignFirstResponderObservable.next()
        }
        .add(to: disposeBag)

        tableView.scrollViewWillEndDraggingObservable.subscribeNext { [weak self] scrollView in
            guard let scrollView = scrollView else { return }

            let offset = scrollView.contentOffset
            let bounds = scrollView.bounds
            let size = scrollView.contentSize
            let inset = scrollView.contentInset
            let currentYOffset = offset.y + bounds.size.height + inset.bottom
            let height = size.height
            let distance: CGFloat = 10.0

            if currentYOffset > height + distance {
                self?.showSpinner()
                self?.viewModel.tryToLoadMoreDataObservable.next()
            }
        }
        .add(to: disposeBag)

        viewModel.tableViewStateObservable.subscribeNext(startsWithInitialValue: true) { [weak self] state in
            guard let weakSelf = self else { return }

            DispatchQueue.once(token: Constants.offsetToken) {
                weakSelf.tableView.contentInset.top += weakSelf.searchBar.bounds.height
            }

            switch state {
            case .content:
                weakSelf.tableView.setContentOffset(CGPoint(x: 0, y: -weakSelf.tableView.contentInset.top), animated: false)
                weakSelf.tableView.overlayView = nil
            case .error:
                if !(weakSelf.tableView.overlayView is SadFaceView) {
                    weakSelf.sadFaceView.alpha = 1.0
                    weakSelf.tableView.overlayView = weakSelf.sadFaceView
                }
            case .loading:
                if !(weakSelf.tableView.overlayView is SpinnerView) {
                    weakSelf.spinnerView.alpha = 1.0
                    weakSelf.tableView.overlayView = weakSelf.spinnerView
                }
            }
        }
        .add(to: disposeBag)
    }
}
