//
//  AppTextField.swift
//  LetSwift
//
//  Created by Marcin Chojnacki on 01.06.2017.
//  Copyright © 2017 Droids On Roids. All rights reserved.
//

import UIKit

final class AppTextField: UITextField {
    
    @IBInspectable var inset: CGFloat = 0.0
    
    @IBInspectable var placeholderColor: UIColor? {
        didSet {
            setupPlaceholder()
        }
    }
    
    override var placeholder: String? {
        didSet {
            setupPlaceholder()
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
    
    override func textRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.insetBy(dx: inset, dy: 0.0)
    }
    
    override func editingRect(forBounds bounds: CGRect) -> CGRect {
        return textRect(forBounds: bounds)
    }

    private func setup() {
        delegate = self
        setupPlaceholder()
    }
    
    private func setupPlaceholder() {
        guard let placeholder = placeholder else { return }
        if let placeholderColor = placeholderColor {
            attributedPlaceholder = placeholder.attributed(withColor: placeholderColor)
        } else {
            attributedPlaceholder = placeholder.attributed()
        }
    }
}

extension AppTextField: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        let nextTag = textField.tag + 1
        if let nextResponder = textField.superview?.viewWithTag(nextTag) {
            nextResponder.becomeFirstResponder()
        } else {
            textField.resignFirstResponder()
        }
        
        return false
    }
}
