//
//  Talk.swift
//  LetSwift
//
//  Created by Kinga Wilczek, Marcin Chojnacki on 24.04.2017.
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

import Mapper

struct Talk: Mappable {

    let id: Int
    let title: String
    let description: String?
    let tags: [String]?
    
    // MARK: Extended fields
    var speaker: Speaker?
    var event: Event?
    
    init(map: Mapper) throws {
        try id = map.from("id")
        try title = map.from("title")
        description = map.optionalFrom("description")
        tags = map.optionalFrom("tags")
        
        // MARK: Extended fields
        speaker = map.optionalFrom("speaker")
        event = map.optionalFrom("event")
    }
}
