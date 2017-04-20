//
//  AppShadowButton.swift
//  LetSwift
//
//  Created by Kinga Wilczek on 20.04.2017.
//  Copyright © 2017 Droids On Roids. All rights reserved.
//

import UIKit

final class AppShadowButton: UIButton {
    
    override var isHighlighted: Bool {
        didSet {
            let onNormal = {
                self.showShadow()
                self.transform = .identity
            }
            
            let onHighlighted = {
                self.hideShadow()
                self.transform = CGAffineTransform(translationX: 0.0, y: 2.0)
            }
            
            isHighlighted ? onHighlighted() : onNormal()
        }
    }
}
