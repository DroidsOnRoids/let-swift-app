//
//  LocationMapperExtension.swift
//  LetSwift
//
//  Created by Marcin Chojnacki on 19.05.2017.
//  Copyright © 2017 Droids On Roids. All rights reserved.
//

import CoreLocation
import Mapper

extension CLLocationCoordinate2D: Convertible {
    public static func fromMap(_ value: Any) throws -> CLLocationCoordinate2D {
        guard let location = value as? NSDictionary,
            let latitude = location["latitude"] as? Double,
            let longitude = location["longitude"] as? Double else {
            throw MapperError.convertibleError(value: value, type: [String: Double].self)
        }
        
        return CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
    }
}
