//
//  ArrayExtension.swift
//  LetSwift
//
//  Created by Marcin Chojnacki on 18.04.2017.
//  Copyright © 2017 Droids On Roids. All rights reserved.
//

import Foundation

extension Array {
    func randomElement() -> Element {
        return self[Int(arc4random_uniform(UInt32(self.count)))]
    }
    
    subscript(safe safe: Index) -> Element? {
        return indices.contains(safe) ? self[safe] : nil
    }
}
