//
//  OnboardingViewControllerViewModel.swift
//  LetSwift
//
//  Created by Marcin Chojnacki, Kinga Wilczek on 13.04.2017.
//  Copyright © 2017 Droids On Roids. All rights reserved.
//

import Foundation

final class OnboardingViewControllerViewModel {

    weak var delegate: OnboardingViewControllerCoordinatorDelegate?

    var currentPageObservable = Observable<Int>(0)
    var continueButtonTitleObservable = Observable<String>(localized("ONBOARDING_CONTINUE").uppercased())
    var onboardingCardsObservable = Observable<[OnboardingCardModel]>([])
    
    private var maxCardIndex = 0
    private let continuesButtonTitles = [localized("ONBOARDING_CONTINUE").uppercased(),
                                         localized("ONBOARDING_FINISH").uppercased()]

    init(delegate: OnboardingViewControllerCoordinatorDelegate?) {
        self.delegate = delegate
        
        let cards = [OnboardingCardModel(imageName: "OnboardingMeetups",
                      title: localized("ONBOARDING_MEETUPS_TITLE"),
                      description: localized("ONBOARDING_MEETUPS_DESCRIPTION")),
                     OnboardingCardModel(imageName: "OnboardingSpeakers",
                      title: localized("ONBOARDING_SPEAKERS_TITLE"),
                      description: localized("ONBOARDING_SPEAKERS_DESCRIPTION")),
                     OnboardingCardModel(imageName: "OnboardingPrice",
                      title: localized("ONBOARDING_PRICE_TITLE"),
                      description: localized("ONBOARDING_PRICE_DESCRIPTION"))]

        maxCardIndex = cards.count - 1
        onboardingCardsObservable.next(cards)
    }

    @objc func continueButtonTapped() {
        guard let countinueButtonTitle = continuesButtonTitles.first else { return }
        if continueButtonTitleObservable.value == countinueButtonTitle {
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
        if continueButtonTitleObservable.value == continuesButtonTitles[0] && currentPageObservable.value == maxCardIndex {
            continueButtonTitleObservable.next(continuesButtonTitles[1])
        } else if continueButtonTitleObservable.value == continuesButtonTitles[1] && currentPageObservable.value < maxCardIndex {
            continueButtonTitleObservable.next(continuesButtonTitles[0])
        }
    }
}
