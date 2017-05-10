//
//  EventsViewControllerViewModel.swift
//  LetSwift
//
//  Created by Kinga Wilczek, Marcin Chojnacki on 24.04.2017.
//  Copyright © 2017 Droids On Roids. All rights reserved.
//

import Foundation
import CoreLocation

final class EventsViewControllerViewModel {

    static let mockedEvent = Event(
        id: 1,
        date: Date(),
        title: "Let Swift #10",
        facebook: "1425682510795718",
        placeName: "Proza",
        placeStreet: "Wrocławski Klub Literacki\nPrzejście Garncarskie 2, Rynek Wrocław",
        placeCoordinates: CLLocationCoordinate2D(latitude: 51.11, longitude: 17.03)
    )

    enum AttendanceState {
        case notAttending
        case attending
        case loading
    }
    
    enum NotificationState {
        case notActive
        case active
    }

    private enum Constants {
        // -24 * 60 * 60
        static let minimumTimeForReminder: TimeInterval = 10.0
    }
    
    var lastEvent: Observable<Event>
    var attendanceState = Observable<AttendanceState>(AttendanceState.loading)
    var notificationState = Observable<NotificationState>(NotificationState.notActive)
    var facebookAlertObservable = Observable<String?>(nil)
    var loginScreenObservable = Observable<Void>()
    var summaryCellDidTapObservable = Observable<Void>()
    var locationCellDidTapObservable = Observable<Void>()
    var previousEventsCellDidSetObservable = Observable<Void>()
    var previousEventsViewModelObservable = Observable<PreviousEventsListCellViewModel?>(nil)
    var previousEvents = Observable<[Event]>([EventsViewControllerViewModel.mockedEvent,
                                              EventsViewControllerViewModel.mockedEvent,
                                              EventsViewControllerViewModel.mockedEvent,
                                              EventsViewControllerViewModel.mockedEvent,
                                              EventsViewControllerViewModel.mockedEvent])
    var viewWillAppearDidPerformObservable = Observable<Void>()
    var remindButtonVisibilityObservable = Observable<Bool>(true)

    var notificationManager: NotificationManager!
    
    weak var delegate: EventsViewControllerDelegate?
    
    var formattedDate: String? {
        guard let eventDate = lastEvent.value.date else { return nil }
        let formatter = DateFormatter()
        formatter.dateFormat = "dd.MM.yyyy"
        return formatter.string(from: eventDate)
    }
    
    var formattedTime: String? {
        guard let eventDate = lastEvent.value.date else { return nil }
        let formatter = DateFormatter()
        formatter.timeStyle = .short
        formatter.timeZone = TimeZone.current
        return formatter.string(from: eventDate)
    }

    var isReminderAllowed: Bool {
        guard let date = lastEvent.value.date else { return false }
        return date.addingTimeInterval(Constants.minimumTimeForReminder).compare(Date()) == .orderedDescending
    }
    
    init(lastEvent: Event, delegate: EventsViewControllerDelegate?) {
        self.lastEvent = Observable<Event>(lastEvent)
        self.delegate = delegate
        
        setup()
    }

