//
//  NetworkResponse.swift
//  LetSwift
//
//  Created by Kinga Wilczek on 19.05.2017.
//  Copyright © 2017 Droids On Roids. All rights reserved.
//

enum NetworkReponse<Element> {
    case error(Error)
    case success(Element)
}
