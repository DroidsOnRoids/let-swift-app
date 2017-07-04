//
//  SpeakerDetailsViewControllerViewModel.swift
//  LetSwift
//
//  Created by Marcin Chojnacki on 28.06.2017.
//  Copyright © 2017 Droids On Roids. All rights reserved.
//

final class SpeakerDetailsViewControllerViewModel {
    
    weak var delegate: SpeakerDetailsViewControllerDelegate?
    
    let speakerObservable = Observable<Speaker?>(nil)
    let tableViewStateObservable = Observable<AppContentState>(.loading)
    let showLectureDetailsObservable = Observable<Int?>(nil)
    let refreshObservable = Observable<Void>()
    
    private let disposeBag = DisposeBag()
    private let speakerId: Int
    
    init(with id: Int, delegate: SpeakerDetailsViewControllerDelegate?) {
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
            guard let talkId = talkId else { return }
            if let talkToShow = self?.speakerObservable.value?.talks.filter({ $0.id == talkId }).first {
                self?.delegate?.presentLectureScreen(with: talkToShow)
            }
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
