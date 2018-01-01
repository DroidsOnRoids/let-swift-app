//
//  EventBranding.swift
//  LetSwift
//
//  Created by Marcin Chojnacki on 01.01.2018.
//  Copyright © 2018 Droids On Roids. All rights reserved.
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

import UIKit.UIColor

enum EventBranding {
    case letSwift
    
    static let current: EventBranding = .letSwift
    
    var name: String {
        switch self {
        case .letSwift:
            return "let Swift"
        }
    }
    
    var description: String {
        return "\(platform) Developers Meet-up"
    }
    
    var apiURL: URL? {
        return try? "https://api.letswift.pl".asURL()
    }
    
    var color: UIColor {
        switch self {
        case .letSwift:
            return #colorLiteral(red: 1, green: 0.7529411765, blue: 0.2156862745, alpha: 1)
        }
    }
    
    var onboardingCards: [OnboardingCardModel] {
        let meetupsDescription = localized("ONBOARDING_MEETUPS_DESCRIPTION")
            .replacingPlaceholders(with: name, platform)
        
        return [
            OnboardingCardModel(imageName: "OnboardingMeetups",
                                title: localized("ONBOARDING_MEETUPS_TITLE"),
                                description: meetupsDescription),
            OnboardingCardModel(imageName: "OnboardingSpeakers",
                                title: localized("ONBOARDING_SPEAKERS_TITLE"),
                                description: localized("ONBOARDING_SPEAKERS_DESCRIPTION")),
            OnboardingCardModel(imageName: "OnboardingPrice",
                                title: localized("ONBOARDING_PRICE_TITLE"),
                                description: localized("ONBOARDING_PRICE_DESCRIPTION"))
        ]
    }
    
    func greetingText(with greeting: String) -> NSAttributedString {
        let printText: String
        switch self {
        case .letSwift:
            printText = "print"
        }
        
        return printText.attributed(withColor: EventBranding.current.color) +
            "(\"".attributed(withColor: .coolGrey) +
            greeting.attributed() +
            "\")".attributed(withColor: .coolGrey)
    }
    
    private var platform: String {
        switch self {
        case .letSwift:
            return "iOS"
        }
    }
}
