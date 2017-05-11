//
//  AttendButtonsRowCell.swift
//  LetSwift
//
//  Created by Marcin Chojnacki on 26.04.2017.
//  Copyright © 2017 Droids On Roids. All rights reserved.
//

import UIKit

final class AttendButtonsRowCell: UITableViewCell {

    @IBOutlet private weak var attendButton: AppShadowButton!
    @IBOutlet private weak var remindButton: AppShadowButton!
    @IBOutlet private weak var currentEventConstraint: NSLayoutConstraint!
    @IBOutlet private weak var pastEventConstraint: NSLayoutConstraint!
    
    private enum Constants {
        static let lowPriorityConstraint: Float = 250.0
        static let highPriorityContraint: Float = 999.0
    }
    
    var isLeftButtonActive = true {
        didSet {
            attendButton.backgroundColor = isLeftButtonActive ? .swiftOrange : .paleGrey
            attendButton.isEnabled = isLeftButtonActive
        }
    }
    
    var isRightButtonVisible = true {
        didSet {
            if isRightButtonVisible {
                currentEventConstraint.priority = Constants.highPriorityContraint
                pastEventConstraint.priority = Constants.lowPriorityConstraint
            } else {
                currentEventConstraint.priority = Constants.lowPriorityConstraint
                pastEventConstraint.priority = Constants.highPriorityContraint
            }
            
            UIView.animate(withDuration: 0.2) {
                self.remindButton.isHidden = !self.isRightButtonVisible
                self.layoutIfNeeded()
            }
        }
    }
    
    var leftButtonTitle: String {
        get {
            return attendButton.currentTitle ?? ""
        }
        set {
            attendButton.setTitle(newValue.uppercased(), for: [])
        }
    }
    
    var rightButtonTitle: String {
        get {
            return remindButton.currentTitle ?? ""
        }
        set {
            remindButton.setTitle(newValue.uppercased(), for: [])
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        remindButton.layer.borderColor = UIColor.swiftOrange.cgColor
    }
    
    func addLeftTapTarget(target: Any?, action: Selector) {
        attendButton.addTarget(target, action: action, for: .touchUpInside)
    }
    
    func addRightTapTarget(target: Any?, action: Selector) {
        remindButton.addTarget(target, action: action, for: .touchUpInside)
    }
}
