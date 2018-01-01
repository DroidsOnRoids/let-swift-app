//
//  EventSummaryTableViewCell.swift
//  LetSwift
//
//  Created by Marcin Chojnacki on 26.04.2017.
//  Copyright © 2017 Droids On Roids. All rights reserved.
//
//  Licensed under the Apache License, Version 2.0 (the "License");
//  you may not use this file except in compliance with the License.
//  You may obtain a copy of the License at
//
//       http://www.apache.org/licenses/LICENSE-2.0
//
//  Unless required by applicable law or agreed to in writing, software
//  distributed under the License is distributed on an "AS IS" BASIS,
//  WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
//  See the License for the specific language governing permissions and
//  limitations under the License.
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
    
    var isClickable: Bool {
        get {
            return selectionStyle != .none
        }
        set {
            selectionStyle = newValue ? .default : .none
            indicatorView.isHidden = !newValue
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        setup()
    }
    
    private func setup() {
        eventTitleLabel.textColor = EventBranding.current.color
        eventDescriptionLabel.text = EventBranding.current.description
    }
}
