//
//  SpeakerDetailsViewControllerViewModel.swift
//  LetSwift
//
//  Created by Marcin Chojnacki on 28.06.2017.
//  Copyright © 2017 Droids On Roids. All rights reserved.
//

final class SpeakerDetailsViewControllerViewModel {
    
    var speakerObservable = Observable<Speaker?>(nil)
    var tableViewStateObservable = Observable<AppContentState>(.loading)
    
    private let disposeBag = DisposeBag()
    private let speakerId: Int
    
    init(with id: Int) {
        speakerId = id
        setup()
    }
    
    private func setup() {
        speakerObservable.subscribeNext { [weak self] speaker in
            self?.tableViewStateObservable.next(.content)
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
}
