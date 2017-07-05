//
//  DateExtension.swift
//  LetSwift
//
//  Created by Kinga Wilczek on 16.05.2017.
//  Copyright © 2017 Droids On Roids. All rights reserved.
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
