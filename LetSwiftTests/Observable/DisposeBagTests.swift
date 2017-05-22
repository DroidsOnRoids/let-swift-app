//
//  DisposeBagTests.swift
//  LetSwift
//
//  Created by Marcin Chojnacki on 22.05.2017.
//  Copyright © 2017 Droids On Roids. All rights reserved.
//

import XCTest
@testable import LetSwift

final class DisposeBagTests: XCTestCase {
    
    final class SimpleDisposable: Disposable {
        
        static var livingObjects = 0
        
        init() {
            SimpleDisposable.livingObjects += 1
        }
        
        func dispose() {
            SimpleDisposable.livingObjects -= 1
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
        let livingObjects = SimpleDisposable.livingObjects
        
        // THEN
        XCTAssertTrue(livingObjects == 0, "DisposeBag failed to dispose objects")
    }
}
