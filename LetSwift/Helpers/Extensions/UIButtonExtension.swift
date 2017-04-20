//
//  UIButtonExtension.swift
//  LetSwift
//
//  Created by Kinga Wilczek on 20.04.2017.
//  Copyright © 2017 Droids On Roids. All rights reserved.
//

import UIKit

extension UIButton {
    func showShadow() {
        layer.shadowColor = backgroundColor?.cgColor
        layer.shadowOpacity = 0.6
        layer.shadowRadius = 10.0
        layer.shadowOffset = CGSize(width: 0.0, height: 6.0)
        
        let shadowRect = bounds.insetBy(dx: 10.0, dy: 0.0)
        layer.shadowPath = UIBezierPath(rect: shadowRect).cgPath
    }
    
    func hideShadow() {
        layer.shadowColor = nil
        layer.shadowOpacity = 0.0
        layer.shadowPath = nil
    }
}
