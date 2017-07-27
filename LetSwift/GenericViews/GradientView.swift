//
//  GradientView.swift
//  LetSwift
//
//  Created by Marcin Chojnacki on 27.07.2017.
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

final class GradientView: UIView {
    
    private enum Constants {
        static let locations = [0.4, 1.0]
        static let colors = [#colorLiteral(red: 0, green: 0, blue: 0, alpha: 0.1), #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)]
    }
    
    private let gradient = CAGradientLayer()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        setup()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        gradient.frame = bounds
    }
    
    private func setup() {
        gradient.locations = Constants.locations as [NSNumber]
        gradient.colors = Constants.colors.map { $0.cgColor }
        
        layer.insertSublayer(gradient, at: 0)
    }
}
