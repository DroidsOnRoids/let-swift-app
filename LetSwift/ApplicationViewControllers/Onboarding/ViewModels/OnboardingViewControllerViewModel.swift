//
//  OnboardingViewControllerViewModel.swift
//  LetSwift
//
//  Created by Marcin Chojnacki, Kinga Wilczek on 13.04.2017.
//  Copyright © 2017 Droids On Roids. All rights reserved.
//

import Foundation

final class OnboardingViewControllerViewModel {

    weak var delegate: OnboardingViewControllerDelegate?

    var currentPageObservable = Observable<Int>(0)
    var continueButtonTitleObservable = Observable<String>(localized("ONBOARDING_CONTINUE").uppercased())
    var onboardingCardsObservable = Observable<[OnboardingCardModel]>([])
    
    private let continuesButtonTitles = [localized("ONBOARDING_CONTINUE").uppercased(),
                                         localized("ONBOARDING_FINISH").uppercased()]

    init(delegate: OnboardingViewControllerDelegate?) {
        self.delegate = delegate
        
        let cards = [(imageName: "OnboardingMeetups",
                      title: localized("ONBOARDING_MEETUPS_TITLE"),
                      description: localized("ONBOARDING_MEETUPS_DESCRIPTION"),
                      page: 0),
                     (imageName: "OnboardingSpeakers",
                      title: localized("ONBOARDING_SPEAKERS_TITLE"),
                      description: localized("ONBOARDING_SPEAKERS_DESCRIPTION"),
                      page: 1),
                     (imageName: "OnboardingPrice",
                      title: localized("ONBOARDING_PRICE_TITLE"),
                      description: localized("ONBOARDING_PRICE_DESCRIPTION"),
                      page: 2)]

        onboardingCardsObservable.next(cards)
    }

    @objc func continueButtonTapped() {
        currentPageObservable.next(currentPageObservable.value + 1)
        detectCountinueButtonTitleChange()
    }

    func swipeDidFinish(with page: Int) {
        currentPageObservable.next(page)
        detectCountinueButtonTitleChange()
    }
    
    private func detectCountinueButtonTitleChange() {
        if continueButtonTitleObservable.value == continuesButtonTitles[0] && currentPageObservable.value == 2 {
            continueButtonTitleObservable.next(continuesButtonTitles[1])
        } else if continueButtonTitleObservable.value == continuesButtonTitles[1] && currentPageObservable.value < 2 {
            continueButtonTitleObservable.next(continuesButtonTitles[0])
        }
    }
}
