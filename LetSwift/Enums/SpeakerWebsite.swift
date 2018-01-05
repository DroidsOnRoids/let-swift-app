//
//  SpeakerWebsite.swift
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

enum SpeakerWebsite {
    case github(url: URL)
    case website(url: URL)
    case twitter(url: URL)
    case email(email: String)
    
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
    
    static func from(githubUrl: URL?, websiteUrl: URL?, twitterUrl: URL?, emailValue: String?) -> [SpeakerWebsite] {
        var websites = [SpeakerWebsite]()
        
        if let githubUrl = githubUrl {
            websites.append(github(url: githubUrl))
        }
        
        if let websiteUrl = websiteUrl {
            websites.append(website(url: websiteUrl))
        }
        
        if let twitterUrl = twitterUrl {
            websites.append(twitter(url: twitterUrl))
        }
        
        if let emailValue = emailValue {
            websites.append(email(email: emailValue))
        }
        
        return websites
    }
    
    func open() {
        switch self {
        case .github(let url), .website(let url), .twitter(let url):
            UIApplication.shared.open(url)
        case .email(let email):
            if let emailUrl = try? "mailto:\(email)".asURL() {
                UIApplication.shared.open(emailUrl)
            }
        }
    }
}
