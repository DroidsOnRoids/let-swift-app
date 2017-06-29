//
//  Speaker.swift
//  LetSwift
//
//  Created by Kinga Wilczek, Marcin Chojnacki on 16.05.2017.
//  Copyright © 2017 Droids On Roids. All rights reserved.
//

import Mapper

enum SpeakerWebsite {
    case github(url: URL)
    case website(url: URL)
    case twitter(url: URL)
    case email(email: String)
    
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
}

struct Speaker: Mappable {

    let id: Int
    let avatar: Photo?
    let name: String
    let job: String?
    let bio: String?
    
    // MARK: Extended fields
    let websites: [SpeakerWebsite]
    let talks: [Talk]
    
    init(map: Mapper) throws {
        try id = map.from("id")
        avatar = map.optionalFrom("avatar")
        try name = map.from("name")
        job = map.optionalFrom("job")
        bio = map.optionalFrom("bio")
        
        // MARK: Extended fields
        websites = SpeakerWebsite.from(githubUrl: map.optionalFrom("github_url"),
                                       websiteUrl: map.optionalFrom("website_url"),
                                       twitterUrl: map.optionalFrom("twitter_url"),
                                       emailValue: map.optionalFrom("email"))
        talks = map.optionalFrom("talks") ?? []
    }
        
    var firstName: String {
        return name.components(separatedBy: " ").first ?? name
    }
}
