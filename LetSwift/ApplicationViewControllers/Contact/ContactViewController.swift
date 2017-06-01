//
//  ContactViewController.swift
//  LetSwift
//
//  Created by Marcin Chojnacki on 21.04.2017.
//  Copyright © 2017 Droids On Roids. All rights reserved.
//

import UIKit

final class ContactViewController: AppViewController {
    
    @IBOutlet private weak var containerView: UIView!
    
    @IBOutlet fileprivate weak var topicButton: UIButton!
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
    
    private var viewModel: ContactViewControllerViewModel!
    
    convenience init(viewModel: ContactViewControllerViewModel) {
        self.init()
        self.viewModel = viewModel
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
    }
    
    private func setup() {
        setupViews()
        setupTouchToDismiss()
        setupLocalization()
    }
    
    private func setupViews() {
        topicButton.layer.borderColor = UIColor.lightBlueGrey.cgColor
        nameTextField.associatedErrorView = nameErrorLabel
        emailTextField.associatedErrorView = emailErrorLabel
        messageTextView.associatedErrorView = messageErrorLabel
    }
    
    private func setupTouchToDismiss() {
        let recognizer = UITapGestureRecognizer(target: self.view, action: #selector(view.endEditing(_:)))
        recognizer.cancelsTouchesInView = false
        view.addGestureRecognizer(recognizer)
    }
}

extension ContactViewController: Localizable {
    func setupLocalization() {
        topicButton.setTitle(localized("CONTACT_TOPIC"), for: [])
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
