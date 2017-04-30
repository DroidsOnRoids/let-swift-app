//
//  AppShadowButton.swift
//  LetSwift
//
//  Created by Kinga Wilczek, Marcin Chojnacki on 20.04.2017.
//  Copyright © 2017 Droids On Roids. All rights reserved.
//

import UIKit

final class AppShadowButton: UIButton {
    
    private enum Constants {
        static let shadowHorizontalInset: CGFloat = 10.0
        static let shadowHeight: CGFloat = 20.0
    }
    
    override var bounds: CGRect {
        didSet {
            if shadowVisible {
                updateShadowPath()
            }
        }
    }
    
    override var backgroundColor: UIColor? {
        didSet {
            layer.shadowColor = backgroundColor?.cgColor
        }
    }
    
    override var isHighlighted: Bool {
        didSet {
            if self.shadowVisible {
                self.layer.shadowOpacity = isHighlighted ? 0.5 : 1.0
            }
            
            highlightView(isHighlighted)
        }
    }
    
    @IBInspectable
    var shadowVisible: Bool = false {
        didSet {
            if shadowVisible {
                layer.shadowColor = backgroundColor?.cgColor
                layer.shadowOpacity = 1.0
                layer.shadowOffset = .zero
                layer.shadowRadius = 10.0
                
                updateShadowPath()
            } else {
                layer.shadowOpacity = 0.0
            }
        }
    }
    
    private func updateShadowPath() {
        let shadowRect = CGRect(x: Constants.shadowHorizontalInset, y: bounds.height - Constants.shadowHeight, width: bounds.width - Constants.shadowHorizontalInset * 2.0, height: Constants.shadowHeight)
        layer.shadowPath = UIBezierPath(rect: shadowRect).cgPath
    }
}
