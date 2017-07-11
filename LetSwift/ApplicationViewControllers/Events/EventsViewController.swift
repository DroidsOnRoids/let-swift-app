//
//  EventsViewController.swift
//  LetSwift
//
//  Created by Marcin Chojnacki, Kinga Wilczek on 21.04.2017.
//  Copyright © 2017 Droids On Roids. All rights reserved.
//

import UIKit

protocol EventsViewControllerDelegate: SpeakerLectureFlowDelegate {
    func presentEventDetailsScreen(fromViewModel: EventsViewControllerViewModel)
    func presentEventDetailsScreen(fromEventId: Int)
    func presentPhotoGalleryScreen(with photos: [Photo], eventId: Int?)
}

class EventsViewController: CommonEventViewController {
    
    override var allCells: [EventCellIdentifier] {
        return [.image, .attend, .eventSummary, .eventLocation, .eventTime, .previousEvents]
    }
    
    override var refreshObservable: Observable<Void>? {
        return viewModel.eventsListRefreshObservable
    }
    
    override var viewControllerTitleKey: String? {
        return "EVENTS_TITLE"
    }
    
    override var shouldShowUserIcon: Bool {
        return true
    }
    
    private let disposeBag = DisposeBag()
    
    private func setup(staticImageCell cell: StaticImageTableViewCell) {
        viewModel.lastEventObservable.subscribeNext(startsWithInitialValue: true) { event in
            cell.imageURL = event?.coverImages.first?.big
        }
        .add(to: disposeBag)
    }
    
    private func setup(previousEventsCell cell: PreviousEventsListTableViewCell) {
        viewModel.previousEventsCellDidSetObservable.next()
        
        viewModel.previousEventsViewModelObservable.subscribeNext(startsWithInitialValue: true) { viewModel in
            cell.viewModel = viewModel
        }
        .add(to: disposeBag)
    }

    override func dispatchCellSetup(element: EventCellIdentifier, cell: UITableViewCell, index: Int) {
        super.dispatchCellSetup(element: element, cell: cell, index: index)
        
        switch element {
        case .image:
            self.setup(staticImageCell: cell as! StaticImageTableViewCell)
        case .previousEvents:
            self.setup(previousEventsCell: cell as! PreviousEventsListTableViewCell)
        default: break
        }
    }
    
    override func dispatchCellSelect(element: EventCellIdentifier) {
        super.dispatchCellSelect(element: element)
        
        switch element {
        case .image, .eventSummary:
            viewModel.summaryCellDidTapObservable.next()
        default: break
        }
    }
}
