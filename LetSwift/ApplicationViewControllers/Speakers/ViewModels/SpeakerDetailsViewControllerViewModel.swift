//
//  SpeakerDetailsViewControllerViewModel.swift
//  LetSwift
//
//  Created by Marcin Chojnacki on 28.06.2017.
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

final class SpeakerDetailsViewControllerViewModel {
    
    weak var delegate: SpeakerLectureFlowDelegate?
    
    let speakerObservable = Observable<Speaker?>(nil)
    let tableViewStateObservable = Observable<AppContentState>(.loading)
    let showLectureDetailsObservable = Observable<Int?>(nil)
    let refreshObservable = Observable<Void>()
    
    private let disposeBag = DisposeBag()
    private let speakerId: Int
    
    init(with id: Int, delegate: SpeakerLectureFlowDelegate?) {
        speakerId = id
        self.delegate = delegate
        setup()
    }
    
    private func setup() {
        speakerObservable.subscribeNext { [weak self] speaker in
            self?.tableViewStateObservable.next(.content)
        }
        .add(to: disposeBag)
        
        showLectureDetailsObservable.subscribeNext { [weak self] talkId in
            guard let talkId = talkId, var talkToShow = self?.speakerObservable.value?.talks.filter({ $0.id == talkId }).first else { return }
            
            talkToShow.speaker = self?.speakerObservable.value?.withoutExtendedFields
            self?.delegate?.presentLectureScreen(with: talkToShow)
        }
        .add(to: disposeBag)
        
        refreshObservable.subscribeNext { [weak self] in
            self?.refreshData()
        }
        .add(to: disposeBag)
        
        loadInitialData()
    }
    
    private func loadInitialData() {
        NetworkProvider.shared.speakerDetails(with: speakerId) { [weak self] response in
            switch response {
            case let .success(speaker):
                self?.speakerObservable.next(speaker)
            case .error:
                self?.tableViewStateObservable.next(.error)
            }
        }
    }
    
    private func refreshData() {
        NetworkProvider.shared.speakerDetails(with: speakerId) { [weak self] response in
            if case .success(let speaker) = response {
                self?.speakerObservable.next(speaker)
            }
            
            self?.refreshObservable.complete()
        }
    }
}
