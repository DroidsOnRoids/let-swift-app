//
//  ContactViewController.swift
//  LetSwift
//
//  Created by Marcin Chojnacki on 21.04.2017.
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

import UIKit

final class ContactViewController: AppViewController {
    
    private enum Constants {
        static let keyboardMargin: CGFloat = 16.0
        static let minumumMessageTextViewTopSpace: CGFloat = 80.0
    }
    
    @IBOutlet private weak var containerView: UIView!
    
    @IBOutlet fileprivate weak var topicButton: TopicButton!
    @IBOutlet fileprivate weak var nameTextField: ContactTextField!
    @IBOutlet fileprivate weak var emailTextField: ContactTextField!
    @IBOutlet fileprivate weak var messageTextView: ContactTextView!
    @IBOutlet fileprivate weak var sendButton: AppShadowButton!
    
    @IBOutlet fileprivate weak var topicErrorLabel: UILabel!
    @IBOutlet fileprivate weak var nameErrorLabel: UILabel!
    @IBOutlet fileprivate weak var emailErrorLabel: UILabel!
    @IBOutlet fileprivate weak var messageErrorLabel: UILabel!
    
    override var viewControllerTitleKey: String? {
        return "CONTACT_TITLE"
    }
    
    override var shouldShowUserIcon: Bool {
        return true
    }
    
    private var shouldMoveContainer: Bool {
        return messageTextView.isFirstResponder
    }
    
    private var viewModel: ContactViewControllerViewModel!
    private var upperKeyboardLimit: CGFloat!
    private var messageErrorTextViewHeight: CGFloat!
    
    private let disposeBag = DisposeBag()
    
    convenience init(viewModel: ContactViewControllerViewModel) {
        self.init()
        self.viewModel = viewModel
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        let sendButtonFrame = sendButton.superview?.convert(sendButton.frame, to: view) ?? sendButton.frame
        upperKeyboardLimit = sendButtonFrame.maxY + Constants.keyboardMargin
        messageErrorTextViewHeight = messageTextView.frame.height
    }
    
    private func setup() {
        setupViews()
        setupTouchToDismiss()
        setupKeyboardNotifications()
        setupLocalization()
        reactiveSetup()
    }
    
    private func setupViews() {
        topicButton.associatedErrorView = topicErrorLabel
        nameTextField.associatedErrorView = nameErrorLabel
        emailTextField.associatedErrorView = emailErrorLabel
        messageTextView.associatedErrorView = messageErrorLabel
    }
    
