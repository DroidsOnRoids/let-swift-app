//
//  Accumulator.swift
//  LetSwift
//
//  Created by Marcin Chojnacki, Kinga Wilczek, Michał Pyrka on 18.05.2017.
//  Copyright © 2017 Droids On Roids. All rights reserved.
//

func accumulator(initial: Int = 0, incrementBy: Int = 1) -> () -> Int {
    var value = initial
    func accum() -> Int {
        value += incrementBy
        return value
    }
    return accum
}
