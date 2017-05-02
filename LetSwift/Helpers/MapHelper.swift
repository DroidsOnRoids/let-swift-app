//
//  MapHelper.swift
//  LetSwift
//
//  Created by Marcin Chojnacki on 02.05.2017.
//  Copyright © 2017 Droids On Roids. All rights reserved.
//

import CoreLocation
import MapKit

class MapHelper {
    
    private enum Constants {
        static let regionDistance: CLLocationDistance = 1000.0
    }
    
    private init() {}
    
    static func openMaps(withCoordinates coordinates: CLLocationCoordinate2D, name: String?) {
        let regionSpan = MKCoordinateRegionMakeWithDistance(coordinates, Constants.regionDistance, Constants.regionDistance)
        let options = [
            MKLaunchOptionsMapCenterKey: NSValue(mkCoordinate: regionSpan.center),
            MKLaunchOptionsMapSpanKey: NSValue(mkCoordinateSpan: regionSpan.span)
        ]
        
        let placemark = MKPlacemark(coordinate: coordinates, addressDictionary: nil)
        let mapItem = MKMapItem(placemark: placemark)
        
        mapItem.name = name
        mapItem.openInMaps(launchOptions: options)
    }
}
