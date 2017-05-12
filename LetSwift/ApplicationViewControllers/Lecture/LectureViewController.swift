//
//  LectureViewController.swift
//  LetSwift
//
//  Created by Marcin Chojnacki on 12.05.2017.
//  Copyright © 2017 Droids On Roids. All rights reserved.
//

import UIKit

final class LectureViewController: AppViewController {
    
    @IBOutlet private weak var speakerImageView: UIImageView!
    @IBOutlet private weak var speakerNameLabel: UILabel!
    @IBOutlet private weak var speakerTitleLabel: UILabel!
    @IBOutlet private weak var lectureTitleLabel: UILabel!
    @IBOutlet private weak var lectureSummaryLabel: UILabel!
    
    @IBOutlet private weak var separatorConstraint: NSLayoutConstraint!
    
    override var viewControllerTitleKey: String? {
        return "LECTURE_TITLE"
    }
    
    override var shouldHideShadow: Bool {
        return true
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setup()
    }
    
    private func setup() {
        separatorConstraint.constant = 1.0 / UIScreen.main.scale
    }
}
