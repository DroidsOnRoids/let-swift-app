//
//  WebsiteView.swift
//  LetSwift
//
//  Created by Marcin Chojnacki on 29.06.2017.
//  Copyright © 2017 Droids On Roids. All rights reserved.
//

import UIKit

extension SpeakerWebsite {
    var image: UIImage {
        switch self {
        case .github:
            return #imageLiteral(resourceName: "GithubIcon")
        case .website:
            return #imageLiteral(resourceName: "WebsiteIcon")
        case .twitter:
            return #imageLiteral(resourceName: "TwitterIcon")
        case .email:
            return #imageLiteral(resourceName: "EmailIcon")
        }
    }
}

class WebsiteView: DesignableView {

    @IBOutlet private weak var iconImageView: UIImageView!
    
    private var website: SpeakerWebsite?
    
    convenience init(website: SpeakerWebsite, showLabel: Bool) {
        self.init()
        iconImageView.image = website.image
    }
}
