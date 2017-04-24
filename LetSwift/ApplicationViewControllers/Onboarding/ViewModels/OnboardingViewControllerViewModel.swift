//
//  OnboardingViewControllerViewModel.swift
//  LetSwift
//
//  Created by Marcin Chojnacki, Kinga Wilczek on 13.04.2017.
//  Copyright © 2017 Droids On Roids. All rights reserved.
//

import Foundation

final class OnboardingViewControllerViewModel {
    
    private enum Constants {
        static let onboardingContinueTitle = localized("ONBOARDING_CONTINUE").uppercased()
        static let onboardingFinishTitle = localized("ONBOARDING_FINISH").uppercased()
        
        static let onboardingMeetupsImageName = "OnboardingMeetups"
        static let onboardingSpeakersImageName = "OnboardingMeetups"
        static let onboardingPriceImageName = "OnboardingMeetups"
        
        static let onboardingMeetupsTitle = localized("ONBOARDING_MEETUPS_TITLE")
        static let onboardingSpeakersTitle = localized("ONBOARDING_SPEAKERS_TITLE")
        static let onboardingPriceTitle = localized("ONBOARDING_PRICE_TITLE")
        
        static let onboardingMeetupsDescription = localized("ONBOARDING_MEETUPS_DESCRIPTION")
        static let onboardingSpeakersDescription = localized("ONBOARDING_MEETUPS_DESCRIPTION")
        static let onboardingPriceDescription = localized("ONBOARDING_MEETUPS_DESCRIPTION")
    }

    weak var delegate: OnboardingViewControllerCoordinatorDelegate?

    var currentPageObservable = Observable<Int>(0)
    var continueButtonTitleObservable = Observable<String>(Constants.onboardingContinueTitle)
    var onboardingCardsObservable = Observable<[OnboardingCardModel]>([])
    
    private var maxCardIndex = 0

    init(delegate: OnboardingViewControllerCoordinatorDelegate?) {
        self.delegate = delegate
        
        let cards = [OnboardingCardModel(imageName: Constants.onboardingMeetupsImageName,
                      title: Constants.onboardingMeetupsTitle,
                      description: Constants.onboardingMeetupsDescription),
                     OnboardingCardModel(imageName: Constants.onboardingSpeakersImageName,
                      title: Constants.onboardingSpeakersTitle,
                      description: Constants.onboardingSpeakersDescription),
                     OnboardingCardModel(imageName: Constants.onboardingPriceImageName,
                      title: Constants.onboardingPriceTitle,
                      description: Constants.onboardingPriceDescription)]

        maxCardIndex = cards.count - 1
        onboardingCardsObservable.next(cards)
    }

    @objc func continueButtonTapped() {
        if continueButtonTitleObservable.value == Constants.onboardingContinueTitle {
            currentPageObservable.next(currentPageObservable.value + 1)
            detectCountinueButtonTitleChange()
        } else {
            delegate?.onboardingHasCompleted()
        }
    }

    func swipeDidFinish(with page: Int) {
        currentPageObservable.next(page)
        detectCountinueButtonTitleChange()
    }
    
    private func detectCountinueButtonTitleChange() {
        if continueButtonTitleObservable.value == Constants.onboardingContinueTitle && currentPageObservable.value == maxCardIndex {
            continueButtonTitleObservable.next(Constants.onboardingFinishTitle)
        } else if continueButtonTitleObservable.value == Constants.onboardingFinishTitle && currentPageObservable.value < maxCardIndex {
            continueButtonTitleObservable.next(Constants.onboardingContinueTitle)
        }
    }
}
