//
//  DefaultsManager.swift
//  LetSwift
//
//  Created by Marcin Chojnacki on 19.04.2017.
//  Copyright © 2017 Droids On Roids. All rights reserved.
//

import Foundation

struct DefaultsManager {
    
    private enum DefaultsKeys: String {
        case onboardingCompleted = "onboardingCompleted"
    }
    
    private let defaults = UserDefaults.standard
    
    func completeOnboarding() {
        defaults.set(true, forKey: DefaultsKeys.onboardingCompleted.rawValue)
    }
    
    func isOnboardingCompleted() -> Bool {
        return defaults.bool(forKey: DefaultsKeys.onboardingCompleted.rawValue)
    }
}
