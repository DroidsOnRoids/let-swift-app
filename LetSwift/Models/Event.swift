//
//  Event.swift
//  LetSwift
//
//  Created by Kinga Wilczek, Marcin Chojnacki on 24.04.2017.
//  Copyright © 2017 Droids On Roids. All rights reserved.
//

import Mapper
import CoreLocation

struct Event: Mappable {

    let id: Int
    let title: String
    let date: Date?
    let facebook: String?
    let placeName: String?
    let placeStreet: String?
    let coverImages: [URL]?
    let photos: [Photo]?
    let placeCoordinates: CLLocationCoordinate2D?
    let talks: [Talk]?
    
    init(map: Mapper) throws {
        try id = map.from("id")
        try title = map.from("title")
        date = map.optionalFrom("date")
        facebook = map.optionalFrom("facebook")
        placeName = map.optionalFrom("place_name")
        placeStreet = map.optionalFrom("place_street")
        coverImages = map.optionalFrom("cover_images")
        photos = map.optionalFrom("photos")
        placeCoordinates = map.optionalFrom("place_coordinates")
        talks = map.optionalFrom("talks")
    }
    
    static func fromDetails(_ JSON: NSDictionary) -> Event? {
        guard let event = JSON["event"] as? NSDictionary else { return nil }
        return from(event)
    }
}
