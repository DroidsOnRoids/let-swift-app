//
//  LoginViewControllerViewModel.swift
//  LetSwift
//
//  Created by Marcin Chojnacki on 19.04.2017.
//  Copyright © 2017 Droids On Roids. All rights reserved.
//

final class LoginViewControllerViewModel {

    weak var delegate: LoginViewControllerDelegate?
    
    private let helloWorldVariants = [
        "Hello world!",
        "Bonjour le monde!",
        "Halo Welt!",
        "Witaj świecie!",
        "¡Hola, Mundo!"
    ]
    
    init(delegate: LoginViewControllerDelegate?) {
        self.delegate = delegate
    }
    
    func randomHelloWorld() -> String {
        return helloWorldVariants.randomElement()
    }
}
