//
//  WebsiteView.swift
//  LetSwift
//
//  Created by Marcin Chojnacki on 29.06.2017.
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

final class WebsiteView: DesignableView {

    @IBOutlet private weak var iconImageView: UIImageView!
    @IBOutlet private weak var titleLabel: UILabel!
    
    private var website: SpeakerWebsite?
    
    convenience init(website: SpeakerWebsite, showLabel: Bool) {
        self.init()
        self.website = website
        
        iconImageView.image = website.image
        titleLabel.text = website.title
        titleLabel.isHidden = !showLabel
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        highlightView(true)
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        highlightView(false)
        
        let shouldOpen = touches.contains(where: { bounds.contains($0.location(in: self)) })
        if shouldOpen {
            website?.open()
        }
    }
    
    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
        highlightView(false)
    }
}
