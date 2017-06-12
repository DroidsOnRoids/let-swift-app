//
//  TopicButton.swift
//  LetSwift
//
//  Created by Marcin Chojnacki on 02.06.2017.
//  Copyright © 2017 Droids On Roids. All rights reserved.
//

import UIKit

final class TopicButton: UIButton, ContactFieldBaseProtocol {
    
    weak var associatedErrorView: UIView?
    
    var fieldState = ContactFieldState.normal {
        didSet {
            setupFieldState()
        }
    }
    
    override var isHighlighted: Bool {
        didSet {
            fieldState = isHighlighted ? .editing : .normal
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
        setupFieldState()
    }
    
    private func setupFieldState() {
        layer.borderColor = fieldState.borderColor.cgColor
        associatedErrorView?.isHidden = fieldState != .error
    }
}
