//
//  PhotoSliderAnimator.swift
//  LetSwift
//
//  Created by Marcin Chojnacki on 22.06.2017.
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

protocol PhotoSliderAnimatorDelegate: class {
    func prepareForInteractiveAnimation()
    func prepareForDismissing()
    func progressDismissing()
    func finishDismissing()
    func prepareForRestore()
}

final class PhotoSliderAnimator {
    
    private enum Constants {
        static let animationDuration = 0.25
        static let progressThreshold: CGFloat = 0.5
        static let lowerTranslationMultiplier: CGFloat = 0.25
        static let upperTranslationMultiplier: CGFloat = 1.75
    }
    
    private weak var delegate: PhotoSliderAnimatorDelegate?
    private var view: UIView
    
    private var initialFrame: CGRect {
        return UIScreen.main.bounds
    }
    
    init(delegate: PhotoSliderAnimatorDelegate, animate view: UIView) {
        self.delegate = delegate
        self.view = view
    }
    
    func interactiveAnimationHasBegan() {
        delegate?.prepareForInteractiveAnimation()
    }
    
    func interactiveAnimationHasChanged(progress: CGFloat, translation: CGPoint) {
        let reversedProgress = 1.0 - abs(progress)
        let alphaInterpolation = min(reversedProgress * 2.0 - 1.0, 1.0)
        let scaleInterpolation = reversedProgress / 4.0 + 0.75
        
        var newFrame = initialFrame.scale(by: scaleInterpolation)
        newFrame.origin.y *= progress > 0.0 ? Constants.lowerTranslationMultiplier : Constants.upperTranslationMultiplier
        newFrame = newFrame.offsetBy(dx: translation.x, dy: translation.y)
        
        view.backgroundColor = UIColor.black.withAlphaComponent(alphaInterpolation)
        view.frame = newFrame
    }
    
    func interactiveAnimationHasEnded(progress: CGFloat) {
        if abs(progress) > Constants.progressThreshold {
            animateToDismiss()
        } else {
            animateToRestore()
        }
    }
    
    func interactiveAnimationHasCancelled() {
        animateToRestore()
    }
    
    func animateToDismiss() {
        delegate?.prepareForDismissing()
        
        UIView.animate(withDuration: Constants.animationDuration, delay: 0.0, options: .curveEaseOut, animations: {
            self.delegate?.progressDismissing()
            self.view.backgroundColor = .clear
            self.view.layoutIfNeeded()
        }, completion: { _ in
            self.delegate?.finishDismissing()
        })
    }
    
    private func animateToRestore() {
        delegate?.prepareForRestore()
        
        UIView.animate(withDuration: Constants.animationDuration, delay: 0.0, options: .curveEaseOut, animations: {
            self.view.backgroundColor = .black
            self.view.frame = self.initialFrame
            self.view.layoutIfNeeded()
        })
    }
}
