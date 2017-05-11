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

class EventsViewController: CommonEventViewController {
    
    override var allCells: [EventCellIdentifier] {
        return [.image, .attend, .eventSummary, .eventLocation, .eventTime, .previousEvents]
    }
    
    override var viewControllerTitleKey: String? {
        return "EVENTS_TITLE"
    }
    
    override var shouldShowUserIcon: Bool {
        return true
    }
    
    private func setup(previousEventsCell cell: PreviousEventsListCell) {
        viewModel.previousEventsCellDidSetObservable.next()
        
        viewModel.previousEventsViewModelObservable.subscribe(startsWithInitialValue: true) { viewModel in
            cell.viewModel = viewModel
        }
    }

    override func dispatchCellSetup(element: EventCellIdentifier, cell: UITableViewCell) {
        super.dispatchCellSetup(element: element, cell: cell)
        
        switch element {
        case .previousEvents:
            self.setup(previousEventsCell: cell as! PreviousEventsListCell)
            
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
