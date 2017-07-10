//
//  CommonEventViewController.swift
//  LetSwift
//
//  Created by Marcin Chojnacki on 10.05.2017.
//  Copyright © 2017 Droids On Roids. All rights reserved.
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
        case speakerCardHeaderCell = "SpeakerCardHeaderCell"
        case speakerCardCell = "SpeakerCardCell"
        case speakersToBeAnnouncedCell = "SpeakersToBeAnnouncedCell"
    }

    var allCells: [EventCellIdentifier] {
        return []
    }
    
    var refreshObservable: Observable<Void>? {
        return nil
    }

    lazy var bindableCells: BindableArray<EventCellIdentifier> = self.allCells.bindable
    
    override var nibName: String? {
        return String(describing: CommonEventViewController.self)
    }
    
    override var shouldHideShadow: Bool {
        return true
    }

    @IBOutlet weak var tableView: AppTableView!
    private let sadFaceView = SadFaceView()
    
    var viewModel: EventsViewControllerViewModel!
    
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
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 60.0
        tableView.setFooterColor(.paleGrey)
        tableView.setHeaderColor(.lightBlueGrey)
        
        let inset = navigationController?.navigationBar.frame.maxY ?? 0.0
        sadFaceView.scrollView?.contentInset = UIEdgeInsets(top: inset, left: 0.0, bottom: -inset, right: 0.0)

        tableView.registerCells(allCells.map { $0.rawValue })
        
        setupPullToRefresh()
        reactiveSetup()
    }
    
    private func setupPullToRefresh() {
        tableView.addPullToRefresh { [weak self] in
            self?.refreshObservable?.next()
        }
        
        sadFaceView.scrollView?.addPullToRefresh { [weak self] in
            self?.refreshObservable?.next()
        }
        
        refreshObservable?.subscribeCompleted { [weak self] in
            self?.tableView.finishPullToRefresh()
            self?.sadFaceView.scrollView?.finishPullToRefresh()

            self?.tableView.reloadData()
        }
        .add(to: disposeBag)
    }
    
    private func reactiveSetup() {
        viewModel.loginScreenObservable.subscribeNext { [weak self] in
            self?.coordinatorDelegate?.presentLoginViewController(asPopupWindow: true)
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
        
        viewModel.lastEventObservable.subscribeNext(startsWithInitialValue: true) { [weak self] event in
            guard let weakSelf = self,
                let eventDate =  event?.date,
                event?.photos.isEmpty ?? true,
                eventDate.addingTimeInterval(20.0).isOutdated,
                let index = weakSelf.bindableCells.values.index(of: .attend) else { return }
            
            weakSelf.bindableCells.remove(at: index)
        }
        .add(to: disposeBag)
        
        bindableCells.bind(to: tableView.items() ({ [weak self] tableView, index, element in
            let indexPath = IndexPath(row: index, section: 0)
            let cell = tableView.dequeueReusableCell(withIdentifier: element.rawValue, for: indexPath)
            cell.layoutMargins = UIEdgeInsets.zero
            
            self?.dispatchCellSetup(element: element, cell: cell, index: index)
            
            return cell
        }))
        
        viewModel.eventDidFinishObservable.subscribeNext(startsWithInitialValue: true) { [weak self] event in
            guard let weakSelf = self, let event = event else { return }
            if weakSelf.bindableCells.values.contains(.attend), let index = weakSelf.bindableCells.values.index(of: .attend), event.photos.isEmpty {
                weakSelf.bindableCells.remove(at: index, updated: false)
                weakSelf.tableView.deleteRows(at: [IndexPath(row: index, section: 0)], with: .fade)
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
