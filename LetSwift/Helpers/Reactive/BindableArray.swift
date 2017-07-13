//
//  BindabableArray.swift
//  LetSwift
//
//  Created by Kinga Wilczek on 04.05.2017.
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

final class BindableArray<T> {

    var values: [T]
    private var events = [([T], Bool) -> ()]()

    init(_ values: [T]) {
        self.values = values
    }

    func bind(to event: @escaping ([T]) -> () ) {
        let convertedFunc: ([T], Bool) -> () = { passedValues, _ in
            event(passedValues)
        }
        events.append(convertedFunc)
        notify(event: convertedFunc)
    }

    func bind(to event: @escaping ([T], Bool) -> ()) {
        events.append(event)
        notify(event: event)
    }

    func append(_ element: T, updated: Bool = true) {
        values.append(element)
        events.forEach { $0(values, updated) }
    }

    func append(_ element: [T], updated: Bool = true) {
        values.append(contentsOf: element)
        events.forEach { $0(values, updated) }
    }

    func insert(_ element: T, at index: Int, updated: Bool = true) {
        values.insert(element, at: index)
        events.forEach { $0(values, updated) }
    }

    func remove(at index: Int, updated: Bool = true) {
        values.remove(at: index)
        events.forEach { $0(values, updated) }
    }

    func remove(updated: Bool = true, where condition: (T) -> Bool) {
        values = values.filter { !condition($0) }
        events.forEach { $0(values, updated) }
    }

    private func notify(event: ([T], Bool) -> ()) {
        values.forEach { _ in
            event(values, true)
        }
    }
}
