//
//  Event.swift
//  LetSwift
//
//  Created by Kinga Wilczek on 24.04.2017.
//  Copyright © 2017 Droids On Roids. All rights reserved.
//

import Foundation
import CoreLocation

struct Event {

    let id: Int?
    let date: Date?
    let title: String?
    let facebook: String?
    let placeName: String?
    let placeStreet: String?
    let coverPhotos = [String]()
    let photos = [Photo]()
    let talks = [Talk]()
    let placeCoordinates: CLLocationCoordinate2D?
}
