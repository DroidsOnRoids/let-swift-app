//
//  Localization.swift
//  LetSwift
//
//  Created by Marcin Chojnacki on 07.04.2017.
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

enum Language: String {
    case english = "en"
    case polish = "pl"
}

fileprivate enum LocalizationStrategy {
    case automatic
    case forcedLanguage(Language)
}

fileprivate let localizationStrategy: LocalizationStrategy = isDebugBuild ?
    .automatic : .forcedLanguage(.polish)

fileprivate let fallbackLanguage: Language = .english

fileprivate func localizeAutomatic(_ key: String) -> String {
    return NSLocalizedString(key, comment: "")
}

fileprivate func localizeForced(_ key: String, forLanguage language: Language) -> String {
    guard let path = Bundle.main.path(forResource: language.rawValue, ofType: "lproj"),
        let bundle = Bundle(path: path) else { return key }
    
    return bundle.localizedString(forKey: key, value: nil, table: nil)
}

func localized(_ key: String, forLanguage language: Language) -> String {
    let localizationResult = localizeForced(key, forLanguage: language)

    if localizationResult == key && language != fallbackLanguage {
        return localizeForced(key, forLanguage: fallbackLanguage)
    } else {
        return localizationResult
    }
}

func localized(_ key: String) -> String {
    switch localizationStrategy {
    case .automatic:
        let localizationResult = localizeAutomatic(key)
        return localizationResult == key ?
            localizeForced(key, forLanguage: fallbackLanguage) : localizationResult
        
    case let .forcedLanguage(language):
        return localized(key, forLanguage: language)
    }
}
