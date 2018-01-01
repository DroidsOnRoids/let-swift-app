//
//  OnboardingImageView.swift
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

final class OnboardingImageView: MultilayerImageView {
    
    private enum OnboardingLayers: Int {
        case shapes
        case outerCircle
        case innerCircle
        case yellowCircle
        case icon
        
        static var allLayers: [OnboardingLayers] {
            return [.shapes, .outerCircle, .innerCircle, .yellowCircle, .icon]
        }
        
        var image: UIImage {
            switch self {
            case .shapes: return #imageLiteral(resourceName: "OnboardingShapes")
            case .outerCircle: return #imageLiteral(resourceName: "OnboardingOuterCircle")
            case .innerCircle: return #imageLiteral(resourceName: "OnboardingInnerCircle")
            case .yellowCircle: return #imageLiteral(resourceName: "OnboardingCircle").tinted(with: EventBranding.current.color)
            case .icon: return #imageLiteral(resourceName: "OnboardingPrice")
            }
        }
    }
    
    var circlesRotation: CGFloat = 0.0 {
        didSet {
            layers[OnboardingLayers.outerCircle.rawValue].transform = CGAffineTransform(rotationAngle: circlesRotation)
            layers[OnboardingLayers.innerCircle.rawValue].transform = CGAffineTransform(rotationAngle: circlesRotation * 0.5)
        }
    }
    
    var whiteIconImage: UIImage? {
        get {
            return layers[OnboardingLayers.icon.rawValue].image
        }
        set {
            return layers[OnboardingLayers.icon.rawValue].image = newValue
        }
    }
    
    var whiteIconAlpha: CGFloat {
        get {
            return layers[OnboardingLayers.icon.rawValue].alpha
        }
        set {
            return layers[OnboardingLayers.icon.rawValue].alpha = newValue
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
    }
    
    private func setup() {
        setLayers(OnboardingLayers.allLayers.map { $0.image })
        setupParallax()
    }
    
    private func setupParallax() {
        layers.enumerated().forEach { index, element in
            let reversedIndex = layers.count - index
            element.addParallax(amount: reversedIndex * 5)
        }
    }
}
