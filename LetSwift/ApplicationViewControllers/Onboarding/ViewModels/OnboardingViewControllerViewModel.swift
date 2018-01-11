//
//  OnboardingViewControllerViewModel.swift
//  LetSwift
//
//  Created by Marcin Chojnacki, Kinga Wilczek on 13.04.2017.
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
import CoreGraphics

struct OnboardingCardModel {
    
    let imageName: String
    let title: String
    let description: String
}

final class OnboardingViewControllerViewModel {
    
    private enum Constants {
        static let onboardingContinueTitle = localized("ONBOARDING_CONTINUE").uppercased()
        static let onboardingFinishTitle = localized("ONBOARDING_FINISH").uppercased()
    }

    weak var delegate: OnboardingViewControllerCoordinatorDelegate?
    
    let pageRequestObservable = Observable<Int>(0)
    let currentPageObservable = Observable<Int>(0)
    let pageWidthObservable = Observable<CGFloat>(0.0)
    let contentOffsetObservable = Observable<CGFloat>(0.0)
    let currentIconObservable = Observable<String?>(nil)
    let iconAlphaObservable = Observable<CGFloat>(1.0)
    let continueButtonTitleObservable = Observable<String>(Constants.onboardingContinueTitle)
    let onboardingCardsObservable = Observable<[OnboardingCardModel]>(EventBranding.current.onboardingCards)
    
    private let disposeBag = DisposeBag()
    
    init(delegate: OnboardingViewControllerCoordinatorDelegate?) {
        self.delegate = delegate
        setup()
    }
    
    private func setup() {
        currentPageObservable.subscribeNext { [weak self] page in
            guard let weakSelf = self, page < weakSelf.onboardingCardsObservable.value.count else { return }
            
            weakSelf.currentIconObservable.next(weakSelf.onboardingCardsObservable.value[page].imageName)
            
            let isOnLastPage = page >= weakSelf.onboardingCardsObservable.value.count - 1
            weakSelf.continueButtonTitleObservable.next(isOnLastPage ? Constants.onboardingFinishTitle : Constants.onboardingContinueTitle)
        }
        .add(to: disposeBag)
        
        contentOffsetObservable.subscribeNext { [weak self] offset in
            guard let weakSelf = self else { return }
            
            weakSelf.iconAlphaObservable.next(weakSelf.alphaValue(for: offset))
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
    
    private func alphaValue(for offset: CGFloat) -> CGFloat {
        let halfWidth = pageWidthObservable.value / 2.0
        var result = abs(offset.truncatingRemainder(dividingBy: pageWidthObservable.value))
        
        if result > halfWidth {
            result -= 2.0 * (result - halfWidth)
        }
        
        result /= halfWidth
        result = 1.0 - result
        
        return result
    }
}
