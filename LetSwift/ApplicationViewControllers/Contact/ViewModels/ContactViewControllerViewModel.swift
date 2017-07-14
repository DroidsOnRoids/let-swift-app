//
//  ContactViewControllerViewModel.swift
//  LetSwift
//
//  Created by Kinga Wilczek, Marcin Chojnacki on 31.05.2017.
//  Copyright © 2017 Droids On Roids. All rights reserved.
//
//  Licensed under the Apache License, Version 2.0 (the "License");
//  you may not use this file except in compliance with the License.
//  You may obtain a copy of the License at
//
//       http://www.apache.org/licenses/LICENSE-2.0
//
//  Unless required by applicable law or agreed to in writing, software
//  distributed under the License is distributed on an "AS IS" BASIS,
//  WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
//  See the License for the specific language governing permissions and
//  limitations under the License.
//

import Foundation
import Alamofire

final class ContactViewControllerViewModel {
    
    let pickerTitleObservable = Observable<String?>(nil)
    let pickerTopicsObservable = Observable<[String]?>(nil)
    let pickerResultObservable = Observable<Int>(-1)
    
    let nameTextObservable = Observable<String>("")
    let emailTextObservable = Observable<String>("")
    let messageTextObservable = Observable<String>("")
    
    let emailEmptyObservable = Observable<Bool>(true)

    let sendStatusObservable = Observable<Result<Any>?>(nil)
    let blockSendButton = Observable<Bool>(false)
    
    private let disposeBag = DisposeBag()
    
    private let topics = [
        (tag: "TALK", text: localized("CONTACT_TOPIC_SPEAK")),
        (tag: "REWARD", text: localized("CONTACT_TOPIC_CLAIM")),
        (tag: "SPONSOR", text: localized("CONTACT_TOPIC_PARTNER"))
    ]
    
    private var fieldsAreValid: Bool {
        let validationRules = [
            (condition: pickerResultObservable.value >= 0, error: { self.pickerResultObservable.error() }),
            (condition: !nameTextObservable.value.isEmpty, error: { self.nameTextObservable.error() }),
            (condition: isValid(email: emailTextObservable.value), error: { self.emailTextObservable.error() }),
            (condition: !messageTextObservable.value.isEmpty, error: { self.messageTextObservable.error() })
        ]
        
        validationRules
            .filter { !$0.condition }
            .forEach { $0.error() }
        
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

        blockSendButton.next(true)
        NetworkProvider.shared.sendContact(with: emailTextObservable.value,
                                           type: topics[pickerResultObservable.value].tag,
                                           name: nameTextObservable.value,
                                           message: messageTextObservable.value) { [weak self] result in
            self?.sendStatusObservable.next(result)
            self?.blockSendButton.next(false)
        }
    }
    
    private func setup() {
        pickerResultObservable.subscribeNext { [weak self] result in
            guard let weakSelf = self, result != -1 else { return }
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
