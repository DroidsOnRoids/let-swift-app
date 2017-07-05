//
//  MultilayerImageView.swift
//  LetSwift
//
//  Created by Marcin Chojnacki on 05.07.2017.
//  Copyright © 2017 Droids On Roids. All rights reserved.
//

import UIKit

class MultilayerImageView: UIView {
    
    var layers: [UIImageView] {
        return subviews as? [UIImageView] ?? []
    }
    
    func addLayers(_ layers: [UIImage]) {
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
            pinToCenter(view: $0, widthRatio: widthRatio, heightRatio: heightRatio)
        }
    }
    
    func removeAllLayers() {
        subviews.forEach { $0.removeFromSuperview() }
    }
    
    private func pinToCenter(view: UIView, widthRatio: CGFloat = 1.0, heightRatio: CGFloat = 1.0) {
        view.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
        view.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        view.widthAnchor.constraint(equalTo: widthAnchor, multiplier: widthRatio).isActive = true
        view.heightAnchor.constraint(equalTo: heightAnchor, multiplier: heightRatio).isActive = true
    }
}
