//
//  Event.swift
//  LetSwift
//
//  Created by Kinga Wilczek on 24.04.2017.
//  Copyright © 2017 Droids On Roids. All rights reserved.
//

import Foundation
import CoreLocation

class Event {

    var id: Int?

    var date: Date?

    var title: String?
    var facebook: String?
    var placeName: String?
    var placeStreet: String?

    var coverPhotos: [String] = []
    var photos: [Photo] = []
    var talks: [Talk] = []

    var placeCoordinates: CLLocationCoordinate2D?
}
