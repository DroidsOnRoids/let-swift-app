//
//  Event.swift
//  LetSwift
//
//  Created by Kinga Wilczek, Marcin Chojnacki on 24.04.2017.
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

import Mapper
import CoreLocation

struct Event: Mappable {

    let id: Int
    let title: String
    let date: Date?
    let facebook: String?
    let placeName: String?
    let placeStreet: String?
    let coverImages: [Photo]
    let photos: [Photo]
    let placeCoordinates: CLLocationCoordinate2D?
    var talks: [Talk]
    
    init(map: Mapper) throws {
        try id = map.from("id")
        try title = map.from("title")
        date = map.optionalFrom("date")
        facebook = map.optionalFrom("facebook")
        placeName = map.optionalFrom("place_name")
        placeStreet = map.optionalFrom("place_street")
        coverImages = map.optionalFrom("cover_images") ?? []
        photos = map.optionalFrom("photos") ?? []
        placeCoordinates = map.optionalFrom("place_coordinates")
        talks = map.optionalFrom("talks") ?? []
    }
    
    var withoutExtendedFields: Event {
        var newEvent = self
        newEvent.talks = []
        
        return newEvent
    }
    
    static func fromDetails(_ JSON: NSDictionary) -> Event? {
        guard let event = JSON["event"] as? NSDictionary else { return nil }
        return from(event)
    }
}
