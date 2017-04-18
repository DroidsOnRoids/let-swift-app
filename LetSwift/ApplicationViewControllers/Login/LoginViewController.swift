//
//  LoginViewController.swift
//  LetSwift
//
//  Created by Marcin Chojnacki on 18.04.2017.
//  Copyright © 2017 Droids On Roids. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController {

    @IBOutlet private weak var label: UILabel!

    private let helloWorldVariants = [
        "Hello world!",
        "Bonjour le monde!",
        "Halo Welt!",
        "Witaj świecie!",
        "¡Hola, Mundo!"
    ]

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)

        animateLabel()
    }

    private func createPrintAttributedText(_ label: String) -> NSAttributedString {
        return "print".attributed(withColor: .swiftOrange) +
            "(”".attributed(withColor: .coolGrey) +
            label.attributed() +
            "”)".attributed(withColor: .coolGrey)
    }

    private func animateLabel() {
        let randomHello = helloWorldVariants.randomElement()
        let attributedHello = createPrintAttributedText(randomHello)

        RandomLabelAnimator(label: label, finalResult: attributedHello).animate()
    }

    @IBAction func animateButtonAction(_ sender: UIButton) {
        animateLabel()
    }
}
