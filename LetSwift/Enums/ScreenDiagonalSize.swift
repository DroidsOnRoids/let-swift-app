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
        if UIScreen.main.bounds.maxY == screenSize {
            switch self {
            case .inch4¨0(let value), .inch3¨5(let value), .inch4¨7(let value), .inch5¨5(let value):
                return value
            }
        } else {
            return nil
        }
    }
    
    var screenSize: CGFloat {
        switch self {
        case .inch3¨5:
            return 480
        case .inch4¨0:
            return 568
        case .inch4¨7:
            return 667
        case .inch5¨5:
            return 736
        }
    }
}
