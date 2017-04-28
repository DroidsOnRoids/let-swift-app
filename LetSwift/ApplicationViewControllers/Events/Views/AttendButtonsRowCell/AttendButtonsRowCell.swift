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
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        remindButton.layer.borderColor = UIColor.swiftOrange.cgColor
    }
}
