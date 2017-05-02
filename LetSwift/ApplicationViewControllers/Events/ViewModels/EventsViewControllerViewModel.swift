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
        case notLoggedIn
        case notAttending
        case attending
        case loading
    }
    
    enum NotificationState {
        case notActive
        case active
    }
    
    var lastEvent: Observable<Event>
    var attendanceState = Observable<AttendanceState>(AttendanceState.loading)
    var notificationState = Observable<NotificationState>(NotificationState.notActive)
    
    var formattedDate: String? {
        guard let eventDate = lastEvent.value.date else { return nil }
        let formatter = DateFormatter()
        formatter.dateFormat = "dd.MM.yyyy"
        return formatter.string(from: eventDate)
    }
    
    var formattedTime: String? {
        guard let eventDate = lastEvent.value.date else { return nil }
        let formatter = DateFormatter()
        formatter.dateFormat = "HH:mm"
        return formatter.string(from: eventDate) + " CEST"
    }
    
    init(lastEvent: Event) {
        self.lastEvent = Observable<Event>(lastEvent)
    }
    
    func refreshAttendance() {
        if FacebookManager.shared.isLoggedIn {
            checkAttendance()
        } else {
            attendanceState.next(.notLoggedIn)
        }
    }
    
    private func checkAttendance() {
        guard FacebookManager.shared.isLoggedIn, let eventId = lastEvent.value.facebook else { return }
        
        FacebookManager.shared.isUserAttending(toEventId: eventId) { [unowned self] result in
            self.attendanceState.next(result ? .attending : .notAttending)
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
        guard FacebookManager.shared.isLoggedIn else { return }
        guard ![.notLoggedIn, .loading].contains(attendanceState.value) else { return }
        guard let eventId = lastEvent.value.facebook else { return }
        
        let oldAttendance = attendanceState.value
        let newAttendance: AttendanceState = oldAttendance == .attending ? .notAttending : .attending
        attendanceState.next(.loading)
        
        FacebookManager.shared.changeEvent(attendanceTo: attendanceToFbState(newAttendance)!, forId: eventId) { result in
            self.attendanceState.next(result ? newAttendance : oldAttendance)
        }
    }
    
    @objc func remindButtonTapped() {
        notificationState.next(notificationState.value == .active ? .notActive : .active)
    }
    
    func summaryCellTapped() {
        // TODO: implement
    }
    
    func locationCellTapped() {
        guard let coordinates = lastEvent.value.placeCoordinates else { return }
        MapHelper.openMaps(withCoordinates: coordinates, name: lastEvent.value.placeName ?? lastEvent.value.title)
    }
}
