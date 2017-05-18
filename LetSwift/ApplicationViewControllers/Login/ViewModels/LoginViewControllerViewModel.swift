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
    var facebookAlertObservable = Observable<String?>(nil)
    var animateWithRandomTextObservable = Observable<String>("")
    
    weak var delegate: LoginViewControllerDelegate?
    
    private let disposeBag = DisposeBag()
    
    private enum Constants {
        static let helloWorldVariants = [
            "Hello world!",
            "Bonjour le monde!",
            "Halo Welt!",
            "Witaj świecie!",
            "¡Hola, Mundo!"
        ]
    }
    
    init(delegate: LoginViewControllerDelegate?) {
        self.delegate = delegate
        
        setup()
    }
    
    private func setup() {
        viewWillAppearPerformObservable.subscribeNext { [weak self] in
            self?.animateWithRandomTextObservable.next(Constants.helloWorldVariants.randomElement())
        }
        .add(to: disposeBag)
    }
    
    func facebookLoginCallback(status: FacebookLoginStatus) {
        switch status {
        case .success:
            delegate?.facebookLoginCompleted()
        case let .error(error):
            facebookAlertObservable.next(error?.localizedDescription)
        default: break
        }
    }
    
    @objc func skipButtonTapped() {
        delegate?.loginHasSkipped()
    }
}
