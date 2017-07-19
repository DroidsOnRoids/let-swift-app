//
//  UIImageViewExtension.swift
//  LetSwift
//
//  Created by Kinga Wilczek on 16.06.2017.
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
    
    func setImage(url: URL, errorPlaceholder: UIImage) {
        sd_setImage(with: url) { [weak self] newImage, _, _, _ in
            guard newImage == nil else { return }
            self?.image = errorPlaceholder
        }
    }
}
