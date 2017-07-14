//
//  ObservableIntegrationTests.swift
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

class ObservableIntegrationTests: XCTestCase {
    
    final class TestViewModel {
        
        let exampleObservable = Observable<Int>(0)
        
        func increment() {
            exampleObservable.next(exampleObservable.value + 1)
        }
    }
    
    final class TestViewController {
        
        private let disposeBag = DisposeBag()
        
        var viewModel: TestViewModel?
        
        var exampleValue = 0
        
        init(viewModel: TestViewModel) {
            self.viewModel = viewModel
        }
        
        func subscribe() {
            viewModel?.exampleObservable.subscribeNext { [weak self] newValue in
                self?.exampleValue = newValue
            }
            .add(to: disposeBag)
        }
    }
    
    func testObservableUnsubscribingWithDisposeBag() {
        // GIVEN
        let viewModel = TestViewModel()
        var viewController1: TestViewController? = TestViewController(viewModel: viewModel)
        var viewController2: TestViewController? = TestViewController(viewModel: viewModel)
        
        // WHEN
        let initialSubscribersCount = viewModel.exampleObservable.subscribersCount
        viewController1?.subscribe()
        viewController1?.subscribe()
        viewController2?.subscribe()
        let subscribersCountAfterSubscribtions = viewModel.exampleObservable.subscribersCount
        viewController1 = nil   // force deinit
        let subscribersCountAfterFirstDeinit = viewModel.exampleObservable.subscribersCount
        viewController2 = nil   // force deinit
        let lastSubscribersCount = viewModel.exampleObservable.subscribersCount
        
        // THEN
        XCTAssertTrue(initialSubscribersCount == 0, "Wrong empty subscribers count")
        XCTAssertTrue(subscribersCountAfterSubscribtions == 3, "Wrong subscribers count after 3 subscribtions")
        XCTAssertTrue(subscribersCountAfterFirstDeinit == 1, "Unsubscribing from 2 subscribtions failed")
        XCTAssertTrue(lastSubscribersCount == 0, "Final subscribers count should be zero")
    }
}
