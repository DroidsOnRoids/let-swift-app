//
//  Localization.swift
//  LetSwift
//
//  Created by Marcin Chojnacki on 07.04.2017.
//  Copyright © 2017 Droids On Roids. All rights reserved.
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

fileprivate let localizationStrategy: LocalizationStrategy = appCompilationCondition == .debug ?
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
