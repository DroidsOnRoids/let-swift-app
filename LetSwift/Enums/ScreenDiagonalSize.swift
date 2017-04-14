//
//  ScreenDiagonalSize.swift
//  LetSwift
//
//  Created by Kinga Wilczek on 13.04.2017.
//  Copyright © 2017 Droids On Roids. All rights reserved.
//

import UIKit

enum ScreenDiagonalSize {
    case inch3¨5(CGFloat)
    case inch4¨0(CGFloat)
    case inch4¨7(CGFloat)
    case inch5¨5(CGFloat)
    
    var value: CGFloat? {
        guard UIScreen.main.bounds.maxY == screenSize else { nil }
        switch self {
        case .inch4¨0(let value), .inch3¨5(let value), .inch4¨7(let value), .inch5¨5(let value):
            return value
        }
    }
    
    var screenSize: CGFloat {
        switch self {
        case .inch3¨5:
            return 480.0
        case .inch4¨0:
            return 568.0
        case .inch4¨7:
            return 667.0
        case .inch5¨5:
            return 736.0
        }
    }
}
