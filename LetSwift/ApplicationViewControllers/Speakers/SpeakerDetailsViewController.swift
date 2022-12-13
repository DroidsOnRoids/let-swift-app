//
//  SpeakerDetailsViewController.swift
//  LetSwift
//
//  Created by Marcin Chojnacki on 15.05.2017.
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

final class SpeakerDetailsViewController: AppViewController {
    
    override var viewControllerTitleKey: String? {
        return "SPEAKERS_DETAILS_TITLE"
    }
    
    override var shouldHideShadow: Bool {
        return true
    }
    
    @IBOutlet private weak var tableView: AppTableView!
    
    private var viewModel: SpeakerDetailsViewControllerViewModel!
    private lazy var bindableCells = self.allCells.bindable
    private let disposeBag = DisposeBag()
    private let sadFaceView = SadFaceView()
    
    private let allCells = [
        SpeakerHeaderTableViewCell.cellIdentifier,
        SpeakerWebsitesTableViewCell.cellIdentifier,
        SpeakerBioTableViewCell.cellIdentifier,
        SpeakerLecturesTableViewCell.cellIdentifier
    ]
    
    convenience init(viewModel: SpeakerDetailsViewControllerViewModel) {
        self.init()
        self.viewModel = viewModel
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
    }
    
    private func setup() {
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 60.0
        tableView.registerCells(allCells)
        
        setupPullToRefresh()
        reactiveSetup()
    }
    
    private func setupPullToRefresh() {
        tableView.addPullToRefresh(object: self, action: #selector(pullToRefreshAction))
        
        sadFaceView.scrollView?.addPullToRefresh(object: self, action: #selector(pullToRefreshAction))
        
        viewModel.refreshObservable.subscribeCompleted { [weak self] in
            self?.tableView.finishPullToRefresh()
            self?.sadFaceView.scrollView?.finishPullToRefresh()
        }
        .add(to: disposeBag)
    }
    
    @objc private func pullToRefreshAction() {
        viewModel.refreshObservable.next()
    }
    
    private func removeCell(of cellType: String) {
        if let index = bindableCells.values.firstIndex(of: cellType) {
            bindableCells.remove(at: index)
        }
    }
    
    private func reactiveSetup() {
        viewModel.speakerObservable.subscribeNext { [weak self] speaker in
            if speaker?.websites.isEmpty ?? true {
                self?.removeCell(of: SpeakerWebsitesTableViewCell.cellIdentifier)
            }
            
            if speaker?.talks.isEmpty ?? true {
                self?.removeCell(of: SpeakerLecturesTableViewCell.cellIdentifier)
                self?.tableView.backgroundColor = .white
            } else {
                self?.tableView.backgroundColor = .paleGrey
            }
            
            self?.tableView.reloadData()
        }
        .add(to: disposeBag)
        
        bindableCells.bind(to: tableView.items()({ [weak self] tableView, index, element in
            let indexPath = IndexPath(row: index, section: 0)
            let cell = tableView.dequeueReusableCell(withIdentifier: element, for: indexPath)
            cell.layoutMargins = UIEdgeInsets.zero
            
            self?.setupCells(element: element, cell: cell, index: index)
            
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
    }
    
    private func setupCells(element: String, cell: UITableViewCell, index: Int) {
        viewModel.speakerObservable.subscribeNext { [weak self] speaker in
            guard let speaker = speaker else { return }
            
            (cell as? SpeakerLoadable)?.load(with: speaker)
            if let lecturesCell = cell as? SpeakerLecturesTableViewCell {
                self?.setupLecturesCell(lecturesCell)
            }
        }
        .add(to: disposeBag)
    }
    
    private func setupLecturesCell(_ cell: SpeakerLecturesTableViewCell) {
        cell.lectureDetailsObservable
            .bindNext(to: viewModel.showLectureDetailsObservable)
            .add(to: disposeBag)
    }
}
