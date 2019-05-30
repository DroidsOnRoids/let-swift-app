//
//  CommonEventViewController.swift
//  LetSwift
//
//  Created by Marcin Chojnacki on 10.05.2017.
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

class CommonEventViewController: AppViewController {
    
    enum EventCellIdentifier: String {
        case image = "StaticImageTableViewCell"
        case attend = "AttendButtonsRowTableViewCell"
        case eventSummary = "EventSummaryTableViewCell"
        case eventLocation = "EventLocationTableViewCell"
        case eventTime = "EventTimeTableViewCell"
        case previousEvents = "PreviousEventsListTableViewCell"
        case carouselEventPhotos = "CarouselEventPhotosTableViewCell"
        case speakerCardHeaderCell = "SpeakerCardHeaderTableViewCell"
        case speakerCardCell = "SpeakerCardTableViewCell"
        case speakersToBeAnnouncedCell = "SpeakersToBeAnnouncedTableViewCell"
    }
    
    var allCells: [EventCellIdentifier] {
        return []
    }
    
    var refreshObservable: Observable<Void>? {
        return nil
    }

    lazy var bindableCells = self.allCells.bindable
    
    override var nibName: String? {
        return String(describing: CommonEventViewController.self)
    }
    
    override var shouldHideShadow: Bool {
        return true
    }
    
    var viewModel: EventsViewControllerViewModel!

    @IBOutlet private(set) weak var tableView: AppTableView!
    
    private var cellNeedsSetup = [UITableViewCell: Bool]()
    private let sadFaceView = SadFaceView()
    private let disposeBag = DisposeBag()
    
    convenience init(viewModel: EventsViewControllerViewModel) {
        self.init()
        self.viewModel = viewModel
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setup()
    }
    
    private func setup() {
        tableView.childAutomaticallyUpdatesContentInset = true
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 60.0
        
        let inset = navigationController?.navigationBar.frame.maxY ?? 0.0
        sadFaceView.scrollView?.contentInset = UIEdgeInsets(top: inset, left: 0.0, bottom: -inset, right: 0.0)

        tableView.registerCells(allCells.map { $0.rawValue })
        
        setupPullToRefresh()
        reactiveSetup()
    }
    
