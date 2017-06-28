//
//  SpeakerDetailsViewControllerViewModel.swift
//  LetSwift
//
//  Created by Marcin Chojnacki on 28.06.2017.
//  Copyright © 2017 Droids On Roids. All rights reserved.
//

final class SpeakerDetailsViewControllerViewModel {
    
    private let disposeBag = DisposeBag()
    private let speakerId: Int
    
    init(with id: Int) {
        speakerId = id
        setup()
    }
    
    private func setup() {
        print(speakerId)
        
        NetworkProvider.shared.speakerDetails(with: speakerId) { response in
            if case .success(let speaker) = response {
                print(speaker)
            }
            
            print(response)
            //self?.eventsListRefreshObservable.complete()
        }
    }
}
