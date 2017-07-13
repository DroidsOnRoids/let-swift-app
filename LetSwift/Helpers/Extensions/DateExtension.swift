//
//  DateExtension.swift
//  LetSwift
//
//  Created by Kinga Wilczek on 16.05.2017.
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

import Foundation

extension Date {
    var isOutdated: Bool {
        return compare(Date()) == .orderedAscending
    }
    
    var stringDateValue: String {
        let formatter = DateFormatter()
        formatter.dateFormat = "dd.MM.yyyy"
        
        return formatter.string(from: self)
    }
    
    var stringTimeValue: String {
        let formatter = DateFormatter()
        formatter.timeStyle = .short
        formatter.timeZone = .current
        
        return formatter.string(from: self)
    }
}
