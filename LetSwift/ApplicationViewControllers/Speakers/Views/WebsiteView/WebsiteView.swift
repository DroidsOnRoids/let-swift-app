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
    
    var title: String {
        switch self {
        case .github:
            return "GitHub"
        case .website:
            return "WWW"
        case .twitter:
            return "Twitter"
        case .email:
            return "E-mail"
        }
    }
    
    func open() {
        switch self {
        case .github(let url), .website(let url), .twitter(let url):
            UIApplication.shared.openURL(url)
        case .email(let email):
            if let emailUrl = try? "mailto:\(email)".asURL() {
                UIApplication.shared.openURL(emailUrl)
            }
        }
    }
}

class WebsiteView: DesignableView {

    @IBOutlet private weak var iconImageView: UIImageView!
    @IBOutlet private weak var titleLabel: UILabel!
    
    private var website: SpeakerWebsite?
    private var isTouchDown = false
    
    convenience init(website: SpeakerWebsite, showLabel: Bool) {
        self.init()
        self.website = website
        
        iconImageView.image = website.image
        titleLabel.text = website.title
        titleLabel.isHidden = !showLabel
    }
    
    @discardableResult private func releaseTouchIfNeeded() -> Bool {
        if isTouchDown {
            isTouchDown = false
            highlightView(false)
            return true
        } else {
            return false
        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        isTouchDown = true
        highlightView(true)
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        if releaseTouchIfNeeded() {
            website?.open()
        }
    }
    
    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
        releaseTouchIfNeeded()
    }
}
