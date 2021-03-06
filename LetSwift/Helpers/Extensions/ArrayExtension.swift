//
//  ArrayExtension.swift
//  LetSwift
//
//  Created by Marcin Chojnacki, Kinga Wilczek on 18.04.2017.
//  Copyright © 2017 Droids On Roids. All rights reserved.
//
//  Licensed under the Apache License, Version 2.0 (the "License");
//  you may not use this file except in compliance with the License.
//  You may obtain a copy of the License at
//
//       http://www.apache.org/licenses/LICENSE-2.0
//
//  Unless required by applicable law or agreed to in writing, software
//  distributed under the License is distributed on an "AS IS" BASIS,
//  WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
//  See the License for the specific language governing permissions and
//  limitations under the License.
//

import Foundation

extension Array {
    func randomElement() -> Element {
        return self[Int(arc4random_uniform(UInt32(self.count)))]
    }

    var bindable: BindableArray<Element> {
        return BindableArray<Element>(self)
    }
    
    var tail: Array {
        return Array(self.dropFirst())
    }
    
    subscript(safe safe: Index) -> Element? {
        return indices.contains(safe) ? self[safe] : nil
    }
}
