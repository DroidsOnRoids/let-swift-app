//
//  EventDetailsViewController.swift
//  LetSwift
//
//  Created by Marcin Chojnacki on 02.05.2017.
//  Copyright © 2017 Droids On Roids. All rights reserved.
//

import UIKit

final class EventDetailsViewController: CommonEventViewController {
    
    override var allCells: [EventCell] {
        return [.carouselEventPhotos, .attend, .eventSummary, .eventLocation, .eventTime]
    }
    
    override var viewControllerTitleKey: String? {
        return "EVENTS_DETAILS_TITLE"
    }
    
    override var shouldShowUserIcon: Bool {
        return false
    }
    
    // TODO: remove it
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        viewModel.viewWillAppearDidPerformObservable.next()
    }

    override func dispatchCellSetup(element: EventCell, cell: UITableViewCell) {
        super.dispatchCellSetup(element: element, cell: cell)

        switch element {
        case .eventSummary:
            (cell as! EventSummaryCell).isClickable = false
            
        case .carouselEventPhotos:
            self.setup(carouselCell: cell as! CarouselEventPhotosCell)

        default: break
        }
    }

    private func setup(carouselCell cell: CarouselEventPhotosCell) {
        viewModel.carouselCellDidSetObservable.next()

        viewModel.carouselEventPhotosViewModelObservable.subscribe(startsWithInitialValue: true) { viewModel in
            cell.viewModel = viewModel
        }
    }
}
