//
//  LocationMapperExtension.swift
//  LetSwift
//
//  Created by Marcin Chojnacki on 19.05.2017.
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
