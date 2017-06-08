//
//  RotatingMVPhotoBrowser.swift
//  LetSwift
//
//  Created by Marcin Chojnacki on 08.06.2017.
//  Copyright © 2017 Droids On Roids. All rights reserved.
//

import MWPhotoBrowser

final class RotatingMVPhotoBrowser: MWPhotoBrowser {
    
    weak var coordinatorDelegate: AppCoordinatorDelegate?
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        coordinatorDelegate?.rotationLocked = false
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        coordinatorDelegate?.rotationLocked = true
    }
}
