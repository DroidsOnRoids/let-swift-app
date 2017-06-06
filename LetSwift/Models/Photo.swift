//
//  Photo.swift
//  LetSwift
//
//  Created by Kinga Wilczek, Marcin Chojnacki on 24.04.2017.
//  Copyright © 2017 Droids On Roids. All rights reserved.
//

import Mapper

struct Photo: Mappable {

    let thumb: URL?
    let big: URL?
    
    init(map: Mapper) throws {
        thumb = map.optionalFrom("thumb")
        big = map.optionalFrom("big")
    }
}
