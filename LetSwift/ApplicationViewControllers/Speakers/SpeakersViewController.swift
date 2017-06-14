//
//  SpeakersViewController.swift
//  LetSwift
//
//  Created by Marcin Chojnacki on 21.04.2017.
//  Copyright © 2017 Droids On Roids. All rights reserved.
//

import UIKit

protocol SpeakersViewControllerDelegate: class {
}

final class SpeakersViewController: AppViewController {
    
    override var viewControllerTitleKey: String? {
        return "SPEAKERS_TITLE"
    }
    
    override var shouldShowUserIcon: Bool {
        return true
    }
    
    override var shouldHideShadow: Bool {
        return true
    }

    private var viewModel: SpeakersViewControllerViewModel!

    convenience init(viewModel: SpeakersViewControllerViewModel) {
        self.init()
        self.viewModel = viewModel
    }
}
