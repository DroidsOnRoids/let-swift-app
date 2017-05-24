//
//  NetworkPage.swift
//  LetSwift
//
//  Created by Kinga Wilczek on 22.05.2017.
//  Copyright © 2017 Droids On Roids. All rights reserved.
//

import Foundation

struct NetworkPage<Element> {

    let page: Page
    let elements: [Element]

    init(page: Page, elements: [Element]) {
        self.page = page
        self.elements = elements
    }
}
