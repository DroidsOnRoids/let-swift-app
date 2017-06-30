//
//  SpeakerDetailsViewController.swift
//  LetSwift
//
//  Created by Marcin Chojnacki on 15.05.2017.
//  Copyright © 2017 Droids On Roids. All rights reserved.
//

import UIKit

protocol SpeakerDetailsViewControllerDelegate: class {
    func presentLectureScreen(with id: Int)
}

final class SpeakerDetailsViewController: AppViewController {
    
    override var viewControllerTitleKey: String? {
        return "SPEAKERS_DETAILS_TITLE"
    }
    
    override var shouldHideShadow: Bool {
        return true
    }
    
    @IBOutlet private weak var tableView: AppTableView!
    
    private var viewModel: SpeakerDetailsViewControllerViewModel!
    private lazy var bindableCells: BindableArray<String> = self.allCells.bindable
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
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 60.0
        // TODO: tableView.setHeaderColor(.lightBlueGrey)
        tableView.registerCells(allCells)
        
        reactiveSetup()
    }
    
    private func removeCell(of cellType: String) {
        if let index = bindableCells.values.index(of: cellType) {
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
                self?.tableView.setFooterColor(.white)
            } else {
                self?.tableView.setFooterColor(.paleGrey)
            }
            
            self?.tableView.reloadData()
        }
        .add(to: disposeBag)
        
        bindableCells.bind(to: tableView.items() ({ [weak self] tableView, index, element in
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
