//
//  DateMapperExtension.swift
//  LetSwift
//
//  Created by Marcin Chojnacki on 19.05.2017.
//  Copyright © 2017 Droids On Roids. All rights reserved.
//

import Mapper

extension Date: Convertible {
    private static var apiDateFormatter: DateFormatter {
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "en_US_POSIX")
        formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZZZZ"
        return formatter
    }
    
    public static func fromMap(_ value: Any) throws -> Date {
        guard let dateString = value as? String,
            let formattedDate = apiDateFormatter.date(from: dateString) else {
            throw MapperError.convertibleError(value: value, type: String.self)
        }
        
        return formattedDate
    }
}
