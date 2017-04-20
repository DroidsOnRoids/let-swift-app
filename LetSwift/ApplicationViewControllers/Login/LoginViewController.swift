//
//  LoginViewController.swift
//  LetSwift
//
//  Created by Marcin Chojnacki, Kinga Wilczek on 18.04.2017.
//  Copyright © 2017 Droids On Roids. All rights reserved.
//

import UIKit

protocol LoginViewControllerDelegate: class {
}

final class LoginViewController: UIViewController {

    @IBOutlet private weak var animatedGreetingLabel: UILabel!
    @IBOutlet fileprivate weak var facebookButton: UIButton!
    @IBOutlet fileprivate weak var loginPurposeDescription: UILabel!
    @IBOutlet fileprivate weak var loginSubtitleLabel: MultiSizeLabel!
    @IBOutlet fileprivate weak var skipLoginButton: UIButton!
    
    private var viewModel: LoginViewControllerViewModel!

    convenience init(viewModel: LoginViewControllerViewModel) {
        self.init()
        self.viewModel = viewModel
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupLocalization()
        setupViews()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        animateLabel()
    }
    
    private func setupViews() {
        loginPurposeDescription.attributedText = loginPurposeDescription.text?.attributed(withSping: 1.0)
        facebookButton.showShadow()
    }

    private func createPrintAttributedText(_ label: String) -> NSAttributedString {
        return "print".attributed(withColor: .swiftOrange) +
            "(”".attributed(withColor: .coolGrey) +
            label.attributed() +
            "”)".attributed(withColor: .coolGrey)
    }

    private func animateLabel() {
        let randomHello = viewModel.randomHelloWorld()
        let attributedHello = createPrintAttributedText(randomHello)

        RandomLabelAnimator(label: animatedGreetingLabel, finalResult: attributedHello).animate()
    }
}

extension LoginViewController: Localizable {
    func setupLocalization() {
        skipLoginButton.setTitle(localized("LOGIN_SKIP_BUTTON_TITLE").uppercased(), for: [])
        facebookButton.setTitle(localized("LOGIN_BUTTON_TITLE").uppercased(), for: [])
        loginPurposeDescription.text = localized("LOGIN_PURPOSE_DESCRIPTION")
        loginSubtitleLabel.text = localized("LOGIN_SUBTITLE")
    }
}
