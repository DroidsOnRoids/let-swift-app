//
//  ContactFieldState.swift
//  LetSwift
//
//  Created by Marcin Chojnacki on 01.06.2017.
//  Copyright © 2017 Droids On Roids. All rights reserved.
//

import UIKit

enum ContactFieldState {
    case normal
    case editing
    case error
    
    var borderColor: UIColor {
        switch self {
            case .normal: return .lightBlueGrey
            case .editing: return .swiftOrange
            case .error: return .tomato
        }
    }
}
