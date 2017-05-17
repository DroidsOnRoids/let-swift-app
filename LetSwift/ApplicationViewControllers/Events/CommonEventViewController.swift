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
        case speakerCardHeaderCell = "SpeakerCardHeaderCell"
        case speakerCardCell = "SpeakerCardCell"
    }

    var allCells: [EventCellIdentifier] {
        return []
    }

    lazy var bindableCells: BindableArray<EventCellIdentifier> = self.allCells.bindable
    
    override var nibName: String? {
        return String(describing: CommonEventViewController.self)
    }
    
    override var shouldHideShadow: Bool {
        return true
    }
    
    @IBOutlet private weak var tableView: UITableView!
    
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
        viewModel.loginScreenObservable.subscribe(onNext: { [weak self] in
            self?.coordinatorDelegate?.presentLoginViewController(asPopupWindow: true)
        })
        
        viewModel.facebookAlertObservable.subscribe(onNext: { [weak self] error in
            guard let weakSelf = self else { return }
            AlertHelper.showAlert(withTitle: localized("GENERAL_FACEBOOK_ERROR"), message: error, on: weakSelf)
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
        cell.addLeftTapTarget(target: viewModel, action: #selector(EventsViewControllerViewModel.attendButtonTapped))
        cell.addRightTapTarget(target: viewModel, action: #selector(EventsViewControllerViewModel.remindButtonTapped))
        
        viewModel.attendanceStateObservable.subscribe(startsWithInitialValue: true) { state in
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
        
        viewModel.notificationStateObservable.subscribe(startsWithInitialValue: true) { state in
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
    }
    
    func setup(summaryCell cell: EventSummaryCell) {
        viewModel.lastEventObservable.subscribe(startsWithInitialValue: true) { event in
            cell.eventTitle = event.title
        }
    }
    
    func setup(locationCell cell: EventLocationCell) {
        viewModel.lastEventObservable.subscribe(startsWithInitialValue: true) { event in
            if let placeName = event.placeName {
                cell.placeName = placeName
            }
            
            if let placeStreet = event.placeStreet {
                cell.placeLocation = placeStreet
            }
        }
    }
    
    func setup(timeCell cell: EventTimeCell) {
        viewModel.lastEventObservable.subscribe(startsWithInitialValue: true) { [weak self] event in
            guard let weakSelf = self else { return }
            cell.date = weakSelf.viewModel.formattedDate
            cell.time = weakSelf.viewModel.formattedTime
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
        viewModel.lastEventObservable.subscribe(startsWithInitialValue: true) { [weak self] event in
            guard let weakSelf = self,
                  let eventDate =  event.date,
                  event.photos.isEmpty,
                  eventDate.addingTimeInterval(20.0).isOutdated,
                  let index = weakSelf.bindableCells.values.index(of: .attend) else { return }

            weakSelf.bindableCells.remove(at: index)
        }

        bindableCells.bind(to: tableView.items() ({ [weak self] tableView, index, element in
            let indexPath = IndexPath(row: index, section: 0)
            let cell = tableView.dequeueReusableCell(withIdentifier: element.rawValue, for: indexPath)
            
            self?.dispatchCellSetup(element: element, cell: cell)
            
            return cell
        }))

        viewModel.eventDidFinishObservable.subscribe(startsWithInitialValue: true) { [weak self] event in
            guard let weakSelf = self, let event = event else { return }
            if weakSelf.bindableCells.values.contains(.attend), let index = weakSelf.bindableCells.values.index(of: .attend) , event.photos.isEmpty {
                weakSelf.bindableCells.remove(at: index, updated: false)
                weakSelf.tableView.deleteRows(at: [IndexPath(row: index, section: 0)], with: .fade)
            }
        }

        tableView.itemDidSelectObservable.subscribe { [weak self] indexPath in
            guard let cellType = self?.bindableCells.values[indexPath.row] else { return }
            
            self?.dispatchCellSelect(element: cellType)
            
            self?.tableView.deselectRow(at: indexPath, animated: true)
        }
    }
}
