//
//  SplashViewControllerViewModel.swift
//  LetSwift
//
//  Created by Marcin Chojnacki on 24.05.2017.
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

import Foundation

final class SplashViewControllerViewModel {

    var viewDidAppearPerformObservable = Observable<Void>()
    weak var delegate: SplashViewControllerDelegate?
    
    private let disposeBag = DisposeBag()
    
    init(delegate: SplashViewControllerDelegate?) {
        self.delegate = delegate
        
        setup()
    }
    
    private func setup() {
        viewDidAppearPerformObservable.subscribeNext { [weak self] in
            self?.downloadEventsList()
        }
        .add(to: disposeBag)
    }
    
    private func downloadEventsList() {
        NetworkProvider.shared.eventsList(with: 1) { [weak self] response in
            switch response {
            case let .success(event):
                self?.downloadEvent(eventsList: event.elements)
            case .error:
                self?.delegate?.initialLoadingHasFinished(events: nil)
            }
        }
    }
    
    private func downloadEvent(eventsList: [Event]) {
        guard let firstEventId = eventsList.first?.id else {
            delegate?.initialLoadingHasFinished(events: nil)
            return
        }
        
        NetworkProvider.shared.eventDetails(with: firstEventId) { [weak self] response in
            switch response {
            case let .success(event):
                var mutableEventsList = eventsList
                mutableEventsList[0] = event
                self?.delegate?.initialLoadingHasFinished(events: mutableEventsList)
            case .error:
                self?.delegate?.initialLoadingHasFinished(events: nil)
            }
        }
    }
}
