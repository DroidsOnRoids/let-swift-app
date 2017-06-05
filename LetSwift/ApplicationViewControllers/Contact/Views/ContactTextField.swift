//
//  AppTextField.swift
//  LetSwift
//
//  Created by Marcin Chojnacki on 01.06.2017.
//  Copyright © 2017 Droids On Roids. All rights reserved.
//

import UIKit

final class ContactTextField: UITextField {
    
    let textObservable = Observable<String>("")
    
    weak var associatedErrorView: UIView?
    
    var fieldState = ContactFieldState.normal {
        didSet {
            setupFieldState()
        }
    }
    
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
        addTarget(self, action: #selector(textFieldDidChange), for: .editingChanged)
        setupFieldState()
        setupPlaceholder()
    }
    
    private func setupFieldState() {
        layer.borderColor = fieldState.borderColor.cgColor
        associatedErrorView?.isHidden = fieldState != .error
    }
    
    private func setupPlaceholder() {
        guard let placeholder = placeholder else { return }
        if let placeholderColor = placeholderColor {
            attributedPlaceholder = placeholder.attributed(withColor: placeholderColor)
        } else {
            attributedPlaceholder = placeholder.attributed()
        }
    }
    
    @objc private func textFieldDidChange() {
        textObservable.next(text ?? "")
    }
}

extension ContactTextField: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        let nextTag = textField.tag + 1
        if let nextResponder = textField.superview?.viewWithTag(nextTag) {
            nextResponder.becomeFirstResponder()
        } else {
            textField.resignFirstResponder()
        }
        
        return false
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        fieldState = .editing
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        fieldState = .normal
    }
}