    private func setup() {
        lastEvent.subscribe(startsWithInitialValue: true, onNext: { [unowned self] event in
            self.notificationManager = NotificationManager(date: event.date?.addingTimeInterval(Constants.minimumTimeForReminder))
            self.notificationState.next(self.notificationManager.isNotificationActive ? .active : .notActive)
        })
        
        summaryCellDidTapObservable.subscribe(onNext: { [weak self] in
            guard let weakSelf = self else { return }
            weakSelf.summaryCellTapped()
        })
        
        locationCellDidTapObservable.subscribe(onNext: { [weak self] in
            guard let weakSelf = self else { return }
            weakSelf.locationCellTapped()
        })

        previousEventsCellDidSetObservable
            .withLatest(from: previousEvents, combine: { $0.1 })
            .subscribe(startsWithInitialValue: true, onNext: { [weak self] events in
                guard let weakSelf = self else { return }
                let subviewModel = PreviousEventsListCellViewModel(previousEvenets: events, delegate: weakSelf.delegate)
                weakSelf.previousEventsViewModelObservable.next(subviewModel)
            })

        viewWillAppearDidPerformObservable.subscribe(onNext: { [weak self] in
            guard let weakSelf = self else { return }
            weakSelf.refreshAttendance()
            weakSelf.remindButtonVisibilityObservable.next(weakSelf.isReminderAllowed)
        })

        NotificationCenter
            .default
            .notification(Notification.Name.UIApplicationWillEnterForeground)
            .subscribe(onNext: { [weak self] _ in
                guard let weakSelf = self else { return }
                weakSelf.remindButtonVisibilityObservable.next(weakSelf.isReminderAllowed)
            })

        guard let time = lastEvent
                            .value
                            .date?
                            .addingTimeInterval(Constants.minimumTimeForReminder)
                            .timeIntervalSince(Date()) else { return }
        Timer.scheduledTimer(timeInterval: time, target: self, selector: #selector(eventFinished), userInfo: nil, repeats: false)
        
        FacebookManager.shared.facebookLogoutObservable.subscribe(onNext: { [unowned self] in
            self.attendanceState.next(.notAttending)
        })
    }

    @objc func eventFinished() {
        remindButtonVisibilityObservable.next(false)
    }
    
    private func checkAttendance() {
        guard let eventId = lastEvent.value.facebook, FacebookManager.shared.isLoggedIn else { return }
        
        attendanceState.next(.loading)
        FacebookManager.shared.isUserAttending(toEventId: eventId) { [unowned self] result in
            self.attendanceState.next(result == .attending ? .attending : .notAttending)
        }
    }
    
    private func attendanceToFbState(_ attendance: AttendanceState) -> FacebookEventAttendance? {
        switch attendance {
        case .attending: return .attending
        case .notAttending: return .declined
        default: return nil
        }
    }
    
    @objc func attendButtonTapped() {
        guard let eventId = lastEvent.value.facebook, attendanceState.value != .loading else { return }
        guard FacebookManager.shared.isLoggedIn else {
            loginScreenObservable.next()
            return
        }
        
        let oldAttendance = attendanceState.value
        let newAttendance: AttendanceState = oldAttendance == .attending ? .notAttending : .attending
        
        attendanceState.next(.loading)
        FacebookManager.shared.changeEvent(attendanceTo: attendanceToFbState(newAttendance)!, forId: eventId) { [unowned self] result in
            if result {
                self.attendanceState.next(newAttendance)
            } else {
                self.attendanceState.next(oldAttendance)
                self.facebookAlertObservable.next(nil)
            }
        }
    }
    
    @objc func remindButtonTapped() {
        guard let formattedTime = formattedTime, let eventTitle = lastEvent.value.title else { return }
        
        if notificationManager.isNotificationActive {
            notificationManager.cancelNotification()
        } else {
            let message = "\(localized("GENERAL_NOTIFICATION_WHERE")) \(formattedTime) \(localized("GENERAL_NOTIFICATION_ON")) \(eventTitle)"
            
            _ = notificationManager.succeededScheduleNotification(withMessage: message)
        }
        
        notificationState.next(notificationManager.isNotificationActive ? .active : .notActive)
    }
    
    private func summaryCellTapped() {
        delegate?.presentEventDetailsScreen(fromModel: lastEvent.value)
    }
    
    private func locationCellTapped() {
        guard let coordinates = lastEvent.value.placeCoordinates else { return }
        MapHelper.openMaps(withCoordinates: coordinates, name: lastEvent.value.placeName ?? lastEvent.value.title)
    }

    private func refreshAttendance() {
        if FacebookManager.shared.isLoggedIn {
            checkAttendance()
        } else {
            attendanceState.next(.notAttending)
        }
    }
}
