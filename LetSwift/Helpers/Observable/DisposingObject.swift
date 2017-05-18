//
//  DisposingObject.swift
//  LetSwift
//
//  Created by Marcin Chojnacki, Kinga Wilczek, Michał Pyrka on 18.05.2017.
//  Copyright © 2017 Droids On Roids. All rights reserved.
//

final class DisposingObject: Disposable {
    
    private var disposeClosure: () -> ()
    
    init(disposeClosure: @escaping () -> ()) {
        self.disposeClosure = disposeClosure
    }
    
    func dispose() {
        disposeClosure()
    }
    
    func add(to disposeBag: DisposeBag) {
        disposeBag.addDisposableObject(disposableObject: self)
    }
}
