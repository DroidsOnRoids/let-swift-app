//
//  Observable.swift
//  LetSwift
//
//  Created by Marcin Chojnacki, Kinga Wilczek, Michał Pyrka on 13.04.2017.
//  Copyright © 2017 Droids On Roids. All rights reserved.
//

final class Observable<Element> {

    typealias NextObserver = (Element) -> ()
    typealias ErrorObserver = (Error?) -> ()
    typealias CompletedObserver = () -> ()
    typealias Predicate = (Element) -> Bool
    
    private var nextObservers = [Int : NextObserver]()
    private var errorObservers = [Int : ErrorObserver]()
    private var completedObservers = [Int : CompletedObserver]()
    
    private let idAccumulator = accumulator()

    private var predicate: Predicate?
    
    var value: Element {
        didSet {
            notifyObservers()
        }
    }
    
    var subscribersCount: Int {
        return nextObservers.count + errorObservers.count + completedObservers.count
    }

    convenience init(_ value: Element, predicate: @escaping Predicate) {
        self.init(value)

        self.predicate = predicate
    }
    
    init(_ value: Element) {
        self.value = value
    }
    
    func subscribeNext(startsWithInitialValue: Bool = false, _ onNext: @escaping NextObserver) -> DisposingObject {
        if startsWithInitialValue, predicate == nil || predicate?(value) ?? false {
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
    
    func bindNext(to target: Observable<Element>) -> DisposingObject {
        return subscribeNext { event in
            target.next(event)
        }
    }
    
    func withLatest<T, Y>(from observable: Observable<T>, combine: (Element, T) -> Y) -> Observable<Y> {
        return Observable<Y>(combine(value, observable.value))
    }

    func filter(_ predicate: @escaping (Element) -> Bool) -> Observable<Element> {
        return Observable<Element>(value, predicate: predicate)
    }
    
    func next(_ value: Element) {
        self.value = value
    }
    
    func error(_ error: Error? = nil) {
        errorObservers.forEach { $0.value(error) }
    }
    
    func complete() {
        completedObservers.forEach { $0.value() }
    }
    
    private func notifyObservers() {
        guard predicate == nil || predicate?(value) ?? false else { return }

        nextObservers.forEach { $0.value(value) }
    }
}

extension Observable where Element: Equatable {
    func nextDistinct(_ value: Element) {
        if self.value != value {
            self.value = value
        }
    }
}
