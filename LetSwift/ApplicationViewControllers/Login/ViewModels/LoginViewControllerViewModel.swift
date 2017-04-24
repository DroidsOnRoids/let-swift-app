//
//  LoginViewControllerViewModel.swift
//  LetSwift
//
//  Created by Marcin Chojnacki, Kinga Wilczek on 19.04.2017.
//  Copyright © 2017 Droids On Roids. All rights reserved.
//

import Foundation

final class LoginViewControllerViewModel {

    var viewWillAppearPerformObservable = Observable<Void>()
    var animateWithRandomTextObservable = Observable<String>("")
    
    weak var delegate: LoginViewControllerCoordinatorDelegate?
    weak var viewDelegate: LoginViewControllerDelegate?
    
    private enum Constants {
        static let helloWorldVariants = [
            "Hello world!",
            "Bonjour le monde!",
            "Halo Welt!",
            "Witaj świecie!",
            "¡Hola, Mundo!"
        ]
    }
    
    init(delegate: LoginViewControllerCoordinatorDelegate?) {
        self.delegate = delegate
        
        setup()
    }
    
    private func setup() {
        viewWillAppearPerformObservable.subscribe(onNext: { [weak self] in
            guard let weakSelf = self else { return }
            weakSelf.animateWithRandomTextObservable.next(Constants.helloWorldVariants.randomElement())
        })
    }
    
    func facebookLoginCallback(status: FacebookLoginStatus) {
        switch status {
        case .success:
            delegate?.facebookLoginCompleted()
        case let .error(error):
            viewDelegate?.showFacebookErrorDialog(error: error?.localizedDescription)
        default: break
        }
    }
    
    @objc func skipButtonTapped() {
        delegate?.loginHasSkipped()
    }
}
