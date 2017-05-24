//
//  NetworkPage.swift
//  LetSwift
//
//  Created by Kinga Wilczek on 19.05.2017.
//  Copyright © 2017 Droids On Roids. All rights reserved.
//

import Mapper

struct Page: Mappable {

    let pageCount: Int

    init(map: Mapper) throws {
        try pageCount = map.from("page_count")
    }
}
