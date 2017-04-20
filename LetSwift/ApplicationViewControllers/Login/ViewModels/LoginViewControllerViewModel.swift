//
//  LoginViewControllerViewModel.swift
//  LetSwift
//
//  Created by Marcin Chojnacki, Kinga Wilczek on 19.04.2017.
//  Copyright © 2017 Droids On Roids. All rights reserved.
//

final class LoginViewControllerViewModel {

    var viewWillAppearPerformObservable = Observable<Void>()
    var animateWithRandomTextObservable = Observable<String>("")
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
        
        setup()
    }
    
    private func setup() {
        viewWillAppearPerformObservable.subscribe(onNext: { [weak self] in
            guard let weakSelf = self else { return }
            weakSelf.animateWithRandomTextObservable.next(weakSelf.helloWorldVariants.randomElement())
        })
    }
    
    func facebookLoginCallback(status: FacebookManager.FacebookLoginStatus) {
        print(status)
    }
}
