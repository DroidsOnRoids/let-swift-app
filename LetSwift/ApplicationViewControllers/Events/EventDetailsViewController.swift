//
//  EventDetailsViewController.swift
//  LetSwift
//
//  Created by Marcin Chojnacki on 02.05.2017.
//  Copyright © 2017 Droids On Roids. All rights reserved.
//

final class EventDetailsViewController: EventsViewController {
    
    override var allCells: [EventCells] {
        return [.carouselEventPhotos, .attend, .eventSummary, .eventLocation, .eventTime]
    }
    
    override var nibName: String? {
        return "EventsViewController"
    }
    
    override var viewControllerTitleKey: String? {
        return "EVENTS_DETAILS_TITLE"
    }
    
    override var shouldShowUserIcon: Bool {
        return false
    }
}
