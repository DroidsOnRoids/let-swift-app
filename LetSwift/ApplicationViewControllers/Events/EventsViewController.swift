//
//  EventsViewController.swift
//  LetSwift
//
//  Created by Marcin Chojnacki, Kinga Wilczek on 21.04.2017.
//  Copyright © 2017 Droids On Roids. All rights reserved.
//

import UIKit

final class EventsViewController: AppViewController {

    @IBOutlet private weak var tableView: UITableView!
    
    fileprivate enum Constants {
        static let viewCells = [
            "StaticImageCell",
            "AttendButtonsRowCell",
            "EventSummaryCell",
            "EventLocationCell",
            "EventTimeCell",
            "PreviousEventsListCell"
        ]
    }
    
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

    private func setup() {
        tableView.delegate = self
        
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 60.0
        tableView.tableFooterView = UIView()
        
        Constants.viewCells.forEach { cell in
            tableView.register(UINib(nibName: cell, bundle: nil), forCellReuseIdentifier: cell)
        }

        reactiveSetup()
    }

    private func reactiveSetup() {
        Constants.viewCells.bindable.bind(to: tableView.items() ({ (tableView: UITableView, index, element) in
            let indexPath = IndexPath(row: index, section: 0)
            let cell = tableView.dequeueReusableCell(withIdentifier: Constants.viewCells[indexPath.row], for: indexPath)

            // TODO: REWRITE IT TO REACTIVE TABLE VIEW
            switch indexPath.row {
            case 0:
                cell.separatorInset = UIEdgeInsets(top: 0.0, left: 0.0, bottom: 0.0, right: cell.bounds.width)

            case 1:
                //buttons
                guard let cell = cell as? AttendButtonsRowCell else { return UITableViewCell() }

                cell.attendButton.addTarget(self.viewModel, action: #selector(EventsViewControllerViewModel.attendButtonTapped), for: .touchUpInside)
                cell.remindButton.addTarget(self.viewModel, action: #selector(EventsViewControllerViewModel.remindButtonTapped), for: .touchUpInside)

                self.viewModel.attendanceState.subscribe(startsWithInitialValue: true) { state in
                    switch state {
                    case .notLoggedIn:
                        // TODO: localized
                        cell.attendButtonActive = false
                        cell.attendButton.setTitle("UNAVAILABLE", for: [])

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

                self.viewModel.notificationState.subscribe(startsWithInitialValue: true) { state in
                    switch state {
                    case .notActive:
                        cell.remindButton.setTitle(localized("EVENTS_REMIND_ME").uppercased(), for: [])

                    case .active:
                        cell.remindButton.setTitle(localized("EVENTS_STOP_REMINDING").uppercased(), for: [])
                    }
                }
                break

            case 2:
                //summary cell
                guard let cell = cell as? EventSummaryCell else { return UITableViewCell() }
                self.viewModel.lastEvent.subscribe(startsWithInitialValue: true) { event in
                    cell.eventTitle = event.title
                }
                break

            case 3:
                //location cell
                guard let cell = cell as? EventLocationCell else { return UITableViewCell() }
                self.viewModel.lastEvent.subscribe(startsWithInitialValue: true) { event in
                    if let placeName = event.placeName {
                        cell.placeName = placeName
                    }

                    if let placeStreet = event.placeStreet {
                        cell.placeLocation = placeStreet
                    }
                }
                break

            case 4:
                //date cell
                guard let cell = cell as? EventTimeCell else { return UITableViewCell() }
                self.viewModel.lastEvent.subscribe(startsWithInitialValue: true) { [unowned self] event in
                    cell.date = self.viewModel.formattedDate
                    cell.time = self.viewModel.formattedTime
                }
                break
                
            default: break
            }
            
            return cell
        }))
    }
}

extension EventsViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        // TODO: REWRITE IT TO REACTIVE TABLE VIEW
        switch indexPath.row {
        case 2:
            //summary cell
            viewModel.summaryCellTapped()
            
        case 3:
            //location cell
            viewModel.locationCellTapped()
        default: break
        }
        
        tableView.deselectRow(at: indexPath, animated: true)
    }
}
