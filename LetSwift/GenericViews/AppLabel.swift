//
//  AppLabel.swift
//  LetSwift
//
//  Created by Marcin Chojnacki on 10.07.2017.
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

final class AppLabel: UILabel {
    
    private enum Constants {
        static let invalidValue: CGFloat = -1.0
    }
    
    @IBInspectable
    var letterSpacing: CGFloat = Constants.invalidValue {
        didSet {
            updateTextAttributes()
        }
    }
    
    @IBInspectable
    var lineHeight: CGFloat = Constants.invalidValue {
        didSet {
            updateTextAttributes()
        }
    }
    
    override var text: String? {
        didSet {
            updateTextAttributes()
        }
    }
    
    private func updateTextAttributes() {
        guard var attributed = text?.attributed() else { return }
        
        if letterSpacing >= 0.0 {
            attributed = attributed.with(spacing: letterSpacing)
        }
        
        if lineHeight >= 0.0 {
            attributed = attributed.with(lineSpacing: lineHeight / 4.5)
        }
        
        attributedText = attributed
    }
}
