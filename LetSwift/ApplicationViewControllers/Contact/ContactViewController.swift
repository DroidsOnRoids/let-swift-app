//
//  ContactViewController.swift
//  LetSwift
//
//  Created by Marcin Chojnacki on 21.04.2017.
//  Copyright © 2017 Droids On Roids. All rights reserved.
//

import UIKit

final class ContactViewController: AppViewController {
    
    @IBOutlet fileprivate weak var topicButton: UIButton!
    @IBOutlet fileprivate weak var nameTextField: AppTextField!
    @IBOutlet fileprivate weak var emailTextField: AppTextField!
    @IBOutlet fileprivate weak var messageTextView: UITextView!
    @IBOutlet fileprivate weak var sendButton: AppShadowButton!
    
    @IBOutlet fileprivate weak var chooseTheTopicError: UILabel!
    @IBOutlet fileprivate weak var enterYourNameError: UILabel!
    @IBOutlet fileprivate weak var enterYourEmailError: UILabel!
    @IBOutlet fileprivate weak var enterTheMessageError: UILabel!
    
    override var viewControllerTitleKey: String? {
        return "CONTACT_TITLE"
    }
    
    override var shouldShowUserIcon: Bool {
        return true
    }
    
    private var viewModel: ContactViewControllerViewModel!
    
    fileprivate var messagePlaceholder: String!
    fileprivate lazy var errorParagraphStyle: NSParagraphStyle = {
        let style = NSMutableParagraphStyle()
        style.firstLineHeadIndent = 8.0
        
        return style
    }()

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
        let borderColor = UIColor.lightBlueGrey.cgColor
        
        topicButton.layer.borderColor = borderColor
        
        nameTextField.delegate = self
        nameTextField.layer.borderColor = borderColor
        
        emailTextField.delegate = self
        emailTextField.layer.borderColor = borderColor
        
        messageTextView.delegate = self
        messageTextView.layer.borderColor = borderColor
        messageTextView.textContainerInset = UIEdgeInsets(top: 16.0, left: 12.0, bottom: 16.0, right: 12.0)
    }
    
    private func setupTouchToDismiss() {
        let recognizer = UITapGestureRecognizer(target: self.view, action: #selector(view.endEditing(_:)))
        recognizer.cancelsTouchesInView = false
        view.addGestureRecognizer(recognizer)
    }
}

extension ContactViewController: Localizable {
    private func setErrorLabelTranslation(_ label: UILabel, key: String) {
        label.attributedText = localized(key).attributed(
            withAttributes: [NSParagraphStyleAttributeName: errorParagraphStyle])
    }
    
    func setupLocalization() {
        topicButton.setTitle(localized("CONTACT_TOPIC"), for: [])
        nameTextField.placeholder = localized("CONTACT_NAME")
        emailTextField.placeholder = localized("CONTACT_EMAIL")
        messagePlaceholder = localized("CONTACT_MESSAGE")
        sendButton.setTitle(localized("CONTACT_SEND").uppercased(), for: [])
        
        setErrorLabelTranslation(chooseTheTopicError, key: "CONTACT_TOPIC_ERROR")
        setErrorLabelTranslation(enterYourNameError, key: "CONTACT_NAME_ERROR")
        setErrorLabelTranslation(enterYourEmailError, key: "CONTACT_EMAIL_ERROR")
        setErrorLabelTranslation(enterTheMessageError, key: "CONTACT_MESSAGE_ERROR")
    }
}

extension ContactViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        let nextTag = textField.tag + 1
        
        if let nextResponder = view.viewWithTag(nextTag) {
            nextResponder.becomeFirstResponder()
        } else {
            textField.resignFirstResponder()
        }
        
        return false
    }
}

// TODO: Replace this with something better
extension ContactViewController: UITextViewDelegate {
    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView.text == messagePlaceholder {
            textView.text = ""
        }
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        if textView.text == "" {
            textView.text = messagePlaceholder
        }
    }
}
