//
//  DisposingObjectTests.swift
//  LetSwift
//
//  Created by Marcin Chojnacki on 24.05.2017.
//  Copyright © 2017 Droids On Roids. All rights reserved.
//

import XCTest
@testable import LetSwift

final class DisposingObjectTests: XCTestCase {
    
    func testDisposingObjectDisposeCalledOnlyOnce() {
        // GIVEN
        var disposeCount = 0
        var disposingObject: DisposingObject? = DisposingObject {
            disposeCount += 1
        }
        
        // WHEN
        disposingObject?.dispose()
        disposingObject = nil
        
        // THEN
        XCTAssert(disposeCount == 1, "Object has been disposed not only once")
    }
}
