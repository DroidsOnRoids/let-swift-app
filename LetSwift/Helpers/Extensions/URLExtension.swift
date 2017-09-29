//
//  URLExtension.swift
//  LetSwift
//
//  Created by Marcin Chojnacki on 06.06.2017.
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

extension URL {
    private enum Constants {
        static let convertHttpToHttps = true
        static let httpPrefix = "http://"
        static let httpsPrefix = "https://"
    }
    
    static var baseServerURL: URL? {
        guard let baseURL = Bundle.main.infoDictionary?["BaseServerURL"] as? String else { return nil }
        return try? baseURL.asURL()
    }
    
    static func from(modelURL urlString: String?) -> URL? {
        guard let urlString = urlString else { return nil }
        
        if urlString.hasPrefix(Constants.httpsPrefix) {
            return try? urlString.asURL()
        } else if urlString.hasPrefix(Constants.httpPrefix) && Constants.convertHttpToHttps {
            return try? urlString.replacingOccurrences(of: Constants.httpPrefix, with: Constants.httpsPrefix).asURL()
        } else {
            return URL.baseServerURL?.appendingPathComponent(urlString)
        }
    }
}
