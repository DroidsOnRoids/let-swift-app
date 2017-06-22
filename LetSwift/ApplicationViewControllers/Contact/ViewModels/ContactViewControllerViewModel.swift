//
//  ContactViewControllerViewModel.swift
//  LetSwift
//
//  Created by Kinga Wilczek, Marcin Chojnacki on 31.05.2017.
//  Copyright © 2017 Droids On Roids. All rights reserved.
//

import Foundation

final class ContactViewControllerViewModel {
    
    let pickerTitleObservable = Observable<String?>(nil)
    let pickerTopicsObservable = Observable<[String]?>(nil)
    let pickerResultObservable = Observable<Int>(-1)
    
    let nameTextObservable = Observable<String>("")
    let emailTextObservable = Observable<String>("")
    let messageTextObservable = Observable<String>("")
    
    let emailEmptyObservable = Observable<Bool>(true)
    
    private let disposeBag = DisposeBag()
    
    private let topics = [
        (tag: "SPEAKER", text: localized("CONTACT_TOPIC_SPEAK")),
        (tag: "REWARD", text: localized("CONTACT_TOPIC_CLAIM")),
        (tag: "PARTNER", text: localized("CONTACT_TOPIC_PARTNER"))
    ]
    
    private var fieldsAreValid: Bool {
        let validationRules = [
            (pickerResultObservable.value >= 0, { self.pickerResultObservable.error() }),
            (!nameTextObservable.value.isEmpty, { self.nameTextObservable.error() }),
            (isValid(email: emailTextObservable.value), { self.emailTextObservable.error() }),
            (!messageTextObservable.value.isEmpty, { self.messageTextObservable.error() })
        ]
        
        validationRules
            .filter { isValid, _ in !isValid }
            .forEach { _, errorClosure in
            errorClosure()
        }
        
        return !validationRules.contains(where: { isValid, _ in !isValid })
    }
    
    init() {
        setup()
    }
    
    @objc func pickerTapped() {
        pickerTopicsObservable.next(topics.map { $0.text })
    }
    
    @objc func sendTapped() {
        guard fieldsAreValid else { return }
        // TODO: Send message
    }
    
    private func setup() {
        pickerResultObservable.subscribeNext { [weak self] result in
            guard let weakSelf = self else { return }
            let newTitle = localized("CONTACT_TOPIC") + " " + weakSelf.topics[result].text.lowercased()
            weakSelf.pickerTitleObservable.next(newTitle)
        }
        .add(to: disposeBag)
        
        emailTextObservable.subscribeNext { [weak self] text in
            self?.emailEmptyObservable.next(text.isEmpty)
        }
        .add(to: disposeBag)
    }
    
    private func isValid(email: String) -> Bool {
        let emailRegex = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        return NSPredicate(format: "SELF MATCHES %@", emailRegex).evaluate(with: email)
    }
}
