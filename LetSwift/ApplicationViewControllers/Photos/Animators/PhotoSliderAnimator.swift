//
//  PhotoSliderAnimator.swift
//  LetSwift
//
//  Created by Marcin Chojnacki on 22.06.2017.
//  Copyright © 2017 Droids On Roids. All rights reserved.
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
        static let progressThreshold = 0.5
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
        newFrame.origin.y *= progress > 0.0 ? 0.25 : 1.75
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
        }) { _ in
            self.delegate?.finishDismissing()
        }
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
