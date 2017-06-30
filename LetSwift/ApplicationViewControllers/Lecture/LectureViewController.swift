//
//  LectureViewController.swift
//  LetSwift
//
//  Created by Marcin Chojnacki on 12.05.2017.
//  Copyright © 2017 Droids On Roids. All rights reserved.
//

import UIKit

protocol LectureViewControllerDelegate: class {
    func presentSpeakerDetailsScreen()
}

final class LectureViewController: AppViewController {
    
    @IBOutlet private weak var speakerCellView: TappableView!
    @IBOutlet private weak var indicatorView: UIImageView!
    @IBOutlet private weak var speakerImageView: UIImageView!
    @IBOutlet private weak var speakerNameLabel: UILabel!
    @IBOutlet private weak var speakerTitleLabel: UILabel!
    @IBOutlet private weak var lectureTitleLabel: UILabel!
    @IBOutlet private weak var lectureSummaryLabel: UILabel!
    
    @IBOutlet private weak var separatorConstraint: NSLayoutConstraint!
    
    private var viewModel: LectureViewControllerViewModel!
    private let disposeBag = DisposeBag()
    
    override var viewControllerTitleKey: String? {
        return "LECTURE_TITLE"
    }
    
    override var shouldHideShadow: Bool {
        return true
    }
    
    convenience init(viewModel: LectureViewControllerViewModel) {
        self.init()
        self.viewModel = viewModel
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setup()
    }
    
    private func setup() {
        separatorConstraint.constant = 1.0 / UIScreen.main.scale
        speakerCellView.addTarget(viewModel, action: #selector(LectureViewControllerViewModel.speakerCellTapped))
        
        reactiveSetup()
    }
    
    private func reactiveSetup() {
        viewModel.shouldAllowTappingSpeaker?.subscribeNext(startsWithInitialValue: true) { [weak self] allow in
            self?.speakerCellView.selectionColor = allow ? .lightBlueGrey : nil
            self?.indicatorView.isHidden = !allow
        }
        .add(to: disposeBag)
    }
}
