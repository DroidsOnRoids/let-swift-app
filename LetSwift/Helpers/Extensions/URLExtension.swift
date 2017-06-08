//
//  URLExtension.swift
//  LetSwift
//
//  Created by Marcin Chojnacki on 06.06.2017.
//  Copyright © 2017 Droids On Roids. All rights reserved.
//

import Foundation

extension URL {
    static var baseServerURL: URL? {
        guard let baseURL = Bundle.main.infoDictionary?["BaseServerURL"] as? String else { return nil }
        return try? baseURL.asURL()
    }
}
