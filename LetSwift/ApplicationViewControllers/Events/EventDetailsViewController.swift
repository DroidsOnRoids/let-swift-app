//
//  EventDetailsViewController.swift
//  LetSwift
//
//  Created by Marcin Chojnacki on 02.05.2017.
//  Copyright © 2017 Droids On Roids. All rights reserved.
//

import UIKit

final class EventDetailsViewController: CommonEventViewController {
    
    override var allCells: [EventCellIdentifier] {
        return [.carouselEventPhotos, .attend, .eventSummary, .eventLocation, .eventTime,
                .speakerCardHeaderCell, .speakerCardCell, .speakerCardCell, .speakerCardCell]
    }
    
    override var viewControllerTitleKey: String? {
        return "EVENTS_DETAILS_TITLE"
    }
    
    override var shouldShowUserIcon: Bool {
        return false
    }
    
    override func dispatchCellSetup(element: EventCellIdentifier, cell: UITableViewCell) {
        super.dispatchCellSetup(element: element, cell: cell)

        switch element {
        case .eventSummary:
            (cell as! EventSummaryCell).isClickable = false
            
        case .carouselEventPhotos:
            self.setup(carouselCell: cell as! CarouselEventPhotosCell)
        
        case .speakerCardCell:
            self.setup(speakerCardCell: cell as! SpeakerCardCell)

        default: break
        }
    }
    
    private func setup(carouselCell cell: CarouselEventPhotosCell) {
        viewModel.carouselCellDidSetObservable.next()

        viewModel.carouselEventPhotosViewModelObservable.subscribeNext(startsWithInitialValue: true) { viewModel in
            cell.viewModel = viewModel
        }
    }
    
    private func setup(speakerCardCell cell: SpeakerCardCell) {
        cell.addTapListeners(speaker: { [weak self] in
            self?.viewModel.speakerCellDidTapObservable.next()
        }, readMore: { [weak self] in
            self?.viewModel.lectureCellDidTapObservable.next()
        })
    }
}
