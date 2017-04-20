//
//  LoginViewController.swift
//  LetSwift
//
//  Created by Marcin Chojnacki on 18.04.2017.
//  Copyright © 2017 Droids On Roids. All rights reserved.
//

import UIKit

protocol LoginViewControllerDelegate: class {
}

class LoginViewController: UIViewController {

    @IBOutlet private weak var animatedGreetingLabel: UILabel!
    @IBOutlet private weak var facebookButton: UIButton!
    @IBOutlet private weak var loginPurposeDescription: UILabel!
    
    private var viewModel: LoginViewControllerViewModel!

    convenience init(viewModel: LoginViewControllerViewModel) {
        self.init()
        self.viewModel = viewModel
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupViews()
        loginPurposeDescription.attributedText = loginPurposeDescription.text?.attributed(withSping: 1.0)
    }
    
    private func setupViews() {
        facebookButton.showAppShadow()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        animateLabel()
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
