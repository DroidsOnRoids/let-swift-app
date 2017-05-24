//
//  SplashViewControllerViewModel.swift
//  LetSwift
//
//  Created by Marcin Chojnacki on 24.05.2017.
//  Copyright © 2017 Droids On Roids. All rights reserved.
//

import Foundation

final class SplashViewControllerViewModel {
    
    private enum Constants {
        static let eventsPerPage = 20
    }
    
    private let disposeBag = DisposeBag()
    
    var viewDidAppearPerformObservable = Observable<Void>()
    
    weak var delegate: SplashViewControllerDelegate?
    
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
        NetworkProvider.shared.eventsList(with: 1, perPage: Constants.eventsPerPage) { [weak self] response in
            switch response {
            case let .success(event):
                self?.downloadEvent(eventsList: event.elements)
            case .error(_):
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
            case .error(_):
                self?.delegate?.initialLoadingHasFinished(events: nil)
            }
        }
    }
}
