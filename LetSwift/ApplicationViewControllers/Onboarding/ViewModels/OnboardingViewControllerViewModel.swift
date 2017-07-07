//
//  OnboardingViewControllerViewModel.swift
//  LetSwift
//
//  Created by Marcin Chojnacki, Kinga Wilczek on 13.04.2017.
//  Copyright © 2017 Droids On Roids. All rights reserved.
//

import Foundation

struct OnboardingCardModel {
    let imageName: String
    let titleKey: String
    let descriptionKey: String
}

final class OnboardingViewControllerViewModel {
    
    private enum Constants {
        static let onboardingContinueTitle = localized("ONBOARDING_CONTINUE").uppercased()
        static let onboardingFinishTitle = localized("ONBOARDING_FINISH").uppercased()
        
        static let defaultCards = [
            OnboardingCardModel(imageName: "OnboardingMeetups", titleKey: "ONBOARDING_MEETUPS_TITLE", descriptionKey: "ONBOARDING_MEETUPS_DESCRIPTION"),
            OnboardingCardModel(imageName: "OnboardingSpeakers", titleKey: "ONBOARDING_SPEAKERS_TITLE", descriptionKey: "ONBOARDING_SPEAKERS_DESCRIPTION"),
            OnboardingCardModel(imageName: "OnboardingPrice", titleKey: "ONBOARDING_PRICE_TITLE", descriptionKey: "ONBOARDING_PRICE_DESCRIPTION")
        ]
    }

    weak var delegate: OnboardingViewControllerCoordinatorDelegate?
    
    let pageRequestObservable = Observable<Int>(0)
    let currentPageObservable = Observable<Int>(0)
    let currentIconObservable = Observable<String?>(nil)
    let continueButtonTitleObservable = Observable<String>(Constants.onboardingContinueTitle)
    let onboardingCardsObservable = Observable<[OnboardingCardModel]>(Constants.defaultCards)
    
    private let disposeBag = DisposeBag()
    
    init(delegate: OnboardingViewControllerCoordinatorDelegate?) {
        self.delegate = delegate
        setup()
    }
    
    private func setup() {
        currentPageObservable.subscribeNext { [weak self] page in
            guard let weakSelf = self else { return }
            
            weakSelf.currentIconObservable.next(weakSelf.onboardingCardsObservable.value[page].imageName)
            
            let isOnLastPage = page >= weakSelf.onboardingCardsObservable.value.count - 1
            weakSelf.continueButtonTitleObservable.next(isOnLastPage ? Constants.onboardingFinishTitle : Constants.onboardingContinueTitle)
        }
        .add(to: disposeBag)
    }
    
    @objc func continueButtonTapped() {
        if currentPageObservable.value < onboardingCardsObservable.value.count - 1 {
            pageRequestObservable.next(currentPageObservable.value + 1)
        } else {
            delegate?.onboardingHasCompleted()
        }
    }
}
