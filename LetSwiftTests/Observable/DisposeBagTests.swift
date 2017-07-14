//
//  DisposeBagTests.swift
//  LetSwift
//
//  Created by Marcin Chojnacki on 22.05.2017.
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

import XCTest
@testable import LetSwift

final class DisposeBagTests: XCTestCase {
    
    final class SimpleDisposable: Disposable {
        
        static var allocatedObjects = 0
        static var disposedObjects = 0
        
        init() {
            SimpleDisposable.allocatedObjects += 1
        }
        
        func dispose() {
            SimpleDisposable.disposedObjects += 1
        }
    }
    
    func testDisposeBagDisposalAfterDeinit() {
        // GIVEN
        var disposeBag: DisposeBag? = DisposeBag()
        let disposable1 = SimpleDisposable()
        let disposable2 = SimpleDisposable()
        let disposable3 = SimpleDisposable()
        
        // WHEN
        disposeBag?.addDisposable(disposable: disposable1)
        disposeBag?.addDisposable(disposable: disposable2)
        disposeBag?.addDisposable(disposable: disposable3)
        disposeBag = nil
        let allDisposed = SimpleDisposable.allocatedObjects == SimpleDisposable.disposedObjects
        
        // THEN
        XCTAssertTrue(allDisposed, "Not every object was disposed")
    }
}
