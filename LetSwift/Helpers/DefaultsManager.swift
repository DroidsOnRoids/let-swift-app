//
//  DefaultsManager.swift
//  LetSwift
//
//  Created by Marcin Chojnacki on 19.04.2017.
//  Copyright © 2017 Droids On Roids. All rights reserved.
//

import Foundation

final class DefaultsManager: NSObject {
    
    static let shared = DefaultsManager()
    private let defaults = UserDefaults.standard
    
    var isOnboardingCompleted: Bool {
        get {
            return defaults.bool(forKey: #keyPath(DefaultsManager.isOnboardingCompleted))
        }
        set {
            defaults.set(newValue, forKey: #keyPath(DefaultsManager.isOnboardingCompleted))
        }
    }
    
    var isLoginSkipped: Bool {
        get {
            return defaults.bool(forKey: #keyPath(DefaultsManager.isLoginSkipped))
        }
        set {
            defaults.set(newValue, forKey: #keyPath(DefaultsManager.isLoginSkipped))
        }
    }
    
    private override init() {
        super.init()
    }
    
    func clearDefaults() {
        guard let bundle = Bundle.main.bundleIdentifier else { return }
        defaults.removePersistentDomain(forName: bundle)
    }
    
    func synchronize() {
        defaults.synchronize()
    }
}
