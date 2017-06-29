//
//  Speaker.swift
//  LetSwift
//
//  Created by Kinga Wilczek, Marcin Chojnacki on 16.05.2017.
//  Copyright © 2017 Droids On Roids. All rights reserved.
//

import Mapper

struct Speaker: Mappable {

    let id: Int
    let avatar: Photo?
    let name: String
    let job: String?
    let bio: String?
    
    // MARK: Extended fields
    let email: String?
    let githubUrl: URL?
    let websiteUrl: URL?
    let twitterUrl: URL?
    let talks: [Talk]
    
    init(map: Mapper) throws {
        try id = map.from("id")
        avatar = map.optionalFrom("avatar")
        try name = map.from("name")
        job = map.optionalFrom("job")
        bio = map.optionalFrom("bio")
        
        // MARK: Extended fields
        email = map.optionalFrom("email")
        githubUrl = map.optionalFrom("github_url")
        websiteUrl = map.optionalFrom("website_url")
        twitterUrl = map.optionalFrom("twitter_url")
        talks = map.optionalFrom("talks") ?? []
    }
    
    var hasAnyWebsites: Bool {
        let websites: [Any?] = [githubUrl, websiteUrl, twitterUrl, email]
        return !websites.flatMap { $0 }.isEmpty
    }
    
    var firstName: String {
        return name.components(separatedBy: " ").first ?? name
    }
}
