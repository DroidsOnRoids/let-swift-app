//
//  DefaultsManager.swift
//  LetSwift
//
//  Created by Marcin Chojnacki on 19.04.2017.
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

    var notificationsPromptShowed: Bool {
        get {
            return defaults.bool(forKey: #keyPath(DefaultsManager.notificationsPromptShowed))
        }
        set {
            defaults.set(newValue, forKey: #keyPath(DefaultsManager.notificationsPromptShowed))
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
