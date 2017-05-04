//
//  EventSummaryCell.swift
//  LetSwift
//
//  Created by Marcin Chojnacki on 26.04.2017.
//  Copyright © 2017 Droids On Roids. All rights reserved.
//

import UIKit

final class EventSummaryCell: AppTableViewCell {
    
    @IBOutlet private weak var eventTitleLabel: UILabel!
    @IBOutlet private weak var eventDescriptionLabel: UILabel!
    
    var eventTitle: String? {
        get {
            return eventTitleLabel.text
        }
        set {
            guard let eventTitle = newValue else { return }
            eventTitleLabel.text = eventTitle.uppercased()
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
}
