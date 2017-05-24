//
//  DisposingObject.swift
//  LetSwift
//
//  Created by Marcin Chojnacki, Kinga Wilczek, Michał Pyrka on 18.05.2017.
//  Copyright © 2017 Droids On Roids. All rights reserved.
//

final class DisposingObject: Disposable {
    
    private var disposeClosure: () -> ()
    private var alreadyDisposed = false
    
    init(disposeClosure: @escaping () -> ()) {
        self.disposeClosure = disposeClosure
    }
    
    deinit {
        dispose()
    }
    
    func dispose() {
        if !alreadyDisposed {
            disposeClosure()
            alreadyDisposed = true
        }
    }
    
    func add(to disposeBag: DisposeBag) {
        disposeBag.addDisposable(disposable: self)
    }
}
