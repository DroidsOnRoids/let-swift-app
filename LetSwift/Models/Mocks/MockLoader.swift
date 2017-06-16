//
//  MockLoader.swift
//  LetSwift
//
//  Created by Marcin Chojnacki on 19.05.2017.
//  Copyright © 2017 Droids On Roids. All rights reserved.
//

import Foundation

// MARK: Remove when networking layer will be available
struct MockLoader {
    
    static func loadMock(forPath path: String) -> NSDictionary? {
        guard let file = Bundle.main.url(forResource: path, withExtension: "json"),
            let data = try? Data(contentsOf: file),
            let json = try? JSONSerialization.jsonObject(with: data, options: []) else { return nil }

        return json as? NSDictionary
    }

    static func loadArrayMock(forPath path: String) -> NSArray? {
        guard let file = Bundle.main.url(forResource: path, withExtension: "json"),
            let data = try? Data(contentsOf: file),
            let json = try? JSONSerialization.jsonObject(with: data, options: []) else { return nil }

        return json as? NSArray
    }
    
    static var eventDetailsMock: NSDictionary? {
        guard let result = loadMock(forPath: "event_details") else { return nil }
        return result
    }

    static var speakersMock: NSArray? {
        guard let result = loadArrayMock(forPath: "speakers") else { return nil }
        return result
    }
}
