//
//  UIButtonExtension.swift
//  LetSwift
//
//  Created by Kinga Wilczek on 20.04.2017.
//  Copyright © 2017 Droids On Roids. All rights reserved.
//

import UIKit

extension UIButton {
    func showAppShadow() {
        layer.cornerRadius = 6.0
        
        layer.shadowColor = backgroundColor?.cgColor
        layer.shadowOpacity = 0.6
        layer.shadowRadius = 10
        layer.shadowOffset = CGSize(width: 0.0, height: 6.0)
        
        let shadowRect = bounds.insetBy(dx: 10, dy: 0)
        layer.shadowPath = UIBezierPath(rect: shadowRect).cgPath
    }
}
