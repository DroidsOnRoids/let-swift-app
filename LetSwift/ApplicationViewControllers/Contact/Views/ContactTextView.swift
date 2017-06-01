//
//  ContactTextView.swift
//  LetSwift
//
//  Created by Marcin Chojnacki on 01.06.2017.
//  Copyright © 2017 Droids On Roids. All rights reserved.
//

import UIKit

final class ContactTextView: UITextView {
    
    weak var associatedErrorView: UIView?
    var fieldState = ContactFieldState.normal {
        didSet {
            setupFieldState()
        }
    }
    
    override init(frame: CGRect, textContainer: NSTextContainer?) {
        super.init(frame: frame, textContainer: textContainer)
        setup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
    }

    private func setup() {
        delegate = self
        setupFieldState()
    }
    
    private func setupFieldState() {
        layer.borderColor = fieldState.borderColor.cgColor
        associatedErrorView?.isHidden = fieldState != .error
    }
}

extension ContactTextView: UITextViewDelegate {
    func textViewDidBeginEditing(_ textView: UITextView) {
        /*if textView.text == messagePlaceholder {
            textView.text = ""
        }*/
        fieldState = .editing
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        /*if textView.text == "" {
            textView.text = messagePlaceholder
        }*/
        fieldState = .normal
    }
}