    private func setupTouchToDismiss() {
        let recognizer = UITapGestureRecognizer(target: self.view, action: #selector(view.endEditing(_:)))
        recognizer.cancelsTouchesInView = false
        view.addGestureRecognizer(recognizer)
    }
    
    private func setupKeyboardNotification(name: Notification.Name) {
        NotificationCenter
            .default
            .notification(name)
            .subscribeNext { [weak self] notification in
                guard let keyboardFrame = (notification?.userInfo?[UIKeyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue,
                    let animationCurveInt = (notification?.userInfo?[UIKeyboardAnimationCurveUserInfoKey] as? NSNumber)?.uintValue,
                    let animationDuration = (notification?.userInfo?[UIKeyboardAnimationDurationUserInfoKey]as? NSNumber)?.doubleValue
                    else { return }
                
                self?.keyboardEvent(name: name, frame: keyboardFrame, animationOptions: UIViewAnimationOptions(rawValue: animationCurveInt << 16), animationDuration: animationDuration)
            }
            .add(to: disposeBag)
    }
    
    private func setupKeyboardNotifications() {
        setupKeyboardNotification(name: Notification.Name.UIKeyboardWillShow)
        setupKeyboardNotification(name: Notification.Name.UIKeyboardWillHide)
    }
    
    private func reactiveSetup() {
        topicButton.addTarget(viewModel, action: #selector(ContactViewControllerViewModel.pickerTapped), for: .touchUpInside)
        
        viewModel.pickerTitleObservable.subscribeNext { [weak self] title in
            self?.topicButton.setTitle(title, for: [])
            self?.topicButton.setTitleColor(UIColor.highlightedBlack, for: [])
        }
        .add(to: disposeBag)
        
        viewModel.pickerTopicsObservable.subscribeNext { [weak self] topics in
            guard let weakSelf = self, let topics = topics else { return }
            TopicPickerViewController.present(on: weakSelf, items: topics, callback: { result in
                weakSelf.viewModel.pickerResultObservable.next(result)
            })
        }
        .add(to: disposeBag)
        
        listenForErrors(observable: viewModel.pickerResultObservable, view: topicButton)
        
        let contactFieldTuples: [(Observable<String>, ContactFieldProtocol)] = [
            (viewModel.nameTextObservable, nameTextField),
            (viewModel.emailTextObservable, emailTextField),
            (viewModel.messageTextObservable, messageTextView)
        ]
        
        contactFieldTuples.forEach { observable, field in
            field.textObservable.bindNext(to: observable).add(to: disposeBag)
            listenForErrors(observable: observable, view: field)
        }
        
        viewModel.emailEmptyObservable.subscribeNext { [weak self] isEmpty in
            self?.emailErrorLabel.text = isEmpty ? localized("CONTACT_EMAIL_ERROR") : localized("CONTACT_EMAIL_INVALID_ERROR")
        }
        .add(to: disposeBag)
        
        sendButton.addTarget(viewModel, action: #selector(ContactViewControllerViewModel.sendTapped), for: .touchUpInside)

        viewModel.sendStatusObservable.subscribeNext { [weak self] result in
            guard let weakSelf = self, let result = result else { return }

            switch result {
            case .success:
                AlertHelper.showAlert(withTitle: localized("CONTACT_SEND_SUCCESS_TITILE"), message: localized("CONTACT_SEND_SUCCESS_MESSAGE"), on: weakSelf)
                weakSelf.resetPools()
            case .failure:
                AlertHelper.showAlert(withTitle: localized("CONTACT_SEND_FAILURE_TITLE"), message: localized("CONTACT_SEND_FAILURE_MESSAGE"), on: weakSelf)
            }
        }
        .add(to: disposeBag)

        viewModel.blockSendButton.subscribeNext { [weak self] blocked in
            self?.sendButton.isEnabled = !blocked
            self?.sendButton.showSpinner(blocked)

            if blocked {
                self?.sendButton.setTitle(localized("CONTACT_LOADING").uppercased(), for: [])
                self?.sendButton.backgroundColor = .lightBlueGrey
            } else {
                self?.sendButton.setTitle(localized("CONTACT_SEND").uppercased(), for: [])
                self?.sendButton.backgroundColor = .swiftOrange
            }
        }
        .add(to: disposeBag)
    }
    
    private func keyboardEvent(name: Notification.Name, frame: CGRect, animationOptions: UIViewAnimationOptions, animationDuration: TimeInterval) {
        let keyboardOffset = frame.minY - upperKeyboardLimit
        
        UIView.animate(withDuration: animationDuration, delay: 0.0, options: animationOptions, animations: {
            let translationY = self.shouldMoveContainer && keyboardOffset < 0.0 ? keyboardOffset : 0.0
            if name == Notification.Name.UIKeyboardWillHide {
                self.containerView.transform = .identity
                self.messageTextView.transform = .identity
                self.messageTextView.frame.size.height = self.messageErrorTextViewHeight
            } else {
                self.containerView.transform = CGAffineTransform(translationX: 0.0, y: translationY)
                if self.messageTextView.frame.origin.y + translationY < Constants.minumumMessageTextViewTopSpace {
                    self.messageTextView.frame.size.height += self.messageTextView.frame.origin.y + translationY
                    self.messageTextView.transform = CGAffineTransform(translationX: 0.0, y: -self.messageTextView.frame.origin.y - translationY)
                }
            }
        })
    }
    
    private func listenForErrors<T>(observable: Observable<T>, view: ContactFieldBaseProtocol) {
        observable.subscribeError { _ in
            view.fieldState = .error
        }
        .add(to: disposeBag)
    }

    private func resetPools() {
        topicButton.setTitle(localized("CONTACT_TOPIC") + "...", for: [])
        topicButton.setTitleColor(.placeholder, for: [])
        nameTextField.text = ""
        emailTextField.text = ""
        messageTextView.text = ""
        sendButton.setTitle(localized("CONTACT_SEND").uppercased(), for: [])

        viewModel.pickerResultObservable.next(-1)
        viewModel.nameTextObservable.next("")
        viewModel.emailTextObservable.next("")
        viewModel.messageTextObservable.next("")
    }
}

extension ContactViewController: Localizable {
    func setupLocalization() {
        topicButton.setTitle(localized("CONTACT_TOPIC") + "...", for: [])
        nameTextField.placeholder = localized("CONTACT_NAME")
        emailTextField.placeholder = localized("CONTACT_EMAIL")
        messageTextView.placeholder = localized("CONTACT_MESSAGE")
        sendButton.setTitle(localized("CONTACT_SEND").uppercased(), for: [])
        
        topicErrorLabel.text = localized("CONTACT_TOPIC_ERROR")
        nameErrorLabel.text = localized("CONTACT_NAME_ERROR")
        emailErrorLabel.text = localized("CONTACT_EMAIL_ERROR")
        messageErrorLabel.text = localized("CONTACT_MESSAGE_ERROR")
    }
}
