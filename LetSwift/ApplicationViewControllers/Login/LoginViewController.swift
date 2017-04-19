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

    @IBOutlet private weak var label: UILabel!
    @IBOutlet private weak var fbButton: UIButton!
    
    private var viewModel: LoginViewControllerViewModel!

    convenience init(viewModel: LoginViewControllerViewModel) {
        self.init()
        self.viewModel = viewModel
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupViews()
    }
    
    private func setupViews() {
        fbButton.layer.cornerRadius = 6.0
        
        fbButton.layer.shadowColor = fbButton.backgroundColor?.cgColor
        fbButton.layer.shadowOpacity = 0.6
        fbButton.layer.shadowRadius = 10
        fbButton.layer.shadowOffset = CGSize(width: 0.0, height: 6.0)
        
        let shadowRect = fbButton.bounds.insetBy(dx: 10, dy: 0)
        fbButton.layer.shadowPath = UIBezierPath(rect: shadowRect).cgPath
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

        RandomLabelAnimator(label: label, finalResult: attributedHello).animate()
    }
}
