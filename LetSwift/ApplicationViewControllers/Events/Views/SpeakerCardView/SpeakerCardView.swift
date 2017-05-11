//
//  SpeakerCardView.swift
//  LetSwift
//
//  Created by Marcin Chojnacki on 11.05.2017.
//  Copyright © 2017 Droids On Roids. All rights reserved.
//

import UIKit

final class SpeakerCardView: DesignableView {
    
    @IBOutlet private weak var upperSeparatorConstraint: NSLayoutConstraint!
    @IBOutlet private weak var lowerSeparatorConstraint: NSLayoutConstraint!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        upperSeparatorConstraint.constant = 1.0 / UIScreen.main.scale
        lowerSeparatorConstraint.constant = 1.0 / UIScreen.main.scale
    }
}
