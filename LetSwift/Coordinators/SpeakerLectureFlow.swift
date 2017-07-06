//
//  SpeakerLectureFlow.swift
//  LetSwift
//
//  Created by Marcin Chojnacki on 05.07.2017.
//  Copyright © 2017 Droids On Roids. All rights reserved.
//

import Foundation

protocol SpeakerLectureFlowDelegate: class {
    func presentSpeakerDetailsScreen(with id: Int)
    func presentLectureScreen(with talk: Talk)
}

extension SpeakerLectureFlowDelegate where Self: Coordinator {
    func presentSpeakerDetailsScreen(with id: Int) {
        let viewModel = SpeakerDetailsViewControllerViewModel(with: id, delegate: self)
        let viewController = SpeakerDetailsViewController(viewModel: viewModel)
        
        navigationViewController.pushViewController(viewController, animated: true)
    }
    
    func presentLectureScreen(with talk: Talk) {
        let viewModel = LectureViewControllerViewModel(with: talk, delegate: self)
        let viewController = LectureViewController(viewModel: viewModel)
        
        navigationViewController.pushViewController(viewController, animated: true)
    }
}
