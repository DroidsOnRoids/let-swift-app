//
//  ObservableTests.swift
//  LetSwift
//
//  Created by Marcin Chojnacki on 22.05.2017.
//  Copyright © 2017 Droids On Roids. All rights reserved.
//

import XCTest
@testable import LetSwift

final class ObservableTests: XCTestCase {
    
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
            }.add(to: disposeBag)
        }
    }
    
    func testSimpleUnsubscribing() {
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
