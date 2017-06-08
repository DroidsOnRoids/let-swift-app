//
//  Photo.swift
//  LetSwift
//
//  Created by Kinga Wilczek, Marcin Chojnacki on 24.04.2017.
//  Copyright © 2017 Droids On Roids. All rights reserved.
//

import Mapper

struct Photo: Mappable {

    let thumb: URL?
    let big: URL?
    
    init(map: Mapper) throws {
        thumb = Photo.prependBaseURL(map.optionalFrom("thumb"))
        big = Photo.prependBaseURL(map.optionalFrom("big"))
    }
    
    private static func prependBaseURL(_ url: String?) -> URL? {
        guard let url = url else { return nil }
        return URL.baseServerURL?.appendingPathComponent(url)
    }
}
