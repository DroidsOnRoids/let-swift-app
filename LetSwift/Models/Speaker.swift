//
//  Speaker.swift
//  LetSwift
//
//  Created by Kinga Wilczek, Marcin Chojnacki on 16.05.2017.
//  Copyright © 2017 Droids On Roids. All rights reserved.
//

import Mapper

struct Speaker: Mappable {

    let id: Int
    let avatar: Photo?
    let name: String
    let job: String?
    let bio: String?
    
    init(map: Mapper) throws {
        try id = map.from("id")
        avatar = map.optionalFrom("avatar")
        try name = map.from("name")
        job = map.optionalFrom("job")
        bio = map.optionalFrom("bio")
    }
}
