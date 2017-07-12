//
//  EventSummaryTableViewCell.swift
//  LetSwift
//
//  Created by Marcin Chojnacki on 26.04.2017.
//  Copyright © 2017 Droids On Roids. All rights reserved.
//

import UIKit

final class EventSummaryTableViewCell: AppTableViewCell {
    
    @IBOutlet private weak var eventTitleLabel: AppLabel!
    @IBOutlet private weak var eventDescriptionLabel: AppLabel!
    @IBOutlet private weak var indicatorView: UIImageView!
    
    var eventTitle: String? {
        get {
            return eventTitleLabel.text
        }
        set {
            eventTitleLabel.text = newValue?.uppercased()
        }
    }
    
    var eventDescription: String? {
        get {
            return eventDescriptionLabel.text
        }
        set {
            eventDescriptionLabel.text = newValue
        }
    }
    
    var isClickable: Bool {
        get {
            return selectionStyle != .none
        }
        set {
            selectionStyle = newValue ? .default : .none
            indicatorView.isHidden = !newValue
        }
    }
}
