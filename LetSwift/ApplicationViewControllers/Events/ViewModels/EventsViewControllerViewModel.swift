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
        coverPhotos: ["PhotoMock", "PhotoMock", "PhotoMock"],
        placeCoordinates: CLLocationCoordinate2D(latitude: 51.11, longitude: 17.03)
    )

    enum AttendanceState {
        case notAttending
        case attending
        case loading
    }
    
    enum NotificationState {
        case notVisible
        case notActive
        case active
    }

    private enum Constants {
        // -24 * 60 * 60
        static let minimumTimeForReminder: TimeInterval = 10.0
    }
    
    var lastEventObservable: Observable<Event>
    var attendanceStateObservable = Observable<AttendanceState>(AttendanceState.loading)
    var notificationStateObservable = Observable<NotificationState>(NotificationState.notActive)
    var facebookAlertObservable = Observable<String?>(nil)
    var loginScreenObservable = Observable<Void>()
    var summaryCellDidTapObservable = Observable<Void>()
    var locationCellDidTapObservable = Observable<Void>()
    var previousEventsCellDidSetObservable = Observable<Void>()
    var previousEventsViewModelObservable = Observable<PreviousEventsListCellViewModel?>(nil)
    var previousEventsObservable = Observable<[Event]>([EventsViewControllerViewModel.mockedEvent,
                                              EventsViewControllerViewModel.mockedEvent,
                                              EventsViewControllerViewModel.mockedEvent,
                                              EventsViewControllerViewModel.mockedEvent,
                                              EventsViewControllerViewModel.mockedEvent])
    var carouselCellDidSetObservable = Observable<Void>()
    var carouselEventPhotosViewModelObservable = Observable<CarouselEventPhotosCellViewModel?>(nil)

    var notificationManager: NotificationManager!
    
    weak var delegate: EventsViewControllerDelegate?
    
    var formattedDate: String? {
        guard let eventDate = lastEventObservable.value.date else { return nil }
        let formatter = DateFormatter()
        formatter.dateFormat = "dd.MM.yyyy"
        return formatter.string(from: eventDate)
    }
    
    var formattedTime: String? {
        guard let eventDate = lastEventObservable.value.date else { return nil }
        let formatter = DateFormatter()
        formatter.timeStyle = .short
        formatter.timeZone = TimeZone.current
        return formatter.string(from: eventDate)
    }

    var isReminderAllowed: Bool {
        guard let date = lastEventObservable.value.date else { return false }
        return date.addingTimeInterval(Constants.minimumTimeForReminder).compare(Date()) == .orderedDescending
    }
    
    init(lastEvent: Event, delegate: EventsViewControllerDelegate?) {
        self.lastEventObservable = Observable<Event>(lastEvent)
        self.delegate = delegate
        
        setup()
    }

    private func setup() {
        lastEventObservable.subscribe(startsWithInitialValue: true, onNext: { [weak self] event in
            guard let weakSelf = self else { return }
            
            weakSelf.checkAttendance()
            
            weakSelf.notificationManager = NotificationManager(date: event.date?.addingTimeInterval(Constants.minimumTimeForReminder))
            
            if weakSelf.isReminderAllowed {
                weakSelf.notificationStateObservable.next(weakSelf.notificationManager.isNotificationActive ? .active : .notActive)
            } else {
                weakSelf.notificationStateObservable.next(.notVisible)
            }
        })
        
        summaryCellDidTapObservable.subscribe(onNext: { [weak self] in
            self?.summaryCellTapped()
        })
        
        locationCellDidTapObservable.subscribe(onNext: { [weak self] in
            self?.locationCellTapped()
        })

        previousEventsCellDidSetObservable
            .withLatest(from: previousEventsObservable, combine: { event in event.1 })
            .subscribe(startsWithInitialValue: true, onNext: { [weak self] events in
                guard let weakSelf = self else { return }
                let subviewModel = PreviousEventsListCellViewModel(previousEvenets: events, delegate: weakSelf.delegate)
                weakSelf.previousEventsViewModelObservable.next(subviewModel)
            })

        carouselCellDidSetObservable
            .withLatest(from: lastEventObservable, combine: { event in event.1.coverPhotos })
            .subscribe(startsWithInitialValue: true, onNext: { [weak self] photos in
                let subviewModel = CarouselEventPhotosCellViewModel(photos: photos)
                self?.carouselEventPhotosViewModelObservable.next(subviewModel)
            })

        NotificationCenter
            .default
            .notification(Notification.Name.UIApplicationWillEnterForeground)
            .subscribe(onNext: { [weak self] _ in
                guard let weakSelf = self else { return }
                if weakSelf.isReminderAllowed {
                    weakSelf.notificationStateObservable.next(.notVisible)
                }
            })

        guard let time = lastEventObservable
                            .value
                            .date?
                            .addingTimeInterval(Constants.minimumTimeForReminder)
                            .timeIntervalSince(Date()) else { return }
        Timer.scheduledTimer(timeInterval: time, target: self, selector: #selector(eventFinished), userInfo: nil, repeats: false)
        
        FacebookManager.shared.facebookLogoutObservable.subscribe(onNext: { [weak self] in
            self?.attendanceStateObservable.next(.notAttending)
        })
    }

    @objc func eventFinished() {
        notificationStateObservable.next(.notVisible)
    }
    
    private func checkAttendance() {
        guard let eventId = lastEventObservable.value.facebook else { return }
        
        attendanceStateObservable.next(.loading)
        FacebookManager.shared.isUserAttending(toEventId: eventId) { [weak self] result in
            self?.attendanceStateObservable.next(result == .attending ? .attending : .notAttending)
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
        guard let eventId = lastEventObservable.value.facebook, attendanceStateObservable.value != .loading else { return }
        guard FacebookManager.shared.isLoggedIn else {
            loginScreenObservable.next()
            return
        }
        
        let oldAttendance = attendanceStateObservable.value
        let newAttendance: AttendanceState = oldAttendance == .attending ? .notAttending : .attending
        
        attendanceStateObservable.next(.loading)
        FacebookManager.shared.changeEvent(attendanceTo: attendanceToFbState(newAttendance)!, forId: eventId) { [weak self] result in
            if result {
                self?.attendanceStateObservable.next(newAttendance)
            } else {
                self?.attendanceStateObservable.next(oldAttendance)
                self?.facebookAlertObservable.next(nil)
            }
        }
    }
    
    @objc func remindButtonTapped() {
        guard let formattedTime = formattedTime, let eventTitle = lastEventObservable.value.title else { return }
        
        if notificationManager.isNotificationActive {
            notificationManager.cancelNotification()
        } else {
            let message = "\(localized("GENERAL_NOTIFICATION_WHERE")) \(formattedTime) \(localized("GENERAL_NOTIFICATION_ON")) \(eventTitle)"
            
            _ = notificationManager.succeededScheduleNotification(withMessage: message)
        }
        
        notificationStateObservable.next(notificationManager.isNotificationActive ? .active : .notActive)
    }
    
    private func summaryCellTapped() {
        delegate?.presentEventDetailsScreen(fromViewModel: self)
    }
    
    private func locationCellTapped() {
        guard let coordinates = lastEventObservable.value.placeCoordinates else { return }
        MapHelper.openMaps(withCoordinates: coordinates, name: lastEventObservable.value.placeName ?? lastEventObservable.value.title)
    }
}
