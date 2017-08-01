//
//  UIViewExtension.swift
//  LetSwift
//
//  Created by Marcin Chojnacki on 30.04.2017.
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

import UIKit

extension UIView {
    private enum Constants {
        static let pressEffectEnabled = false
        static let motionEffectForTranslationX = "layer.transform.translation.x"
        static let motionEffectForTranslationY = "layer.transform.translation.y"
    }

    func highlightView(_ isHighlighted: Bool) {
        UIView.animate(withDuration: 0.05) {
            if Constants.pressEffectEnabled {
                self.transform = isHighlighted ? CGAffineTransform(translationX: 0.0, y: 2.0) : .identity
            }
            
            self.alpha = isHighlighted ? 0.6 : 1.0
        }
    }

    func addParallax(amount: Int = 10) {
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

    func addShadow(withColor color: CGColor = UIColor.black.cgColor, opacity: Float = 0.5, offset: CGSize = CGSize(width: 0.0, height: 2.0), radius: CGFloat = 5.0) {
        layer.shadowColor = color
        layer.shadowOpacity = opacity
        layer.shadowOffset = offset
        layer.shadowRadius = radius
    }
    
    func pinToFit(view: UIView) {
        leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
    }

    func pinToFit(view: UIView, with margins: UIEdgeInsets) {
        leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: margins.left).isActive = true
        trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: margins.right).isActive = true
        topAnchor.constraint(equalTo: view.topAnchor, constant: margins.top).isActive = true
        bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -margins.bottom).isActive = true
    }
    
    func pinToCenter(view: UIView, widthRatio: CGFloat = 1.0, heightRatio: CGFloat = 1.0) {
        centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: widthRatio).isActive = true
        heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: heightRatio).isActive = true
    }
    
    func pinToCenter(view: UIView, width: CGFloat, height: CGFloat) {
        centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        widthAnchor.constraint(equalToConstant: width).isActive = true
        heightAnchor.constraint(equalToConstant: height).isActive = true
    }

    override open func awakeFromNib() {
        super.awakeFromNib()

        isExclusiveTouch = true
    }
}
