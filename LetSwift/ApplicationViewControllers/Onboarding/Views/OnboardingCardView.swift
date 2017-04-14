//
//  OnboardingCardView.swift
//  LetSwift
//
//  Created by Marcin Chojnacki, Kinga Wilczek on 13.04.2017.
//  Copyright © 2017 Droids On Roids. All rights reserved.
//

import UIKit

struct OnboardingCardModel {
    let imageName: String
    let title: String
    let description: String
    let page: Int
}

final class OnboardingCardView: DesignableView {

    @IBOutlet private weak var onboardingImageView: UIImageView!
    @IBOutlet private weak var titleLabel: UILabel!
    @IBOutlet private weak var descriptionLabel: MultiSizeLabel!
    @IBOutlet private weak var onboardingPageControl: UIPageControl!
    
    func setData(with model: OnboardingCardModel) {
        onboardingImageView.image =  UIImage(named: model.imageName)
        titleLabel.text = model.title
        descriptionLabel.text = model.description
        onboardingPageControl.currentPage = model.page
    }
}
