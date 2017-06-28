//
//  SpeakerDetailsViewController.swift
//  LetSwift
//
//  Created by Marcin Chojnacki on 15.05.2017.
//  Copyright © 2017 Droids On Roids. All rights reserved.
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
    
    private let disposeBag = DisposeBag()
    private let sadFaceView = SadFaceView()
    private let allCells = [
        SpeakerHeaderTableViewCell.cellIdentifier
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
        tableView.setFooterColor(.paleGrey)
        //tableView.setHeaderColor(.lightBlueGrey)
        tableView.registerCells(allCells)
        
        reactiveSetup()
    }
    
    private func reactiveSetup() {
        /*viewModel.speakerObservable.subscribeNext { [weak self] speaker in
            
        }
        .add(to: disposeBag)*/
        
        allCells.bindable.bind(to: tableView.items() ({ [weak self] tableView, index, element in
            let indexPath = IndexPath(row: index, section: 0)
            let cell = tableView.dequeueReusableCell(withIdentifier: element, for: indexPath)
            //cell.layoutMargins = UIEdgeInsets.zero
            
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
    }
    
    private func dispatchCellSetup(element: String, cell: UITableViewCell, index: Int) {
        switch element {
        case SpeakerHeaderTableViewCell.cellIdentifier:
            self.setup(headerCell: cell as! SpeakerHeaderTableViewCell)
        default: break
        }
    }
    
    private func setup(headerCell cell: SpeakerHeaderTableViewCell) {
        viewModel.speakerObservable.subscribeNext { speaker in
            
        }
        .add(to: disposeBag)
    }
}
