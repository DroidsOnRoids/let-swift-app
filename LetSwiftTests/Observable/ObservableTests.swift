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
    
    func testObservableNextEventWhileRetainingDisposingObject() {
        // GIVEN
        let testObservable = Observable<Int>(0)
        var disposables = [Disposable]()
        var nextCalled = 0
        
        disposables.append(testObservable.subscribeNext { newValue in
            nextCalled += newValue
        })
        
        disposables.append(testObservable.subscribeNext { newValue in
            nextCalled += newValue
        })
        
        // WHEN
        let nextValue = 3
        testObservable.next(nextValue)
        
        // THEN
        XCTAssertTrue(nextCalled == nextValue * 2, "Double next subscribtion is not working")
    }
    
    func testObservableNextEventWithoutRetainingDisposingObject() {
        // GIVEN
        let testObservable = Observable<Int>(0)
        var nextCalled = 0
        
        _ = testObservable.subscribeNext { newValue in
            nextCalled += newValue
        }
        
        _ = testObservable.subscribeNext { newValue in
            nextCalled += newValue
        }
        
        // WHEN
        testObservable.next(3)
        
        // THEN
        XCTAssertTrue(nextCalled == 0, "Subscribtion block should not be called without retaining disposing object")
    }
}
