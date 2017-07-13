//
//  AppLabel.swift
//  LetSwift
//
//  Created by Marcin Chojnacki on 10.07.2017.
//  Copyright © 2017 Droids On Roids. All rights reserved.
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
