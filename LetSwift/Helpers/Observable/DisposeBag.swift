//
//  DisposeBag.swift
//  LetSwift
//
//  Created by Marcin Chojnacki, Kinga Wilczek, Michał Pyrka on 18.05.2017.
//  Copyright © 2017 Droids On Roids. All rights reserved.
//

final class DisposeBag {
    
    private var disposables = [Disposable]()
    
    func addDisposableObject(disposableObject: DisposingObject) {
        disposables.append(disposableObject)
    }
    
    deinit {
        disposables.forEach { $0.dispose() }
    }
}
