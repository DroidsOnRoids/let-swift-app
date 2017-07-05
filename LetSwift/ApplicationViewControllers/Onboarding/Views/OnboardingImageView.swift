//
//  OnboardingImageView.swift
//  LetSwift
//
//  Created by Marcin Chojnacki on 05.07.2017.
//  Copyright © 2017 Droids On Roids. All rights reserved.
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
            case .yellowCircle: return #imageLiteral(resourceName: "OnboardingCircle")
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
        addLayers(OnboardingLayers.allLayers.map { $0.image })
    }
}