    private func setupPullToRefresh() {
        tableView.addPullToRefresh(object: self, action: #selector(pullToRefreshAction))
        sadFaceView.scrollView?.addPullToRefresh(object: self, action: #selector(pullToRefreshAction))
        
        refreshObservable?.subscribeCompleted { [weak self] in
            self?.tableView.reloadData()
            
            self?.tableView.finishPullToRefresh()
            self?.sadFaceView.scrollView?.finishPullToRefresh()
        }
        .add(to: disposeBag)
    }
    
    @objc private func pullToRefreshAction() {
        refreshObservable?.next()
    }
    
    private func reactiveSetup() {
        viewModel.loginScreenObservable.subscribeNext { [weak self] in
            self?.coordinatorDelegate?.presentLoginViewController()
        }
        .add(to: disposeBag)
        
        viewModel.facebookAlertObservable.subscribeNext { [weak self] _ in
            guard let weakSelf = self else { return }
            AlertHelper.showAlert(withTitle: localized("GENERAL_SOMETHING_WENT_WRONG"), message: localized("GENERAL_TRY_AGAIN_LATER"), on: weakSelf)
        }
        .add(to: disposeBag)
        
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
        
        bindableCells.bind(to: tableView.items() ({ [weak self] tableView, index, element in
            let indexPath = IndexPath(row: index, section: 0)
            let cell = tableView.dequeueReusableCell(withIdentifier: element.rawValue, for: indexPath)
            cell.layoutMargins = UIEdgeInsets.zero
            
            if self?.cellNeedsSetup[cell] ?? true {
                self?.dispatchCellSetup(element: element, cell: cell, index: index)
                self?.cellNeedsSetup[cell] = false
            }
            
            return cell
        }))

        viewModel.actionButtonsStateObservable.subscribeNext { [weak self] state in
            switch state {
            case .hidden:
                guard let index = self?.bindableCells.values.firstIndex(of: .attend) else { return }

                self?.bindableCells.remove(at: index)
            case .showed:
                guard !(self?.bindableCells.values.contains(.attend) ?? false) else { return }

                self?.bindableCells.insert(.attend, at: 1)
            case .toHide:
                guard let index = self?.bindableCells.values.firstIndex(of: .attend) else { return }

                self?.bindableCells.remove(at: index, updated: false)
                self?.tableView.beginUpdates()
                self?.tableView.deleteRows(at: [IndexPath(row: index, section: 0)], with: .fade)
                self?.tableView.endUpdates()
            case .toShow:
                guard !(self?.bindableCells.values.contains(.attend) ?? false) else { return }

                self?.bindableCells.insert(.attend, at: 1, updated: false)
                self?.tableView.beginUpdates()
                self?.tableView.insertRows(at: [IndexPath(row: 1, section: 0)], with: .fade)
                self?.tableView.endUpdates()
            default: break
            }
        }
        .add(to: disposeBag)
        
        tableView.itemDidSelectObservable.subscribeNext { [weak self] indexPath in
            guard let cellType = self?.bindableCells.values[indexPath.row] else { return }
            
            self?.dispatchCellSelect(element: cellType)
            self?.tableView.deselectRow(at: indexPath, animated: true)
        }
        .add(to: disposeBag)

        viewModel.notificationPermissionsNotGrantedObservable.subscribeNext {
             UIAlertController.showSettingsAlert()
        }
        .add(to: disposeBag)
        
        NotificationCenter
            .default
            .notification(.didSelectAppTapBarWithController)
            .subscribeNext { [weak self] notification in
                guard let navigationController = notification?.object as? UINavigationController, navigationController.visibleViewController is EventsViewController else { return }

                self?.tableView.scrollToTop()
            }
            .add(to: disposeBag)
    }
    
    func setup(attendCell cell: AttendButtonsRowTableViewCell) {
        cell.addLeftTapTarget(target: viewModel, action: #selector(EventsViewControllerViewModel.attendButtonTapped))
        cell.addRightTapTarget(target: viewModel, action: #selector(EventsViewControllerViewModel.remindButtonTapped))
        
        viewModel.attendanceStateObservable.subscribeNext(startsWithInitialValue: true) { state in
            switch state {
            case .notAttending:
                cell.isLeftButtonActive = true
                cell.leftButtonTitle = localized("EVENTS_ATTEND")
                
            case .attending:
                cell.isLeftButtonActive = true
                cell.leftButtonTitle = localized("EVENTS_ATTENDING")
                
            case .loading:
                cell.isLeftButtonActive = false
                cell.leftButtonTitle = localized("EVENTS_LOADING")

            case .notAllowed:
                cell.isLeftButtonActive = true
                cell.leftButtonTitle = localized("EVENTS_SEE_PHOTOS")
            }
        }
        .add(to: disposeBag)
        
        viewModel.notificationStateObservable.subscribeNext(startsWithInitialValue: true) { state in
            switch state {
            case .notVisible:
                cell.isRightButtonVisible = false
                
            case .notActive:
                cell.rightButtonTitle = localized("EVENTS_REMIND_ME")
                cell.isRightButtonVisible = true
                
            case .active:
                cell.rightButtonTitle = localized("EVENTS_STOP_REMINDING")
                cell.isRightButtonVisible = true
            }
        }
        .add(to: disposeBag)
    }
    
    func setup(summaryCell cell: EventSummaryTableViewCell) {
        viewModel.lastEventObservable.subscribeNext(startsWithInitialValue: true) { event in
            cell.eventTitle = event?.title
        }
        .add(to: disposeBag)
    }
    
    func setup(locationCell cell: EventLocationTableViewCell) {
        viewModel.lastEventObservable.subscribeNext(startsWithInitialValue: true) { event in
            cell.placeName = event?.placeName ?? ""
            cell.placeLocation = event?.placeStreet ?? ""
        }
        .add(to: disposeBag)
    }
    
    func setup(timeCell cell: EventTimeTableViewCell) {
        viewModel.lastEventObservable.subscribeNext(startsWithInitialValue: true) { event in
            cell.date = event?.date?.stringDateValue
            cell.time = event?.date?.stringTimeValue
        }
        .add(to: disposeBag)
    }
    
    func dispatchCellSetup(element: EventCellIdentifier, cell: UITableViewCell, index: Int) {
        switch element {
        case .attend:
            self.setup(attendCell: cell as! AttendButtonsRowTableViewCell)
            
        case .eventSummary:
            self.setup(summaryCell: cell as! EventSummaryTableViewCell)
            
        case .eventLocation:
            self.setup(locationCell: cell as! EventLocationTableViewCell)
            
        case .eventTime:
            self.setup(timeCell: cell as! EventTimeTableViewCell)
            
        default: break
        }
    }
    
    func dispatchCellSelect(element: EventCellIdentifier) {
        switch element {
        case .eventLocation:
            viewModel.locationCellDidTapObservable.next()
        default: break
        }
    }
}
