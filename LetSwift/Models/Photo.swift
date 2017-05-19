//
//  Photo.swift
//  LetSwift
//
//  Created by Kinga Wilczek, Marcin Chojnacki on 24.04.2017.
//  Copyright © 2017 Droids On Roids. All rights reserved.
//

import Mapper

struct Photo: Mappable {

    let thumbnail: URL?
    let full: URL?
    
    init(map: Mapper) throws {
        thumbnail = map.optionalFrom("thumbnail")
        full = map.optionalFrom("full")
    }
}
