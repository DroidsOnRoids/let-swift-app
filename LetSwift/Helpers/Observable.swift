//
//  Observable.swift
//  LetSwift
//
//  Created by Marcin Chojnacki, Kinga Wilczek on 13.04.2017.
//  Copyright © 2017 Droids On Roids. All rights reserved.
//

final class Observable<Element> {
    
    typealias NextObserver = (Element) -> ()
    typealias ErrorObserver = (Swift.Error) -> ()
    typealias CompletedObserver = () -> ()
    
    private var nextObservers = [NextObserver]()
    private var errorObservers = [ErrorObserver]()
    private var completedObservers = [CompletedObserver]()
    
    var value: Element {
        didSet {
            notifyObservers()
        }
    }
    
    init(_ value: Element) {
        self.value = value
    }

    func subscribe(startsWithInitialValue: Bool = false, onNext: @escaping NextObserver) {
        if startsWithInitialValue {
            onNext(value)
        }
        nextObservers.append(onNext)
    }

    func withLatest<T, Y>(from observable: Observable<T>, combine: (Element, T) -> (Y)) -> Observable<Y> {
        return Observable<Y>(combine(value, observable.value))
    }
    
    func subscribe(onError: @escaping ErrorObserver) {
        errorObservers.append(onError)
    }
    
    func subscribe(onCompleted: @escaping CompletedObserver) {
        completedObservers.append(onCompleted)
    }
    
    func next(_ value: Element) {
        self.value = value
    }
    
    func error(_ error: Swift.Error) {
        errorObservers.forEach { $0(error) }
    }
    
    func complete() {
        completedObservers.forEach { $0() }
    }
    
    private func notifyObservers() {
        nextObservers.forEach { $0(value) }
    }
}
