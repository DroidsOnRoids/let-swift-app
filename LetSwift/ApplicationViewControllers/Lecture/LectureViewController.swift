//
//  LectureViewController.swift
//  LetSwift
//
//  Created by Marcin Chojnacki on 12.05.2017.
//  Copyright © 2017 Droids On Roids. All rights reserved.
//

import UIKit

final class LectureViewController: AppViewController {
    
    override var viewControllerTitleKey: String? {
        return "LECTURE_TITLE"
    }
    
    override var shouldHideShadow: Bool {
        return true
    }
}
