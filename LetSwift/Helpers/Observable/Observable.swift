//
//  Observable.swift
//  LetSwift
//
//  Created by Marcin Chojnacki, Kinga Wilczek, Michał Pyrka on 13.04.2017.
//  Copyright © 2017 Droids On Roids. All rights reserved.
//

final class Observable<Element> {
    
    typealias NextObserver = (Element) -> ()
    typealias ErrorObserver = (Swift.Error) -> ()
    typealias CompletedObserver = () -> ()
    
    private var nextObservers = [Int : NextObserver]()
    private var errorObservers = [Int : ErrorObserver]()
    private var completedObservers = [Int : CompletedObserver]()
    
    private let idAccumulator = accumulator()
    
    var value: Element {
        didSet {
            notifyObservers()
        }
    }
    
    init(_ value: Element) {
        self.value = value
    }
    
    func subscribeNext(startsWithInitialValue: Bool = false, _ onNext: @escaping NextObserver) -> DisposingObject {
        if startsWithInitialValue {
            onNext(value)
        }
        
        let id = idAccumulator()
        nextObservers[id] = onNext
        
        return DisposingObject() { [weak self] in
            self?.nextObservers.removeValue(forKey: id)
        }
    }
    
    func subscribeError(_ onError: @escaping ErrorObserver) -> DisposingObject {
        let id = idAccumulator()
        errorObservers[id] = onError
        
        return DisposingObject() { [weak self] in
            self?.errorObservers.removeValue(forKey: id)
        }
    }
    
    func subscribeCompleted(_ onCompleted: @escaping CompletedObserver) -> DisposingObject {
        let id = idAccumulator()
        completedObservers[id] = onCompleted
        
        return DisposingObject() { [weak self] in
            self?.completedObservers.removeValue(forKey: id)
        }
    }
    
    func withLatest<T, Y>(from observable: Observable<T>, combine: (Element, T) -> Y) -> Observable<Y> {
        return Observable<Y>(combine(value, observable.value))
    }
    
    func next(_ value: Element) {
        self.value = value
    }
    
    func error(_ error: Swift.Error) {
        errorObservers.forEach { $0.value(error) }
    }
    
    func complete() {
        completedObservers.forEach { $0.value() }
    }
    
    private func notifyObservers() {
        nextObservers.forEach { $0.value(value) }
    }
}
