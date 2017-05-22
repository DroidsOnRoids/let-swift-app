//
//  SplashViewController.swift
//  LetSwift
//
//  Created by Marcin Chojnacki on 19.05.2017.
//  Copyright © 2017 Droids On Roids. All rights reserved.
//

import UIKit

final class SplashViewController: UIViewController {
    
    var jobToDo: (() -> ())?
    
    override var nibName: String? {
        return "LaunchScreen"
    }
    
    convenience init(jobToDo: @escaping () -> ()) {
        self.init()
        
        self.jobToDo = jobToDo
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        jobToDo?()
    }
}
