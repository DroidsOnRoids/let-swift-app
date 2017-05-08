//
//  UIViewExtension.swift
//  LetSwift
//
//  Created by Marcin Chojnacki on 30.04.2017.
//  Copyright © 2017 Droids On Roids. All rights reserved.
//

import UIKit

extension UIView {
    func highlightView(_ isHighlighted: Bool) {
        UIView.animate(withDuration: 0.05) {
            self.transform = isHighlighted ? CGAffineTransform(translationX: 0.0, y: 2.0) : .identity
            self.alpha = isHighlighted ? 0.75 : 1.0
        }
    }

    func constraint(withIdentifier: String) -> NSLayoutConstraint? {
        return self.constraints.filter { $0.identifier == withIdentifier }.first
    }
}
