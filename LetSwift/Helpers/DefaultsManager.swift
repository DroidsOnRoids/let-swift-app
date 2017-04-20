//
//  DefaultsManager.swift
//  LetSwift
//
//  Created by Marcin Chojnacki on 19.04.2017.
//  Copyright © 2017 Droids On Roids. All rights reserved.
//

import Foundation

final class DefaultsManager: NSObject {
    
    static var shared = DefaultsManager()
    private let defaults = UserDefaults.standard
    
    var isOnboardingCompleted: Bool {
        get {
            return defaults.bool(forKey: #keyPath(DefaultsManager.isOnboardingCompleted))
        }
        set {
            defaults.set(newValue, forKey: #keyPath(DefaultsManager.isOnboardingCompleted))
        }
    }
    
    private override init() {
        super.init()
    }
    
    func clearDefaults() {
        if let bundle = Bundle.main.bundleIdentifier {
            defaults.removePersistentDomain(forName: bundle)
        }
    }
    
    func removeValue(forKey key: String) {
        defaults.removeObject(forKey: key)
    }
}
