//
//  Speaker.swift
//  LetSwift
//
//  Created by Kinga Wilczek, Marcin Chojnacki on 16.05.2017.
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

import Mapper

struct Speaker: Mappable {

    let id: Int
    let avatar: Photo?
    let name: String
    let job: String?
    let bio: String?
    
    // MARK: Extended fields
    let websites: [SpeakerWebsite]
    var talks: [Talk]
    
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
    
    var withoutExtendedFields: Speaker {
        var newSpeaker = self
        newSpeaker.talks = []
        
        return newSpeaker
    }
}
