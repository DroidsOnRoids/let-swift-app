//
//  Talk.swift
//  LetSwift
//
//  Created by Kinga Wilczek, Marcin Chojnacki on 24.04.2017.
//  Copyright © 2017 Droids On Roids. All rights reserved.
//

import Mapper

struct Talk: Mappable {

    let id: Int
    let title: String
    let description: String?
    let tags: [String]?
    let speaker: Speaker?
    
    init(map: Mapper) throws {
        try id = map.from("id")
        try title = map.from("title")
        description = map.optionalFrom("description")
        tags = map.optionalFrom("tags")
        speaker = map.optionalFrom("speaker")
    }
}
