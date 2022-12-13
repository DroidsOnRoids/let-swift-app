//
//  SplashViewController.swift
//  LetSwift
//
//  Created by Marcin Chojnacki on 19.05.2017.
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

protocol SplashViewControllerDelegate: AnyObject {
    func initialLoadingHasFinished(events: [Event]?)
}

final class SplashViewController: UIViewController {
    
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
