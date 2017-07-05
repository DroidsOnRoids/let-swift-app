//
//  OnboardingCardView.swift
//  LetSwift
//
//  Created by Marcin Chojnacki, Kinga Wilczek on 13.04.2017.
//  Copyright © 2017 Droids On Roids. All rights reserved.
//

import UIKit

typealias OnboardingCardModel = (imageName: String, title: String, description: String)

final class OnboardingCardView: DesignableView {
    
    @IBOutlet private weak var titleLabel: UILabel!
    @IBOutlet private weak var descriptionLabel: MultiSizeLabel!
    
    func setData(with model: OnboardingCardModel) {
        titleLabel.text = model.title
        descriptionLabel.text = model.description
    }
}
