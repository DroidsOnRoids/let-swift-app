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
        case image = "StaticImageCell"
        case attend = "AttendButtonsRowCell"
        case eventSummary = "EventSummaryCell"
        case eventLocation = "EventLocationCell"
        case eventTime = "EventTimeCell"
        case previousEvents = "PreviousEventsListCell"
        case carouselEventPhotos = "CarouselEventPhotosCell"
    }
    
    var allCells: [EventCellIdentifier] {
        return []
    }
    
    override var nibName: String? {
        return String(describing: CommonEventViewController.self)
    }
    
    override var shouldHideShadow: Bool {
        return true
    }
    
    @IBOutlet weak var tableView: UITableView!
    
    var viewModel: EventsViewControllerViewModel!
    
    convenience init(viewModel: EventsViewControllerViewModel) {
        self.init()
        self.viewModel = viewModel
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setup()
    }
    
    private func setupViewModel() {
        viewModel.loginScreenObservable.subscribe(onNext: { [unowned self] in
            self.coordinatorDelegate?.presentLoginViewController(asPopupWindow: true)
        })
        
        viewModel.facebookAlertObservable.subscribe(onNext: { [unowned self] error in
            AlertHelper.showAlert(withTitle: localized("GENERAL_FACEBOOK_ERROR"), message: error, on: self)
        })
    }
    
    private func setup() {
        setupViewModel()
        
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 60.0
        tableView.setFooterColor(color: UIColor.paleGrey)
        
        allCells.forEach { cell in
            tableView.register(UINib(nibName: cell.rawValue, bundle: nil), forCellReuseIdentifier: cell.rawValue)
        }
        
        reactiveSetup()
    }
    
    func setup(attendCell cell: AttendButtonsRowCell) {
        cell.attendButton.addTarget(viewModel, action: #selector(EventsViewControllerViewModel.attendButtonTapped), for: .touchUpInside)
        cell.remindButton.addTarget(viewModel, action: #selector(EventsViewControllerViewModel.remindButtonTapped), for: .touchUpInside)
        
        viewModel.attendanceState.subscribe(startsWithInitialValue: true) { state in
            switch state {
            case .notAttending:
                cell.attendButtonActive = true
                cell.attendButton.setTitle(localized("EVENTS_ATTEND").uppercased(), for: [])
                
            case .attending:
                cell.attendButtonActive = true
                cell.attendButton.setTitle(localized("EVENTS_ATTENDING").uppercased(), for: [])
                
            case .loading:
                cell.attendButtonActive = false
                cell.attendButton.setTitle(localized("EVENTS_LOADING").uppercased(), for: [])
            }
        }
        
        viewModel.notificationState.subscribe(startsWithInitialValue: true) { state in
            switch state {
            case .notActive:
                cell.remindButton.setTitle(localized("EVENTS_REMIND_ME").uppercased(), for: [])
            case .active:
                cell.remindButton.setTitle(localized("EVENTS_STOP_REMINDING").uppercased(), for: [])
            }
        }
        
        viewModel.remindButtonVisibilityObservable.subscribe(startsWithInitialValue: true) { isVisible in
            cell.isRemindButtonVisible = isVisible
        }
    }
    
    func setup(summaryCell cell: EventSummaryCell) {
        viewModel.lastEvent.subscribe(startsWithInitialValue: true) { event in
            cell.eventTitle = event.title
        }
    }
    
    func setup(locationCell cell: EventLocationCell) {
        viewModel.lastEvent.subscribe(startsWithInitialValue: true) { event in
            if let placeName = event.placeName {
                cell.placeName = placeName
            }
            
            if let placeStreet = event.placeStreet {
                cell.placeLocation = placeStreet
            }
        }
    }
    
    func setup(timeCell cell: EventTimeCell) {
        viewModel.lastEvent.subscribe(startsWithInitialValue: true) { [unowned self] event in
            cell.date = self.viewModel.formattedDate
            cell.time = self.viewModel.formattedTime
        }
    }
    
    func dispatchCellSetup(element: EventCellIdentifier, cell: UITableViewCell) {
        switch element {
        case .attend:
            self.setup(attendCell: cell as! AttendButtonsRowCell)
            
        case .eventSummary:
            self.setup(summaryCell: cell as! EventSummaryCell)
            
        case .eventLocation:
            self.setup(locationCell: cell as! EventLocationCell)
            
        case .eventTime:
            self.setup(timeCell: cell as! EventTimeCell)
            
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
    
    private func reactiveSetup() {
        allCells.bindable.bind(to: tableView.items() ({ [weak self] tableView, index, element in
            let indexPath = IndexPath(row: index, section: 0)
            let cell = tableView.dequeueReusableCell(withIdentifier: element.rawValue, for: indexPath)
            
            self?.dispatchCellSetup(element: element, cell: cell)
            
            return cell
        }))
        
        tableView.itemDidSelectObservable.subscribe { [weak self] indexPath in
            guard let cellType = self?.allCells[indexPath.row] else { return }
            
            self?.dispatchCellSelect(element: cellType)
            
            self?.tableView.deselectRow(at: indexPath, animated: true)
        }
    }
}
