//
//  EventDetailsViewController.swift
//  LetSwift
//
//  Created by Marcin Chojnacki on 02.05.2017.
//  Copyright © 2017 Droids On Roids. All rights reserved.
//
//  Licensed under the Apache License, Version 2.0 (the "License");
//  you may not use this file except in compliance with the License.
//  You may obtain a copy of the License at
//
//       http://www.apache.org/licenses/LICENSE-2.0
//
//  Unless required by applicable law or agreed to in writing, software
//  distributed under the License is distributed on an "AS IS" BASIS,
//  WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
//  See the License for the specific language governing permissions and
//  limitations under the License.
//

import UIKit

final class EventDetailsViewController: CommonEventViewController {
    
    override var allCells: [EventCellIdentifier] {
        return [.carouselEventPhotos, .attend, .eventSummary, .eventLocation, .eventTime,
                .speakerCardHeaderCell]
    }
    
    override var refreshObservable: Observable<Void>? {
        return viewModel.eventDetailsRefreshObservable
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
            (cell as! EventSummaryTableViewCell).isClickable = false
            
        case .carouselEventPhotos:
            self.setup(carouselCell: cell as! CarouselEventPhotosTableViewCell)
        
        case .speakerCardCell:
            self.setup(speakerCardCell: cell as! SpeakerCardTableViewCell, index: index)

        default: break
        }
    }

    private func setup() {
        tableView.registerCells([EventCellIdentifier.speakerCardCell.rawValue, EventCellIdentifier.speakersToBeAnnouncedCell.rawValue])

        reactiveSetup()
    }

    private func reactiveSetup() {
        viewModel.lastEventObservable.subscribeNext(startsWithInitialValue: true) { [weak self] event in
            guard let event = event else { return }
            let speakersTalks = [EventCellIdentifier](repeating: .speakerCardCell, count: event.talks.count)
            self?.bindableCells.remove(updated: false) {
                [.speakerCardCell, .speakersToBeAnnouncedCell].contains($0)
            }
            self?.bindableCells.append(speakersTalks.isEmpty ? [.speakersToBeAnnouncedCell] : speakersTalks)
        }
        .add(to: disposeBag)
    }
    
    private func setup(carouselCell cell: CarouselEventPhotosTableViewCell) {
        viewModel.carouselEventPhotosViewModelObservable.subscribeNext(startsWithInitialValue: true) { viewModel in
            cell.viewModel = viewModel
        }
        .add(to: disposeBag)
    }
    
    private func setup(speakerCardCell cell: SpeakerCardTableViewCell, index: Int) {
        viewModel.lastEventObservable
            .filter { !($0?.talks.isEmpty ?? true) }
            .subscribeNext(startsWithInitialValue: true) { [weak self] event in
                guard let weakSelf = self, let event = event else { return }

                let speakerIndex = weakSelf.bindableCells.values.count - index

                guard event.talks.count >= speakerIndex else { return }

                let talkId = event.talks.count - speakerIndex
                let talk = event.talks[talkId]
                cell.loadData(with: talk)

                cell.addTapListeners(speaker: { [weak self] in
                    self?.viewModel.speakerCellDidTapObservable.next(talkId)
                }, readMore: { [weak self] in
                    self?.viewModel.lectureCellDidTapObservable.next(talkId)
                })
                
                cell.layoutIfNeeded()
            }
            .add(to: disposeBag)
    }
}
