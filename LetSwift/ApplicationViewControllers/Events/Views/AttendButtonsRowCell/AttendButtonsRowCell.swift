//
//  AttendButtonsRowCell.swift
//  LetSwift
//
//  Created by Marcin Chojnacki on 26.04.2017.
//  Copyright © 2017 Droids On Roids. All rights reserved.
//

import UIKit

final class AttendButtonsRowCell: UITableViewCell {

    @IBOutlet weak var attendButton: AppShadowButton!
    @IBOutlet weak var remindButton: AppShadowButton!

    private enum Constants {
        static let validEventConstraintIdentifier = "ValidEventConstraint"
        static let outOfDateEventConstraintIdentifier = "OutOfDateEventConstraint"
    }
    
    var attendButtonActive = true {
        didSet {
            attendButton.backgroundColor = attendButtonActive ? .swiftOrange : .paleGrey
            attendButton.isEnabled = attendButtonActive
        }
    }

    var isRemindButtonVisible = true {
        didSet {
            let valid = contentView.constraint(withIdentifier: Constants.validEventConstraintIdentifier)
            let invalid = contentView.constraint(withIdentifier: Constants.outOfDateEventConstraintIdentifier)

            if isRemindButtonVisible {
                valid?.priority = 999
                invalid?.priority = 250
            } else {
                valid?.priority = 250
                invalid?.priority = 999
            }
            
            UIView.animate(withDuration: 0.2) {
                self.remindButton.isHidden = !self.isRemindButtonVisible
                self.attendButton.superview?.layoutIfNeeded()
            }
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        remindButton.layer.borderColor = UIColor.swiftOrange.cgColor
    }
}
