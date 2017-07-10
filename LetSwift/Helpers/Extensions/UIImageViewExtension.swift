//
//  UIImageViewExtension.swift
//  LetSwift
//
//  Created by Kinga Wilczek on 16.06.2017.
//  Copyright © 2017 Droids On Roids. All rights reserved.
//

import UIKit

extension UIImageView {
    func addGradientShadow(with locations: [NSNumber]? = nil) {
        let gradient = CAGradientLayer()
        gradient.frame = bounds

        let startColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 0.1)
        let endColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)

        gradient.locations = locations
        gradient.colors = [startColor.cgColor, endColor.cgColor]
        layer.sublayers?.forEach { $0.removeFromSuperlayer() }
        layer.insertSublayer(gradient, at: 0)
    }

    func removeAllLayers() {
        layer.sublayers?.forEach { $0.removeFromSuperlayer() }
    }
}
