//
//  ContactViewControllerViewModel.swift
//  LetSwift
//
//  Created by Kinga Wilczek, Marcin Chojnacki on 31.05.2017.
//  Copyright © 2017 Droids On Roids. All rights reserved.
//

import Foundation

final class ContactViewControllerViewModel {
    
    private let topics = [
        (tag: "SPEAKER", text: localized("CONTACT_TOPIC_SPEAK")),
        (tag: "REWARD", text: localized("CONTACT_TOPIC_CLAIM")),
        (tag: "PARTNER", text: localized("CONTACT_TOPIC_PARTNER"))
    ]
    
    let disposeBag = DisposeBag()
    
    let pickerTitleObservable = Observable<String?>(nil)
    let pickerTopicsObservable = Observable<[String]?>(nil)
    let pickerResultObservable = Observable<Int>(-1)
    
    init() {
        setup()
    }
    
    private func setup() {
        pickerResultObservable.subscribeNext { [weak self] result in
            self?.pickerTitleObservable.next(self?.topics[result].text)
        }
        .add(to: disposeBag)
    }
    
    @objc func pickerTapped() {
        pickerTopicsObservable.next(topics.map { $0.text })
    }
}
