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
    
    private var viewModel: LectureViewControllerViewModel!
    
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
        
        // TODO: Implement me :)
        printLectureData()
    }
    
    private func printLectureData() {
        print("speakerAvatarURL: \(String(describing: viewModel.speakerAvatarURL))")
        print("speakerName: \(viewModel.speakerName)")
        print("speakerJob: \(viewModel.speakerJob)")
        print("eventDate: \(viewModel.eventDate)")
        print("eventTime: \(viewModel.eventTime)")
        print("lectureTitle: \(viewModel.lectureTitle)")
        print("lectureSummary: \(viewModel.lectureSummary)")
    }
}
