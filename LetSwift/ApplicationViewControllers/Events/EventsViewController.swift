//
//  EventsViewController.swift
//  LetSwift
//
//  Created by Marcin Chojnacki, Kinga Wilczek on 21.04.2017.
//  Copyright © 2017 Droids On Roids. All rights reserved.
//

import UIKit

protocol EventsViewControllerDelegate: class {
    func presentEventDetailsScreen(model: Event)
}

final class EventsViewController: AppViewController {

    private enum EventsViewControllerCells: String {
        case image = "StaticImageCell"
        case attend = "AttendButtonsRowCell"
        case eventSummary = "EventSummaryCell"
        case eventLocation = "EventLocationCell"
        case eventTime = "EventTimeCell"
        case previousEvents = "PreviousEventsListCell"

        init?(int: Int) {
            switch int {
            case 0: self = .image
            case 1: self = .attend
            case 2: self = .eventSummary
            case 3: self = .eventLocation
            case 4: self = .eventTime
            case 5: self = .previousEvents
            default: return nil
            }
        }

        static let all: [EventsViewControllerCells] = [.image, .attend, .eventSummary, .eventLocation, .eventTime, .previousEvents]
    }

    @IBOutlet private weak var tableView: UITableView!
    
    fileprivate var viewModel: EventsViewControllerViewModel!
    
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
        
        viewModel.refreshAttendance()
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
        tableView.tableFooterView = UIView()
        
        EventsViewControllerCells.all.forEach { cell in
            tableView.register(UINib(nibName: cell.rawValue, bundle: nil), forCellReuseIdentifier: cell.rawValue)
        }

        reactiveSetup()
    }

    private func setup(imageCell cell: StaticImageCell) {
        cell.separatorInset = UIEdgeInsets(top: 0.0, left: 0.0, bottom: 0.0, right: cell.bounds.width)
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

    private func reactiveSetup() {
        EventsViewControllerCells.all.bindable.bind(to: tableView.items() ({ (tableView: UITableView, index, element) in
            let indexPath = IndexPath(row: index, section: 0)
            let cell = tableView.dequeueReusableCell(withIdentifier: element.rawValue, for: indexPath)

            switch element {
            case .image:
                self.setup(imageCell: cell as! StaticImageCell)

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

            return cell
        }))

        tableView.itemDidSelectObservable.subscribe { [weak self] indexPath in
            guard let cellType = EventsViewControllerCells(int: indexPath.row) else { return }
            
            switch cellType {
            case .eventSummary:
                self?.viewModel.summaryCellDidTapObservable.next()

            case .eventLocation:
                self?.viewModel.locationCellDidTapObservable.next()

            default: break
            }

            self?.tableView.deselectRow(at: indexPath, animated: true)
        }
    }
}
