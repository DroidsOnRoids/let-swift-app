//
//  MapHelper.swift
//  LetSwift
//
//  Created by Marcin Chojnacki on 02.05.2017.
//  Copyright © 2017 Droids On Roids. All rights reserved.
//

import CoreLocation
import MapKit

final class MapHelper {
    
    private init() {}
    
    private static var mapLaunchOptions: [String : Any] {
        if #available(iOS 10.0, *) {
            return [MKLaunchOptionsDirectionsModeKey : MKLaunchOptionsDirectionsModeDefault]
        } else {
            return [MKLaunchOptionsDirectionsModeKey : MKLaunchOptionsDirectionsModeDriving]
        }
    }
    
    static func openMaps(withCoordinates coordinates: CLLocationCoordinate2D, name: String?) {
        let mapItem = MKMapItem(placemark: MKPlacemark(coordinate: coordinates, addressDictionary:nil))
        mapItem.name = name
        mapItem.openInMaps(launchOptions: mapLaunchOptions)
    }
}
