//
//  ContactViewController.swift
//  LetSwift
//
//  Created by Marcin Chojnacki on 21.04.2017.
//  Copyright © 2017 Droids On Roids. All rights reserved.
//

import UIKit

final class ContactViewController: AppViewController {
    
    @IBOutlet private weak var topicButton: UIButton!
    @IBOutlet private weak var nameTextField: AppTextField!
    @IBOutlet private weak var emailTextField: AppTextField!
    @IBOutlet private weak var messageTextView: UITextView!
    
    override var viewControllerTitleKey: String? {
        return "CONTACT_TITLE"
    }
    
    override var shouldShowUserIcon: Bool {
        return true
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
    }
    
    private func setupViews() {
        let borderColor = UIColor.lightBlueGrey.cgColor
        
        topicButton.layer.borderColor = borderColor
        nameTextField.layer.borderColor = borderColor
        emailTextField.layer.borderColor = borderColor
        messageTextView.layer.borderColor = borderColor
        messageTextView.textContainerInset = UIEdgeInsets(top: 16.0, left: 12.0, bottom: 16.0, right: 12.0)
    }
}
