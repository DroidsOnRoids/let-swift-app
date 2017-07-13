//
//  SpinnerView.swift
//  LetSwift
//
//  Created by Marcin Chojnacki on 19.05.2017.
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

final class SpinnerView: UIView {
    
    private enum Constants {
        static let animationDuration = 2.0
        static let animationKey = "rotation"
    }
    
    private let spinnerImageView = UIImageView(image: #imageLiteral(resourceName: "Spinner"))
    
    lazy var animation: CABasicAnimation = {
        var animation = CABasicAnimation(keyPath: "transform.rotation.z")
        animation.toValue = .pi * 2.0
        animation.repeatCount = .infinity
        animation.duration = Constants.animationDuration
        animation.isRemovedOnCompletion = false
        
        return animation
    }()
    
    var animationActive = true {
        didSet {
            if animationActive {
                startAnimation()
            }
        }
    }

    var image = #imageLiteral(resourceName: "Spinner") {
        didSet {
            spinnerImageView.image = image
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
        backgroundColor = .white
        
        spinnerImageView.translatesAutoresizingMaskIntoConstraints = false
        addSubview(spinnerImageView)
        
        spinnerImageView.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
        spinnerImageView.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        
        startAnimation()
    }
    
    private func startAnimation() {
        spinnerImageView.layer.add(animation, forKey: Constants.animationKey)
    }
}
