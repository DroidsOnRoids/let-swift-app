//
//  EventsViewController.swift
//  LetSwift
//
//  Created by Marcin Chojnacki, Kinga Wilczek on 21.04.2017.
//  Copyright © 2017 Droids On Roids. All rights reserved.
//

import UIKit

protocol EventsViewControllerDelegate: class {
    func presentEventDetailsScreen(fromViewModel: EventsViewControllerViewModel)
    func presentEventDetailsScreen(fromModel: Event)
    func collectionViewCellDidTap(with model: Event)
}

class EventsViewController: AppViewController {

    enum EventCells: String {
        case image = "StaticImageCell"
        case attend = "AttendButtonsRowCell"
        case eventSummary = "EventSummaryCell"
        case eventLocation = "EventLocationCell"
        case eventTime = "EventTimeCell"
        case previousEvents = "PreviousEventsListCell"
    }
    
    var allCells: [EventCells] {
        return [.image, .attend, .eventSummary, .eventLocation, .eventTime, .previousEvents]
    }

    @IBOutlet private weak var tableView: UITableView!
    
    var viewModel: EventsViewControllerViewModel!
    
    override var viewControllerTitleKey: String? {
        return "EVENTS_TITLE"
    }
    
    override var shouldShowUserIcon: Bool {
        return true
    }
    
    override var shouldHideShadow: Bool {
        return true
    }

    convenience init(viewModel: EventsViewControllerViewModel) {
        self.init()
        self.viewModel = viewModel
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        setup()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        viewModel.viewWillAppearDidPerformObservable.next()
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

    private func setup(attendCell cell: AttendButtonsRowCell) {
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

    private func setup(summaryCell cell: EventSummaryCell) {
        viewModel.lastEvent.subscribe(startsWithInitialValue: true) { event in
            cell.eventTitle = event.title
        }
    }

    private func setup(locationCell cell: EventLocationCell) {
        viewModel.lastEvent.subscribe(startsWithInitialValue: true) { event in
            if let placeName = event.placeName {
                cell.placeName = placeName
            }

            if let placeStreet = event.placeStreet {
                cell.placeLocation = placeStreet
            }
        }
    }

    private func setup(timeCell cell: EventTimeCell) {
        viewModel.lastEvent.subscribe(startsWithInitialValue: true) { [unowned self] event in
            cell.date = self.viewModel.formattedDate
            cell.time = self.viewModel.formattedTime
        }
    }

    private func setup(previousEventsCell cell: PreviousEventsListCell) {
        viewModel.previousEventsCellDidSetObservable.next()
        
        viewModel.previousEventsViewModelObservable.subscribe(startsWithInitialValue: true) { viewModel in
            cell.viewModel = viewModel
        }
    }

    private func reactiveSetup() {
        allCells.bindable.bind(to: tableView.items() ({ (tableView: UITableView, index, element) in
            let indexPath = IndexPath(row: index, section: 0)
            let cell = tableView.dequeueReusableCell(withIdentifier: element.rawValue, for: indexPath)

            switch element {
            case .attend:
                self.setup(attendCell: cell as! AttendButtonsRowCell)

            case .eventSummary:
                self.setup(summaryCell: cell as! EventSummaryCell)

            case .eventLocation:
                self.setup(locationCell: cell as! EventLocationCell)

            case .eventTime:
                self.setup(timeCell: cell as! EventTimeCell)

            case .previousEvents:
                self.setup(previousEventsCell: cell as! PreviousEventsListCell)
                
            default: break
            }

            return cell
        }))

        tableView.itemDidSelectObservable.subscribe { [weak self] indexPath in
            guard let cellType = self?.allCells[indexPath.row] else { return }
            
            switch cellType {
            case .image, .eventSummary, .previousEvents:
                self?.viewModel.summaryCellDidTapObservable.next()

            case .eventLocation:
                self?.viewModel.locationCellDidTapObservable.next()

            default: break
            }

            self?.tableView.deselectRow(at: indexPath, animated: true)
        }
    }
}
