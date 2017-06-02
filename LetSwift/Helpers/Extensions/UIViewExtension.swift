//
//  UIViewExtension.swift
//  LetSwift
//
//  Created by Marcin Chojnacki on 30.04.2017.
//  Copyright © 2017 Droids On Roids. All rights reserved.
//

import UIKit

extension UIView {
    private enum Constants {
        static let motionEffectForTranslationX = "layer.transform.translation.x"
        static let motionEffectForTranslationY = "layer.transform.translation.y"
    }

    func highlightView(_ isHighlighted: Bool) {
        UIView.animate(withDuration: 0.05) {
            self.transform = isHighlighted ? CGAffineTransform(translationX: 0.0, y: 2.0) : .identity
            self.alpha = isHighlighted ? 0.75 : 1.0
        }
    }

    func addParallax() {
        let amount = 10

        let horizontal = UIInterpolatingMotionEffect(keyPath: Constants.motionEffectForTranslationX, type: .tiltAlongHorizontalAxis)
        horizontal.minimumRelativeValue = -amount
        horizontal.maximumRelativeValue = amount

        let vertical = UIInterpolatingMotionEffect(keyPath: Constants.motionEffectForTranslationY, type: .tiltAlongVerticalAxis)
        vertical.minimumRelativeValue = -amount
        vertical.maximumRelativeValue = amount

        let group = UIMotionEffectGroup()
        group.motionEffects = [horizontal, vertical]
        addMotionEffect(group)
    }
}
