//
//  MockLoader.swift
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

import Foundation

struct MockLoader {

    static func loadMock<T>(forPath path: String) -> T? {
        guard let file = Bundle.main.url(forResource: path, withExtension: "json"),
            let data = try? Data(contentsOf: file),
            let json = try? JSONSerialization.jsonObject(with: data, options: []) else { return nil }

        return json as? T
    }
    
    static var eventDetailsMock: NSDictionary? {
        guard let result: NSDictionary? = loadMock(forPath: "event_details") else { return nil }
        return result
    }

    static var speakersMock: NSArray? {
        guard let result: NSArray? = loadMock(forPath: "speakers") else { return nil }
        return result
    }
}
