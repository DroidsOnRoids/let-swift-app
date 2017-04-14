//
//  ScreenDiagonalSize.swift
//  LetSwift
//
//  Created by Kinga Wilczek on 13.04.2017.
//  Copyright © 2017 Droids On Roids. All rights reserved.
//

import UIKit

enum DeviceScreenHeight: CGFloat {
    case inch3¨5 = 480.0
    case inch4¨0 = 568.0
    case inch4¨7 = 667.0
    case inch5¨5 = 736.0
    
    static let deviceHeight = UIScreen.main.bounds.maxY
}
