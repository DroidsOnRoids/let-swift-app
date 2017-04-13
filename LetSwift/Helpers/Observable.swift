//
//  Observable.swift
//  LetSwift
//
//  Created by Marcin Chojnacki on 13.04.2017.
//  Copyright © 2017 Droids On Roids. All rights reserved.
//

struct Observable<Element> {
    
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
    
    mutating func subscribe(onNext: @escaping NextObserver) {
        nextObservers.append(onNext)
    }
    
    mutating func subscribe(onError: @escaping ErrorObserver) {
        errorObservers.append(onError)
    }
    
    mutating func subscribe(onCompleted: @escaping CompletedObserver) {
        completedObservers.append(onCompleted)
    }
    
    mutating func next(_ value: Element) {
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
