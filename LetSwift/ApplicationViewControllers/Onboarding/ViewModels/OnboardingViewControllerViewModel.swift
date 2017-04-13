//
//  OnboardingViewControllerViewModel.swift
//  LetSwift
//
//  Created by Marcin Chojnacki, Kinga Wilczek on 13.04.2017.
//  Copyright © 2017 Droids On Roids. All rights reserved.
//

import UIKit

final class OnboardingViewControllerViewModel {

    weak var delegate: OnboardingViewControllerDelegate?
    var currentPage = Observable<Int>(0)

    init(delegate: OnboardingViewControllerDelegate?) {
        self.delegate = delegate
    }

    @objc func continueButtonTapped() {
        currentPage.next(currentPage.value + 1)
    }

    func swipeDidFinish(with page: Int) {
        currentPage.next(page)
    }
}
