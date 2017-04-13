//
//  OptionalAssigment.swift
//  LetSwift
//
//  Created by Kinga Wilczek on 13.04.2017.
//  Copyright © 2017 Droids On Roids. All rights reserved.
//

import Foundation

precedencegroup OptionalAssignment {
    associativity: right
}

infix operator ?= : OptionalAssignment

func ?= <T: Any> ( left: inout T, right: T?) {
    if let right = right {
        left = right
    }
}
