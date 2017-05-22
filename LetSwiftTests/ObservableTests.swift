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
    
    final class SimpleDisposable: Disposable {
        
        static var livingObjects = 0
        
        init() {
            SimpleDisposable.livingObjects += 1
        }
        
        func dispose() {
            SimpleDisposable.livingObjects -= 1
        }
    }
    
    enum SampleError: Error {
        case sample
    }
    
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
    
    func testObservable() {
        // GIVEN
        let testObservable = Observable<Int>(0)
        var nextCalled = 0
        var errorCalled = false
        var completedCalled = false
        
        _ = testObservable.subscribeNext { newValue in
            nextCalled += newValue
        }
        
        _ = testObservable.subscribeNext { newValue in
            nextCalled += newValue
        }
        
        _ = testObservable.subscribeError { newValue in
            errorCalled = true
        }
        
        _ = testObservable.subscribeCompleted {
            completedCalled = true
        }
        
        // WHEN
        let nextValue = 3
        testObservable.next(nextValue)
        testObservable.error(SampleError.sample)
        testObservable.complete()
        
        // THEN
        XCTAssertTrue(nextCalled == nextValue * 2, "Double next subscribtion is not working")
        XCTAssertTrue(errorCalled, "Error subscribtion was not called")
        XCTAssertTrue(completedCalled, "Completed subscribtion was not called")
    }
    
    func testDisposeBag() {
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
        let livingObjects = SimpleDisposable.livingObjects
        
        // THEN
        XCTAssertTrue(livingObjects == 0, "DisposeBag failed to dispose objects")
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
