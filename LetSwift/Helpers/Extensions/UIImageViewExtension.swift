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

        let startColor = UIColor(colorLiteralRed: 0.0, green: 0.0, blue: 0.0, alpha: 0.1)
        let endColor = UIColor.black

        gradient.locations = locations
        gradient.colors = [startColor.cgColor, endColor.cgColor]
        layer.insertSublayer(gradient, at: 0)
    }
}
