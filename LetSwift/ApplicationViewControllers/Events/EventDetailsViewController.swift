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
                .speakerCardHeaderCell]
    }
    
    override var viewControllerTitleKey: String? {
        return "EVENTS_DETAILS_TITLE"
    }
    
    override var shouldShowUserIcon: Bool {
        return false
    }
    
    private let disposeBag = DisposeBag()

    override func viewDidLoad() {
        super.viewDidLoad()

        setup()
    }
    
    override func dispatchCellSetup(element: EventCellIdentifier, cell: UITableViewCell, index: Int) {
        super.dispatchCellSetup(element: element, cell: cell, index: index)

        switch element {
        case .eventSummary:
            (cell as! EventSummaryCell).isClickable = false
            
        case .carouselEventPhotos:
            self.setup(carouselCell: cell as! CarouselEventPhotosCell)
        
        case .speakerCardCell:
            self.setup(speakerCardCell: cell as! SpeakerCardCell, index: index)

        default: break
        }
    }

    private func setup() {
        tableView.register(UINib(nibName: EventCellIdentifier.speakerCardCell.rawValue, bundle: nil), forCellReuseIdentifier: EventCellIdentifier.speakerCardCell.rawValue)

        reactiveSetup()
    }

    private func reactiveSetup() {
        viewModel.lastEventObservable.subscribeNext(startsWithInitialValue: true) { [weak self] event in
            let speakersTalks = [EventCellIdentifier](repeating: .speakerCardCell, count: event.talks.count)
            self?.bindableCells.append(speakersTalks.isEmpty ? [.speakerCardCell] : speakersTalks)
        }
        .add(to: disposeBag)
    }
    
    private func setup(carouselCell cell: CarouselEventPhotosCell) {
        viewModel.carouselCellDidSetObservable.next()

        viewModel.carouselEventPhotosViewModelObservable.subscribeNext(startsWithInitialValue: true) { viewModel in
            cell.viewModel = viewModel
        }
        .add(to: disposeBag)
    }
    
    private func setup(speakerCardCell cell: SpeakerCardCell, index: Int) {
        viewModel.lastEventObservable
                .filer { !$0.talks.isEmpty }
                .subscribeNext(startsWithInitialValue: true) { [weak self] event in
                    print(event)
                }
                .add(to: disposeBag)

        cell.addTapListeners(speaker: { [weak self] in
            self?.viewModel.speakerCellDidTapObservable.next()
        }, readMore: { [weak self] in
            self?.viewModel.lectureCellDidTapObservable.next()
        })
    }
}
