//
//  LectureViewController.swift
//  LetSwift
//
//  Created by Marcin Chojnacki on 12.05.2017.
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

final class LectureViewController: AppViewController {
    
    private enum Constants {
        static let mediumLetterSpacing: CGFloat = 0.9
        static let normalLetterSpacing: CGFloat = 1.0
    }
    
    @IBOutlet private weak var speakerCellView: TappableView!
    @IBOutlet private weak var speakerImageView: UIImageView!
    @IBOutlet private weak var speakerNameLabel: AppLabel!
    @IBOutlet private weak var speakerTitleLabel: AppLabel!
    @IBOutlet private weak var eventDateLabel: AppLabel!
    @IBOutlet private weak var eventTimeLabel: AppLabel!
    @IBOutlet private weak var lectureTitleLabel: AppLabel!
    @IBOutlet private weak var lectureSummaryLabel: AppLabel!
    
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
        viewModel.talkObservable.subscribeNext(startsWithInitialValue: true) { [weak self] talk in
            self?.speakerImageView.setImage(url: talk.speaker?.avatar?.thumb, errorPlaceholder: self?.speakerImageView.image)
            self?.speakerNameLabel.text = talk.speaker?.name
            self?.speakerTitleLabel.text = talk.speaker?.job
            self?.eventDateLabel.text = talk.event?.date?.stringDateValue
            self?.eventTimeLabel.text = talk.event?.date?.stringTimeValue
            self?.lectureTitleLabel.text = talk.title
            self?.lectureSummaryLabel.text = talk.description
        }
        .add(to: disposeBag)
    }
}
