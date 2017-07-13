//
//  EventLocationTableViewCell.swift
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

final class EventLocationTableViewCell: AppTableViewCell {
    
    @IBOutlet private weak var locationLabel: UILabel!
    
    var placeName = "" {
        didSet {
            refreshLocationLabel()
        }
    }
    
    var placeLocation = "" {
        didSet {
            refreshLocationLabel()
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        refreshLocationLabel()
    }
    
    private func refreshLocationLabel() {
        locationLabel.attributedText = (placeName.uppercased()
            .attributed(withFont: UIFont.systemFont(ofSize: 13.0, weight: UIFontWeightSemibold))
            .with(color: .black) + " — " + placeLocation.attributed()).with(spacing: 0.9)
    }
}
