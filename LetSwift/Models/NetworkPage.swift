//
//  NetworkPage.swift
//  LetSwift
//
//  Created by Kinga Wilczek on 19.05.2017.
//  Copyright © 2017 Droids On Roids. All rights reserved.
//

import Mapper

struct NetworkPage<Element: Mappable> {

    let pageCount: Int
    let element: [Element]?

    static func from(_ JSON: NSDictionary, with key: String) -> NetworkPage<Element>? {
        guard let pageCount = JSON["page_count"] as? Int, let element = JSON[key] as? NSArray else { return nil }
        return NetworkPage(pageCount: pageCount, element: Element.from(element))
    }
}
