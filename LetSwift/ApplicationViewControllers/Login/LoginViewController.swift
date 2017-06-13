//
//  LoginViewController.swift
//  LetSwift
//
//  Created by Marcin Chojnacki, Kinga Wilczek on 18.04.2017.
//  Copyright © 2017 Droids On Roids. All rights reserved.
//

import UIKit

protocol LoginViewControllerDelegate: class {
    func facebookLoginCompleted()
    func loginHasSkipped()
}

final class LoginViewController: UIViewController {

    @IBOutlet private weak var animatedGreetingLabel: UILabel!
    @IBOutlet fileprivate weak var facebookButton: UIButton!
    @IBOutlet fileprivate weak var loginPurposeDescriptionLabel: UILabel!
    @IBOutlet fileprivate weak var loginSubtitleLabel: MultiSizeLabel!
    @IBOutlet fileprivate weak var skipLoginButton: UIButton!
    
    private let disposeBag = DisposeBag()
    
    private var viewModel: LoginViewControllerViewModel!
    private var labelAnimator: RandomLabelAnimator?

    convenience init(viewModel: LoginViewControllerViewModel) {
        self.init()
        self.viewModel = viewModel
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupLocalization()
        setupViews()
        reactiveSetup()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        if isBeingPresented || isMovingToParentViewController {
            viewModel.viewWillAppearPerformObservable.next()
        }
    }
    
    private func reactiveSetup() {
        skipLoginButton.addTarget(viewModel, action: #selector(LoginViewControllerViewModel.skipButtonTapped), for: .touchUpInside)
        
        viewModel.facebookAlertObservable.subscribeNext { [weak self] _ in
            guard let weakSelf = self else { return }
            AlertHelper.showAlert(withTitle: localized("GENERAL_SOMETHING_WENT_WRONG"), message: localized("GENERAL_TRY_AGAIN_LATER"), on: weakSelf)
        }
        .add(to: disposeBag)
        
        viewModel.animateWithRandomTextObservable.subscribeNext { [weak self] randomHello in
            self?.animateLabel(randomHello: randomHello)
        }
        .add(to: disposeBag)
    }
    
    private func setupViews() {
        animatedGreetingLabel.adjustsFontSizeToFitWidth = true
        loginPurposeDescriptionLabel.attributedText = loginPurposeDescriptionLabel.text?.attributed(withSpacing: 1.0)
    }

    private func createPrintAttributedText(_ label: String) -> NSAttributedString {
        return "print".attributed(withColor: .swiftOrange) +
            "(\"".attributed(withColor: .coolGrey) +
            label.attributed() +
            "\")".attributed(withColor: .coolGrey)
    }

    private func animateLabel(randomHello: String) {
        let attributedHello = createPrintAttributedText(randomHello)

        labelAnimator = RandomLabelAnimator(label: animatedGreetingLabel, finalResult: attributedHello)
        labelAnimator?.animate()
    }
    
    @IBAction private func facebookLoginButtonTapped(_ sender: AppShadowButton) {
        FacebookManager.shared.logIn(from: self, callback: viewModel.facebookLoginCallback)
    }
}

extension LoginViewController: Localizable {
    func setupLocalization() {
        skipLoginButton.setTitle(localized("LOGIN_SKIP_BUTTON_TITLE").uppercased(), for: [])
        facebookButton.setTitle(localized("LOGIN_BUTTON_TITLE").uppercased(), for: [])
        loginPurposeDescriptionLabel.text = localized("LOGIN_PURPOSE_DESCRIPTION")
        loginSubtitleLabel.text = localized("LOGIN_SUBTITLE")
    }
}
