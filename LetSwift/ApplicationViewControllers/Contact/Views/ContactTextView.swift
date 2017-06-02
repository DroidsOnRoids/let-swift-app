//
//  ContactTextView.swift
//  LetSwift
//
//  Created by Marcin Chojnacki on 01.06.2017.
//  Copyright © 2017 Droids On Roids. All rights reserved.
//

import UIKit

final class ContactTextView: UITextView {
    
    private enum Constants {
        static let verticalInset: CGFloat = 16.0
        static let horizontalInset: CGFloat = 12.0
        static let insetLabelOffset: CGFloat = 5.0
    }
    
    weak var associatedErrorView: UIView?
    
    var fieldState = ContactFieldState.normal {
        didSet {
            setupFieldState()
        }
    }
    
    var placeholder: String? {
        didSet {
            setupPlaceholderLabel()
        }
    }
    
    fileprivate let placeholderLabel = UILabel()
    
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
        textContainerInset = UIEdgeInsets(top: Constants.verticalInset, left: Constants.horizontalInset, bottom: Constants.verticalInset, right: Constants.horizontalInset)
        
        setupFieldState()
        setupPlaceholderLabel()
    }
    
    private func setupFieldState() {
        layer.borderColor = fieldState.borderColor.cgColor
        associatedErrorView?.isHidden = fieldState != .error
    }
    
    private func setupPlaceholderLabel() {
        placeholderLabel.attributedText = placeholder?.attributed(withAttributes: typingAttributes)
        attributedText = nil
        
        placeholderLabel.sizeToFit()
        placeholderLabel.frame.origin.x = textContainerInset.left + Constants.insetLabelOffset
        placeholderLabel.frame.origin.y = textContainerInset.top
        
        placeholderLabel.isHidden = !text.isEmpty
        
        if !placeholderLabel.isDescendant(of: self) {
            addSubview(placeholderLabel)
        }
    }
}

extension ContactTextView: UITextViewDelegate {
    func textViewDidBeginEditing(_ textView: UITextView) {
        fieldState = .editing
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        fieldState = .normal
    }
    
    func textViewDidChange(_ textView: UITextView) {
         placeholderLabel.isHidden = !textView.text.isEmpty
    }
}
