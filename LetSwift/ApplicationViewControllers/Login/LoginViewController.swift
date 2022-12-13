//
//  LoginViewController.swift
//  LetSwift
//
//  Created by Marcin Chojnacki, Kinga Wilczek on 18.04.2017.
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

protocol LoginViewControllerDelegate: AnyObject {
    func facebookLoginCompleted()
    func loginHasSkipped()
}

final class LoginViewController: UIViewController {

    @IBOutlet private weak var animatedGreetingLabel: UILabel!
    @IBOutlet private weak var facebookButton: UIButton!
    @IBOutlet private weak var loginPurposeDescriptionLabel: UILabel!
    @IBOutlet private weak var loginTitleLabel: UILabel!
    @IBOutlet private weak var loginSubtitleLabel: MultiSizeLabel!
    @IBOutlet private weak var skipLoginButton: UIButton!
    
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
        
        if isBeingPresented || isMovingToParent {
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
        
        viewModel.animateWithRandomTextObservable.subscribeNext { [weak self] randomGreeting in
            self?.animateLabel(with: randomGreeting)
        }
        .add(to: disposeBag)
    }
    
    private func setupViews() {
        animatedGreetingLabel.adjustsFontSizeToFitWidth = true
        loginPurposeDescriptionLabel.attributedText = loginPurposeDescriptionLabel.text?.attributed(withSpacing: 1.0)
    }
    
    private func animateLabel(with greeting: String) {
        let attributedGreeting = EventBranding.current.greetingText(with: greeting)

        labelAnimator = RandomLabelAnimator(label: animatedGreetingLabel, finalResult: attributedGreeting)
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
        loginTitleLabel.text = EventBranding.current.name
        loginSubtitleLabel.text = EventBranding.current.description
    }
}
