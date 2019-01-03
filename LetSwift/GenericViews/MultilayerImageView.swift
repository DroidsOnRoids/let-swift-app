//
//  MultilayerImageView.swift
//  LetSwift
//
//  Created by Marcin Chojnacki on 05.07.2017.
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

class MultilayerImageView: UIView {
    
    var layers: [UIImageView] {
        return subviews.compactMap { $0 as? UIImageView }
    }
    
    func setLayers(_ layers: [UIImage]) {
        removeAllLayers()
        
        let imageViews = layers.map { UIImageView(image: $0) }
        guard let parentImageView = imageViews.first else { return }
        
        imageViews.forEach {
            $0.contentMode = .scaleAspectFit
            $0.translatesAutoresizingMaskIntoConstraints = false
            addSubview($0)
        }
        
        parentImageView.pinToFit(view: self)
        
        imageViews.tail.forEach {
            guard let parentImage = parentImageView.image, let image = $0.image else { return }
            let widthRatio = image.size.width / parentImage.size.width
            let heightRatio = image.size.height / parentImage.size.height
            $0.pinToCenter(view: self, widthRatio: widthRatio, heightRatio: heightRatio)
        }
    }
    
    func removeAllLayers() {
        subviews.forEach { $0.removeFromSuperview() }
    }
}
