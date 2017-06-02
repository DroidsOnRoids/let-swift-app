//
//  TopicButton.swift
//  LetSwift
//
//  Created by Marcin Chojnacki on 02.06.2017.
//  Copyright © 2017 Droids On Roids. All rights reserved.
//

import UIKit

final class TopicButton: UIButton {
    
    private enum Constants {
        static let borderColor: UIColor = .lightBlueGrey
        static let highlightedColor: UIColor = .swiftOrange
    }
    
    override var isHighlighted: Bool {
        didSet {
            layer.borderColor = isHighlighted ? Constants.highlightedColor.cgColor : Constants.borderColor.cgColor
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
        layer.borderColor = Constants.borderColor.cgColor
    }
}
