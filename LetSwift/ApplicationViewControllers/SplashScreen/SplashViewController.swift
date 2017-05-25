//
//  SplashViewController.swift
//  LetSwift
//
//  Created by Marcin Chojnacki on 19.05.2017.
//  Copyright © 2017 Droids On Roids. All rights reserved.
//

import UIKit

protocol SplashViewControllerDelegate: class {
    func initialLoadingHasFinished(events: [Event]?)
}

final class SplashViewController: UIViewController {
    
    override var nibName: String? {
        return "LaunchScreen"
    }
    
    private var viewModel: SplashViewControllerViewModel!
    
    convenience init(viewModel: SplashViewControllerViewModel) {
        self.init()
        self.viewModel = viewModel
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        viewModel.viewDidAppearPerformObservable.next()
    }
}
